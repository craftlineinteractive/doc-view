import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import 'app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('[FlutterError] ${details.exceptionAsString()}');
    };
    await pdfrxFlutterInitialize();
    runApp(
      const ProviderScope(
        child: DocReaderApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('[UncaughtAsyncError] $error\n$stack');
  });
}


