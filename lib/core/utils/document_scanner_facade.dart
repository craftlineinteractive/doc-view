import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/foundation.dart';
import 'external_activity_guard.dart';

/// Facade wrapping cunning_document_scanner with a test hook.
class DocumentScannerFacade {
  @visibleForTesting
  static List<String>? testScans;

  /// Returns pictures from the document scanner, or test scans when configured.
  static Future<List<String>?> getPictures() async {
    if (testScans != null) {
      return testScans;
    }
    return await ExternalActivityGuard.guard(() async {
      // ignore: deprecated_member_use
      return await CunningDocumentScanner.getPictures();
    });
  }
}
