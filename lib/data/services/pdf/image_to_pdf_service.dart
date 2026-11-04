import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pdf/pdf.dart' as pdflib;
import 'package:pdf/widgets.dart' as pw;

import '../../models/doc_file.dart';
import 'pdf_output_service.dart';

/// Presentation mode for pages generated from images.
enum PageMode {
  /// Standard A4 page with the image centered and scaled down to fit.
  a4,

  /// Page dimensions exactly matching the aspect ratio and size of each image.
  fitImage,
}

/// Thrown when image to PDF conversion cannot be completed.
class ImageToPdfException implements Exception {
  const ImageToPdfException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Service that compresses and converts a collection of images into a single PDF document.
class ImageToPdfService {
  ImageToPdfService({required this.outputService});

  final PdfOutputService outputService;

  /// Maximum number of images allowed in a single PDF conversion.
  static const int maxImageCount = 100;

  /// Converts [imagePaths] to a PDF file named [name].
  ///
  /// - Compresses each image one-by-one to prevent UI memory pressure.
  /// - Executes PDF compilation inside [Isolate.run].
  /// - Reports conversion progress via [onProgress].
  /// - Saves and registers the output via [PdfOutputService].
  Future<DocFile> createPdf(
    List<String> imagePaths, {
    PageMode pageMode = PageMode.a4,
    required String name,
    void Function(int done, int total)? onProgress,
  }) async {
    if (imagePaths.isEmpty) {
      throw const ImageToPdfException('Please select at least one image');
    }
    if (imagePaths.length > maxImageCount) {
      throw const ImageToPdfException(
        'Maximum $maxImageCount images allowed at a time',
      );
    }

    final total = imagePaths.length;
    final compressedImages = <Uint8List>[];

    for (var i = 0; i < total; i++) {
      final path = imagePaths[i];
      Uint8List? bytes;

      try {
        bytes = await FlutterImageCompress.compressWithFile(
          path,
          minWidth: 1600,
          minHeight: 1600,
          quality: 80,
          format: CompressFormat.jpeg,
        );
      } catch (_) {
        // Fall back to reading original bytes if native compression fails
      }

      if (bytes == null || bytes.isEmpty) {
        final file = File(path);
        if (await file.exists()) {
          bytes = await file.readAsBytes();
        }
      }

      if (bytes == null || bytes.isEmpty) {
        throw ImageToPdfException('Failed to process image: $path');
      }

      compressedImages.add(bytes);
      onProgress?.call(i + 1, total);
    }

    // Heavy PDF generation in background isolate
    final pdfBytes = await _compilePdfInIsolate(compressedImages, pageMode);

    final outputFile = await outputService.uniqueFile(name);
    await outputFile.writeAsBytes(pdfBytes);

    return outputService.registerOutput(outputFile);
  }

  /// Pure worker function executed on a dedicated background isolate.
  static Future<Uint8List> _compilePdfInIsolate(
    List<Uint8List> images,
    PageMode pageMode,
  ) {
    return Isolate.run(() {
      final doc = pw.Document();

      for (final imageBytes in images) {
        final image = pw.MemoryImage(imageBytes);
        final pdflib.PdfPageFormat format;

        if (pageMode == PageMode.fitImage &&
            image.width != null &&
            image.height != null &&
            image.width! > 0 &&
            image.height! > 0) {
          format = pdflib.PdfPageFormat(
            image.width!.toDouble(),
            image.height!.toDouble(),
            marginAll: 0,
          );
        } else {
          format = pdflib.PdfPageFormat.a4;
        }

        doc.addPage(
          pw.Page(
            pageFormat: format,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
              return pw.FullPage(
                ignoreMargins: true,
                child: pw.Center(
                  child: pw.Image(
                    image,
                    fit: pageMode == PageMode.fitImage
                        ? pw.BoxFit.fill
                        : pw.BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        );
      }

      return doc.save();
    });
  }
}

