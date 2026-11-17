import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/l10n/app_localizations.dart';

/// Test helper providing standard app wrapper with Riverpod [ProviderScope],
/// localized delegates, custom locales (e.g. en_XA), and directional text layouts.
extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    Locale locale = const Locale('en'),
    TextDirection textDirection = TextDirection.ltr,
    double textScale = 1.0,
    ThemeMode themeMode = ThemeMode.light,
    List<dynamic> overrides = const [],
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [for (final o in overrides) o],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          builder: (context, child) {
            return Directionality(
              textDirection: textDirection,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(textScale),
                ),
                child: child!,
              ),
            );
          },
          home: widget,
        ),
      ),
    );
  }
}
