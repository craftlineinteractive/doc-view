import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart' as pdflib;
import 'package:pdf/widgets.dart' as pw;

import '../../../data/models/doc_file.dart';
import '../../../data/services/pdf/pdf_output_service.dart';
import 'paper_template.dart';

/// Reasons for CreatePdf operation failures.
enum CreatePdfErrorReason {
  pageCountOutOfRange,
  invalidFileName,
  generationFailed,
  saveFailed,
}

/// Typed exception thrown when Create PDF fails.
@immutable
class CreatePdfException implements Exception {
  const CreatePdfException(this.reason, {this.details});

  final CreatePdfErrorReason reason;
  final String? details;

  @override
  String toString() => 'CreatePdfException: $reason ($details)';
}

/// Plain immutable data transfer object sent across isolate boundaries.
@immutable
class CreatePdfParams {
  const CreatePdfParams({
    required this.templateIndex,
    required this.pageSizeIndex,
    required this.orientationIndex,
    required this.colorValue,
    required this.pageCount,
    required this.title,
    this.progressSendPort,
    this.compress = true,
  });

  final int templateIndex;
  final int pageSizeIndex;
  final int orientationIndex;
  final int colorValue;
  final int pageCount;
  final String title;
  final SendPort? progressSendPort;
  final bool compress;
}

/// Top-level worker function executing inside a background isolate.
///
/// Builds a clean vector-only PDF document without embedding fonts.
/// All stroke segments of the same role are batched into a single path call.
Future<Uint8List> compileTemplatePdfInWorker(CreatePdfParams params) async {
  final template = PaperTemplate.values[params.templateIndex];
  final pageSize = PaperPageSize.values[params.pageSizeIndex];
  final orientation = PaperOrientation.values[params.orientationIndex];

  final widthPt = pageSize.getWidth(orientation);
  final heightPt = pageSize.getHeight(orientation);

  // Compute geometry primitives using the single source of truth
  final primitives = computePaperDrawingPrimitives(
    template: template,
    widthPt: widthPt,
    heightPt: heightPt,
  );

  // Group strokes by role for batched single-path drawing
  final minorStrokes = primitives.where((p) => p.role == StrokeRole.minor).toList();
  final majorStrokes = primitives.where((p) => p.role == StrokeRole.major).toList();
  final marginStrokes = primitives.where((p) => p.role == StrokeRole.margin).toList();

  // Compute blended opaque colors
  final bgPdfColor = pdflib.PdfColor.fromInt(params.colorValue);
  final minorPdfColor = pdflib.PdfColor.fromInt(
    blendStrokeColor(params.colorValue, StrokeRole.minor),
  );
  final majorPdfColor = pdflib.PdfColor.fromInt(
    blendStrokeColor(params.colorValue, StrokeRole.major),
  );
  final marginPdfColor = pdflib.PdfColor.fromInt(
    blendStrokeColor(params.colorValue, StrokeRole.margin),
  );

  final doc = pw.Document(
    title: params.title,
    author: 'Doc View',
    creator: 'Doc View',
    compress: params.compress,
  );

  final pageFormat = pdflib.PdfPageFormat(widthPt, heightPt, marginAll: 0);
  final pageTheme = pw.PageTheme(pageFormat: pageFormat, margin: pw.EdgeInsets.zero);

  void drawStrokes(
    pdflib.PdfGraphics canvas,
    pdflib.PdfPoint size,
    List<PaperStrokePrimitive> strokes,
    pdflib.PdfColor color,
    double lineWidth,
  ) {
    if (strokes.isEmpty) return;
    canvas
      ..saveContext()
      ..setStrokeColor(color)
      ..setLineWidth(lineWidth);

    for (final s in strokes) {
      // PDF coordinate system origin is bottom-left, invert y from top-left
      canvas
        ..moveTo(s.x1, size.y - s.y1)
        ..lineTo(s.x2, size.y - s.y2);
    }

    canvas
      ..strokePath()
      ..restoreContext();
  }

  for (var pageIdx = 0; pageIdx < params.pageCount; pageIdx++) {
    doc.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              color: bgPdfColor,
              child: pw.CustomPaint(
                size: pdflib.PdfPoint(widthPt, heightPt),
                painter: (pdflib.PdfGraphics canvas, pdflib.PdfPoint size) {
                  drawStrokes(canvas, size, minorStrokes, minorPdfColor, 0.5);
                  drawStrokes(canvas, size, majorStrokes, majorPdfColor, 1.0);
                  drawStrokes(canvas, size, marginStrokes, marginPdfColor, 1.0);
                },
              ),
            ),
          );
        },
      ),
    );

    params.progressSendPort?.send(pageIdx + 1);
  }

  return await doc.save();
}

/// Service that generates custom blank paper template PDFs off the main isolate.
class CreatePdfService {
  CreatePdfService({required this.outputService});

  final PdfOutputService outputService;

  /// Generates a PDF with [template], [pageSize], [orientation], [colorSwatch], and [pageCount].
  ///
  /// - Enforces page count in range 1..100.
  /// - Sanitizes file name and saves into `created/` directory.
  /// - Offloads rendering and PDF compilation to a background isolate via [Isolate.run].
  /// - Reports progress if [onProgress] is supplied.
  /// - Registers output file into the document database.
  Future<DocFile> generateTemplatePdf({
    required PaperTemplate template,
    required PaperPageSize pageSize,
    required PaperOrientation orientation,
    required PaperColorSwatch colorSwatch,
    required int pageCount,
    required String fileName,
    void Function(int done, int total)? onProgress,
    bool compress = true,
  }) async {
    if (pageCount < 1 || pageCount > 100) {
      throw const CreatePdfException(CreatePdfErrorReason.pageCountOutOfRange);
    }

    final sanitizedName = PdfOutputService.sanitizeFileName(fileName);
    if (sanitizedName.isEmpty) {
      throw const CreatePdfException(CreatePdfErrorReason.invalidFileName);
    }

    ReceivePort? receivePort;
    Stream<dynamic>? progressStream;

    if (onProgress != null) {
      receivePort = ReceivePort();
      progressStream = receivePort.asBroadcastStream();
      progressStream.listen((data) {
        if (data is int) {
          onProgress(data, pageCount);
        }
      });
    }

    try {
      final params = CreatePdfParams(
        templateIndex: template.index,
        pageSizeIndex: pageSize.index,
        orientationIndex: orientation.index,
        colorValue: colorSwatch.colorValue,
        pageCount: pageCount,
        title: sanitizedName,
        progressSendPort: receivePort?.sendPort,
        compress: compress,
      );

      final pdfBytes = await Isolate.run(() => compileTemplatePdfInWorker(params));

      final outputFile = await outputService.uniqueFile(sanitizedName);
      await outputFile.writeAsBytes(pdfBytes);

      return await outputService.registerOutput(outputFile);
    } catch (e, st) {
      if (e is CreatePdfException) rethrow;
      throw CreatePdfException(
        CreatePdfErrorReason.generationFailed,
        details: '$e\n$st',
      );
    } finally {
      receivePort?.close();
    }
  }
}
