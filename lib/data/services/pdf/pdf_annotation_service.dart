// ignore_for_file: implementation_imports

import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/forms/pdf_signature_field.dart' as sf_sig;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/pages/pdf_page.dart' as sf_page;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_array.dart' as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_name.dart' as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_number.dart' as sf_prim;

import '../../../core/errors/app_errors.dart';
import '../../models/pdf_markup.dart';
import 'pdf_coordinate_transform.dart';

/// Metadata inspection results for a PDF document.
class PdfDocumentInfo {
  final int pageCount;
  final bool isEncrypted;
  final bool hasDigitalSignature;
  final List<int> pageRotations;
  final List<Size> pageSizes;

  const PdfDocumentInfo({
    required this.pageCount,
    required this.isEncrypted,
    required this.hasDigitalSignature,
    required this.pageRotations,
    required this.pageSizes,
  });

  Map<String, dynamic> toMap() => {
        'pageCount': pageCount,
        'isEncrypted': isEncrypted,
        'hasDigitalSignature': hasDigitalSignature,
        'pageRotations': pageRotations,
        'pageSizes': pageSizes.map((s) => [s.width, s.height]).toList(),
      };

  factory PdfDocumentInfo.fromMap(Map<String, dynamic> map) => PdfDocumentInfo(
        pageCount: map['pageCount'] as int,
        isEncrypted: map['isEncrypted'] as bool,
        hasDigitalSignature: map['hasDigitalSignature'] as bool,
        pageRotations: List<int>.from(map['pageRotations'] as List),
        pageSizes: (map['pageSizes'] as List)
            .map((e) => Size((e[0] as num).toDouble(), (e[1] as num).toDouble()))
            .toList(),
      );
}

/// Service that executes PDF annotation operations (inspecting, saving markups)
/// in background isolates using Syncfusion PDF engine.
class PdfAnnotationService {
  final Future<PdfDocumentInfo> Function(String filePath, {String? password})?
      getDocumentInfoHook;
  final Future<File> Function({
    required String sourcePath,
    required String outputPath,
    required List<TextMarkup> markups,
    String? password,
    bool replaceOriginal,
    String? originalPath,
  })? saveAnnotationsHook;

  const PdfAnnotationService({
    this.getDocumentInfoHook,
    this.saveAnnotationsHook,
  });

  /// Inspects [filePath] and returns its structural metadata.
  Future<PdfDocumentInfo> getDocumentInfo(
    String filePath, {
    String? password,
  }) async {
    if (getDocumentInfoHook != null) {
      return getDocumentInfoHook!(filePath, password: password);
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      throw PdfAnnotationException(
        PdfAnnotationErrorReason.sourceFileNotFound,
        filePath,
      );
    }

    final params = _GetDocInfoParams(
      path: filePath,
      password: password,
    );

    return Isolate.run(() => _runGetDocumentInfo(params));
  }

  /// Applies [markups] to [sourcePath] and saves the annotated PDF to [outputPath].
  ///
  /// If [replaceOriginal] is true, writes to a temporary file first and atomically
  /// replaces [originalPath] (or [outputPath] if [originalPath] is null).
  ///
  /// Replaces of digitally signed documents are strictly rejected with
  /// [PdfAnnotationErrorReason.signedDocumentReplaceBlocked].
  Future<File> saveAnnotations({
    required String sourcePath,
    required String outputPath,
    required List<TextMarkup> markups,
    String? password,
    bool replaceOriginal = false,
    String? originalPath,
  }) async {
    if (saveAnnotationsHook != null) {
      return saveAnnotationsHook!(
        sourcePath: sourcePath,
        outputPath: outputPath,
        markups: markups,
        password: password,
        replaceOriginal: replaceOriginal,
        originalPath: originalPath,
      );
    }

    final file = File(sourcePath);
    if (!file.existsSync()) {
      throw PdfAnnotationException(
        PdfAnnotationErrorReason.sourceFileNotFound,
        sourcePath,
      );
    }

    final rawMarkups = markups.map((m) => m.toMap()).toList(growable: false);

    final params = _SaveAnnotationsParams(
      sourcePath: sourcePath,
      outputPath: outputPath,
      markups: rawMarkups,
      password: password,
      replaceOriginal: replaceOriginal,
      originalPath: originalPath ?? (replaceOriginal ? outputPath : null),
    );

    final finalPath = await Isolate.run(() => _runSaveAnnotations(params));
    return File(finalPath);
  }
}

// ---------------------------------------------------------------------------
// Isolate Parameter DTOs (plain primitives only)
// ---------------------------------------------------------------------------

class _GetDocInfoParams {
  final String path;
  final String? password;

  const _GetDocInfoParams({
    required this.path,
    this.password,
  });
}

class _SaveAnnotationsParams {
  final String sourcePath;
  final String outputPath;
  final List<Map<String, dynamic>> markups;
  final String? password;
  final bool replaceOriginal;
  final String? originalPath;

  const _SaveAnnotationsParams({
    required this.sourcePath,
    required this.outputPath,
    required this.markups,
    this.password,
    this.replaceOriginal = false,
    this.originalPath,
  });
}

// ---------------------------------------------------------------------------
// Top-Level Worker Functions Executed in Background Isolates
// ---------------------------------------------------------------------------

int _getRotationDegrees(sf.PdfPageRotateAngle angle) {
  switch (angle) {
    case sf.PdfPageRotateAngle.rotateAngle90:
      return 90;
    case sf.PdfPageRotateAngle.rotateAngle180:
      return 180;
    case sf.PdfPageRotateAngle.rotateAngle270:
      return 270;
    case sf.PdfPageRotateAngle.rotateAngle0:
      return 0;
  }
}

Rect? _getPageCropBox(sf.PdfPage page) {
  try {
    final helper = sf_page.PdfPageHelper.getHelper(page);
    final cb = helper.dictionary?['CropBox'];
    if (cb is sf_prim.PdfArray && cb.count >= 4) {
      final x1 = (cb[0] as sf_prim.PdfNumber).value?.toDouble() ?? 0.0;
      final y1 = (cb[1] as sf_prim.PdfNumber).value?.toDouble() ?? 0.0;
      final x2 = (cb[2] as sf_prim.PdfNumber).value?.toDouble() ?? 0.0;
      final y2 = (cb[3] as sf_prim.PdfNumber).value?.toDouble() ?? 0.0;
      return Rect.fromLTRB(
        math.min(x1, x2),
        math.min(y1, y2),
        math.max(x1, x2),
        math.max(y1, y2),
      );
    }
  } catch (_) {}
  return null;
}

bool _hasDigitalSignatures(sf.PdfDocument doc) {
  try {
    for (var i = 0; i < doc.form.fields.count; i++) {
      final field = doc.form.fields[i];
      if (field is sf.PdfSignatureField) {
        final helper = sf_sig.PdfSignatureFieldHelper.getHelper(field);
        if (helper.isLoadedSign || field.signature != null) {
          return true;
        }
        if (helper.dictionary?.containsKey(sf_prim.PdfName('V')) ?? false) {
          return true;
        }
      }
    }
  } catch (_) {}
  return false;
}

PdfDocumentInfo _runGetDocumentInfo(_GetDocInfoParams params) {
  final file = File(params.path);
  if (!file.existsSync()) {
    throw PdfAnnotationException(
      PdfAnnotationErrorReason.sourceFileNotFound,
      params.path,
    );
  }

  final bytes = file.readAsBytesSync();
  sf.PdfDocument doc;
  try {
    doc = sf.PdfDocument(inputBytes: bytes, password: params.password);
  } catch (e) {
    final err = e.toString().toLowerCase();
    if (err.contains('password') || err.contains('encrypt')) {
      throw const PdfAnnotationException(
        PdfAnnotationErrorReason.passwordProtected,
      );
    }
    throw PdfAnnotationException(
      PdfAnnotationErrorReason.corruptDocument,
      e.toString(),
    );
  }

  final pageCount = doc.pages.count;
  final rotations = <int>[];
  final sizes = <Size>[];

  for (var i = 0; i < pageCount; i++) {
    final page = doc.pages[i];
    rotations.add(_getRotationDegrees(page.rotation));
    sizes.add(Size(page.size.width, page.size.height));
  }

  final isSigned = _hasDigitalSignatures(doc);
  doc.dispose();

  return PdfDocumentInfo(
    pageCount: pageCount,
    isEncrypted: params.password != null && params.password!.isNotEmpty,
    hasDigitalSignature: isSigned,
    pageRotations: rotations,
    pageSizes: sizes,
  );
}

Future<String> _runSaveAnnotations(_SaveAnnotationsParams params) async {
  final file = File(params.sourcePath);
  if (!file.existsSync()) {
    throw PdfAnnotationException(
      PdfAnnotationErrorReason.sourceFileNotFound,
      params.sourcePath,
    );
  }

  final bytes = file.readAsBytesSync();
  sf.PdfDocument doc;
  try {
    doc = sf.PdfDocument(inputBytes: bytes, password: params.password);
  } catch (e) {
    final err = e.toString().toLowerCase();
    if (err.contains('password') || err.contains('encrypt')) {
      throw const PdfAnnotationException(
        PdfAnnotationErrorReason.passwordProtected,
      );
    }
    throw PdfAnnotationException(
      PdfAnnotationErrorReason.corruptDocument,
      e.toString(),
    );
  }

  final pageCount = doc.pages.count;
  final isSigned = _hasDigitalSignatures(doc);

  if (params.replaceOriginal && isSigned) {
    doc.dispose();
    throw const PdfAnnotationException(
      PdfAnnotationErrorReason.signedDocumentReplaceBlocked,
    );
  }

  final parsedMarkups = params.markups.map((m) => TextMarkup.fromMap(m)).toList();

  // Group markups by page index
  final markupsByPage = <int, List<TextMarkup>>{};
  for (final m in parsedMarkups) {
    if (m.pageIndex >= 0 && m.pageIndex < pageCount) {
      markupsByPage.putIfAbsent(m.pageIndex, () => []).add(m);
    }
  }

  for (final entry in markupsByPage.entries) {
    final pageIndex = entry.key;
    final page = doc.pages[pageIndex];
    final rotDegrees = _getRotationDegrees(page.rotation);
    final cropBox = _getPageCropBox(page);

    final visualWidth = (rotDegrees == 90 || rotDegrees == 270)
        ? page.size.height
        : page.size.width;
    final visualHeight = (rotDegrees == 90 || rotDegrees == 270)
        ? page.size.width
        : page.size.height;

    for (final markup in entry.value) {
      final syncLines = markup.lineRects.map((visualRect) {
        return PdfCoordinateTransform.visualToSyncfusionRect(
          visualRect: visualRect,
          visualWidth: visualWidth,
          visualHeight: visualHeight,
          rotationDegrees: rotDegrees,
          cropBox: cropBox,
        );
      }).toList();

      final unionRect = syncLines.isNotEmpty
          ? syncLines.reduce((a, b) => a.expandToInclude(b))
          : Rect.zero;

      sf.PdfTextMarkupAnnotationType annotType;
      switch (markup.type) {
        case TextMarkupType.underline:
          annotType = sf.PdfTextMarkupAnnotationType.underline;
          break;
        case TextMarkupType.strikethrough:
          annotType = sf.PdfTextMarkupAnnotationType.strikethrough;
          break;
        case TextMarkupType.highlight:
          annotType = sf.PdfTextMarkupAnnotationType.highlight;
          break;
      }

      final color = Color(markup.colorValue);
      final sfColor = sf.PdfColor(
        (color.r * 255.0).round(),
        (color.g * 255.0).round(),
        (color.b * 255.0).round(),
      );

      final sfAnnotation = sf.PdfTextMarkupAnnotation(
        unionRect,
        markup.text,
        sfColor,
        boundsCollection: syncLines,
        textMarkupAnnotationType: annotType,
      );

      page.annotations.add(sfAnnotation);
    }
  }

  final savedBytes = doc.saveSync();
  doc.dispose();

  // Post-save verification
  try {
    final verifyDoc = sf.PdfDocument(inputBytes: savedBytes);
    if (verifyDoc.pages.count != pageCount) {
      verifyDoc.dispose();
      throw const PdfAnnotationException(
        PdfAnnotationErrorReason.saveFailed,
        'Post-save verification failed: page count altered',
      );
    }
    verifyDoc.dispose();
  } catch (e) {
    if (e is PdfAnnotationException) rethrow;
    throw PdfAnnotationException(
      PdfAnnotationErrorReason.saveFailed,
      'Post-save verification failed: $e',
    );
  }

  // Atomic file write
  final finalDestination = params.replaceOriginal
      ? (params.originalPath ?? params.outputPath)
      : params.outputPath;

  final tempFile = File('${params.outputPath}.tmp');
  if (!tempFile.parent.existsSync()) {
    tempFile.parent.createSync(recursive: true);
  }

  try {
    tempFile.writeAsBytesSync(savedBytes, flush: true);
    try {
      if (File(finalDestination).existsSync()) {
        File(finalDestination).deleteSync();
      }
      tempFile.renameSync(finalDestination);
    } catch (_) {
      // Fallback for cross-filesystem moves
      tempFile.copySync(finalDestination);
      tempFile.deleteSync();
    }
    return finalDestination;
  } catch (e) {
    try {
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
    } catch (_) {}
    throw PdfAnnotationException(
      PdfAnnotationErrorReason.saveFailed,
      e.toString(),
    );
  }
}

/// Riverpod provider for [PdfAnnotationService].
final pdfAnnotationServiceProvider = Provider<PdfAnnotationService>((ref) {
  return const PdfAnnotationService();
});
