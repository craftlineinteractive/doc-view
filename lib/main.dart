import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import 'app.dart';
import 'data/services/trash_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('[FlutterError] ${details.exceptionAsString()}');
    };
    await pdfrxFlutterInitialize();
    await TrashService.initFromPrefs();
    runApp(
      const ProviderScope(
        child: DocReaderApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('[UncaughtAsyncError] $error\n$stack');
  });
}


