import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/foundation.dart';

/// Facade wrapping cunning_document_scanner with a test hook.
class DocumentScannerFacade {
  @visibleForTesting
  static List<String>? testScans;

  /// Returns pictures from the document scanner, or test scans when configured.
  static Future<List<String>?> getPictures() async {
    if (testScans != null) {
      return testScans;
    }
    // ignore: deprecated_member_use
    return await CunningDocumentScanner.getPictures();
  }
}
