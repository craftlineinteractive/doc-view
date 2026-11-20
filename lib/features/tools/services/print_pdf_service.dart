import 'dart:io';

import 'package:printing/printing.dart';

import '../../../core/errors/app_errors.dart';
import '../../../data/models/doc_file.dart';

/// Dedicated service encapsulating PDF print logic and constraints.
///
/// Limits:
/// - Maximum file size: 50 MB
/// - Direct unencrypted PDF byte delivery to platform print spooler
/// - Typed errors mapped to [PrintPdfException]
class PrintPdfService {
  const PrintPdfService();

  /// Maximum allowed PDF file size for printing (50 MB).
  static const int maxPrintSizeBytes = 50 * 1024 * 1024;

  /// Spools the target [file] for printing via the platform print dialog.
  ///
  /// Throws [PrintPdfException] on validation failure or execution error.
  Future<bool> printDocument(DocFile file) async {
    final ioFile = File(file.path);
    if (!await ioFile.exists()) {
      throw const PrintPdfException(PrintPdfErrorReason.fileNotFound);
    }

    final stat = await ioFile.stat();
    if (stat.size > maxPrintSizeBytes) {
      throw const PrintPdfException(PrintPdfErrorReason.fileTooLarge);
    }

    try {
      final bytes = await ioFile.readAsBytes();
      return await Printing.layoutPdf(
        onLayout: (format) async => bytes,
        name: file.name,
      );
    } on PrintPdfException {
      rethrow;
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('password') || msg.contains('encrypt')) {
        throw PrintPdfException(
          PrintPdfErrorReason.passwordProtected,
          e.toString(),
        );
      }
      throw PrintPdfException(
        PrintPdfErrorReason.printFailed,
        e.toString(),
      );
    }
  }
}
