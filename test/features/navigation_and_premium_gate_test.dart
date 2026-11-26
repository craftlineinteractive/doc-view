import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/router/app_router.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/services/billing/billing_providers.dart';
import 'package:docview/data/services/convert/pdf_to_word_service.dart';
import 'package:docview/features/premium/premium_screen.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/convert/pdf_to_word_screen.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:docview/shared/widgets/navigation/doc_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakePdfToWordService extends PdfToWordService {
  @override
  Future<PdfTextPreflightResult> checkTextLayer({
    required String sourcePath,
    String? password,
  }) async {
    return const PdfTextPreflightResult(
      hasText: true,
      pageCount: 1,
      totalCharacters: 100,
      isEncrypted: false,
    );
  }
}

class _TestRouteObserver extends NavigatorObserver {
  final List<String?> pushedRoutes = [];
  final List<String?> poppedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    poppedRoutes.add(route.settings.name);
    super.didPop(route, previousRoute);
  }
}

DocFile _mockDocFile({required String name}) {
  return DocFile(
    id: 1,
    path: '/data/user/0/com.craftlineinteractive.docview/files/$name',
    name: name,
    extension: '.pdf',
    sizeBytes: 1024 * 100,
    modified: DateTime(2026, 11, 1),
    category: FileCategory.pdf,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase B1: MainShell PopScope & Back Tab Navigation', () {
    testWidgets('Back on non-first tab returns to tab 0 (Home), back on tab 0 exits', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routerInitialLocationProvider.overrideWithValue('/tools'),
            createdFilesProvider.overrideWith((ref) => Future.value([])),
            categoryCountsProvider.overrideWith((ref) => Future.value(<FileCategory, int>{})),
            filesProvider(FileCategory.pdf).overrideWith((ref) => Future.value(<DocFile>[])),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final router = ref.watch(routerProvider);
              return MaterialApp.router(
                routerConfig: router,
                theme: AppTheme.lightTheme,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Tools tab (tab 1) via DocBottomNavBar
      final toolsNavItem = find.descendant(
        of: find.byType(DocBottomNavBar),
        matching: find.text('Tools'),
      );
      await tester.tap(toolsNavItem);
      await tester.pumpAndSettle();

      // Simulate back invocation on MainShell
      final popScopeFinder = find.byKey(const ValueKey('main_shell_pop_scope'));
      var popScope = tester.widget<PopScope>(popScopeFinder);
      expect(popScope.canPop, isFalse);

      // Trigger pop invoked
      popScope.onPopInvokedWithResult!(false, null);
      await tester.pumpAndSettle();

      // Now on /home (tab 0)
      popScope = tester.widget<PopScope>(popScopeFinder);
      expect(popScope.canPop, isTrue);
    });
  });

  group('Phase B1: Premium Gate & Tool Stack Routing in 3 States', () {
    Widget buildTestApp({
      required bool locksActive,
      required bool isPremium,
      required _TestRouteObserver observer,
      String initialRoute = '/tools',
    }) {
      return ProviderScope(
        overrides: [
          routerInitialLocationProvider.overrideWithValue(initialRoute),
          locksActiveProvider.overrideWithValue(locksActive),
          isPremiumProvider.overrideWithValue(isPremium),
          createdFilesProvider.overrideWith((ref) => Future.value([])),
          categoryCountsProvider.overrideWith((ref) => Future.value(<FileCategory, int>{})),
          filesProvider(FileCategory.pdf).overrideWith((ref) => Future.value([
            _mockDocFile(name: 'sample.pdf'),
          ])),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
              theme: AppTheme.lightTheme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      );
    }

    testWidgets('State 1: Locks inactive -> Annotate tile does not push /premium', (tester) async {
      final observer = _TestRouteObserver();
      await tester.pumpWidget(
        buildTestApp(locksActive: false, isPremium: false, observer: observer),
      );
      await tester.pumpAndSettle();

      // Tap Annotate tool
      final annotateTile = find.byKey(const Key('tool_annotate'));
      expect(annotateTile, findsOneWidget);
      await tester.tap(annotateTile);
      await tester.pumpAndSettle();

      // /premium was not pushed; picker is shown
      expect(find.byType(PremiumScreen), findsNothing);
      expect(find.text('Annotate'), findsWidgets);
    });

    testWidgets('State 2: Locks active & User Free -> Annotate tile pushes /premium; Back returns to Tools', (tester) async {
      final observer = _TestRouteObserver();
      await tester.pumpWidget(
        buildTestApp(locksActive: true, isPremium: false, observer: observer),
      );
      await tester.pumpAndSettle();

      // Tap Annotate tool (paid feature)
      final annotateTile = find.byKey(const Key('tool_annotate'));
      expect(annotateTile, findsOneWidget);
      await tester.tap(annotateTile);
      await tester.pumpAndSettle();

      // /premium was pushed on top of stack
      expect(find.byType(PremiumScreen), findsOneWidget);

      // Tap Close button on Premium screen
      final closeButton = find.byKey(const Key('btn_premium_close')).hitTestable();
      if (closeButton.evaluate().isNotEmpty) {
        await tester.tap(closeButton);
      } else {
        // Fallback to close icon
        final closeIcon = find.byWidgetPredicate(
          (w) => w is IconButton || (w.runtimeType.toString() == 'DocIconButton'),
        ).first;
        await tester.tap(closeIcon);
      }
      await tester.pumpAndSettle();

      // Back returns to Tools tab
      expect(find.byType(PremiumScreen), findsNothing);
      expect(find.byType(ToolsScreen), findsOneWidget);
    });

    testWidgets('State 3: User is Premium -> Annotate tile opens directly without /premium', (tester) async {
      final observer = _TestRouteObserver();
      await tester.pumpWidget(
        buildTestApp(locksActive: true, isPremium: true, observer: observer),
      );
      await tester.pumpAndSettle();

      // Tap Annotate tile
      final annotateTile = find.byKey(const Key('tool_annotate'));
      expect(annotateTile, findsOneWidget);
      await tester.tap(annotateTile);
      await tester.pumpAndSettle();

      // Opens picker directly, no /premium
      expect(find.byType(PremiumScreen), findsNothing);
      expect(find.text('Annotate'), findsWidgets);
    });

    testWidgets('State 2: Locks active & User Free -> Sign tile pushes /premium; Back returns to Tools', (tester) async {
      final observer = _TestRouteObserver();
      await tester.pumpWidget(
        buildTestApp(locksActive: true, isPremium: false, observer: observer),
      );
      await tester.pumpAndSettle();

      // Tap Sign tool (paid feature)
      final signTile = find.byKey(const Key('tool_sign'));
      expect(signTile, findsOneWidget);
      await tester.tap(signTile);
      await tester.pumpAndSettle();

      // /premium was pushed
      expect(find.byType(PremiumScreen), findsOneWidget);

      // Tap close button
      final closeIcon = find.byWidgetPredicate(
        (w) => w is IconButton || (w.runtimeType.toString() == 'DocIconButton'),
      ).first;
      await tester.tap(closeIcon);
      await tester.pumpAndSettle();

      // Back returns to Tools tab
      expect(find.byType(PremiumScreen), findsNothing);
      expect(find.byType(ToolsScreen), findsOneWidget);
    });
  });

  group('Phase B1: PdfToWordScreen Picker Return and Back Navigation', () {
    testWidgets('PdfToWordScreen shows empty picker, back button exits to previous screen when no file', (tester) async {
      var didPop = false;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pdfToWordServiceProvider.overrideWithValue(_FakePdfToWordService()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PdfToWordScreen()),
                      );
                      didPop = true;
                    },
                    child: const Text('Open PdfToWord'),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open PdfToWord'));
      await tester.pumpAndSettle();

      expect(find.byType(PdfToWordScreen), findsOneWidget);
      expect(find.text('Select PDF'), findsOneWidget);

      // Tap AppBar back button
      final backButton = find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == 'DocIconButton',
      );
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(didPop, isTrue);
      expect(find.byType(PdfToWordScreen), findsNothing);
    });

    testWidgets('PdfToWordScreen with file resets to empty picker on Back, then pops on second Back', (tester) async {
      final sampleFile = _mockDocFile(name: 'contract.pdf');
      var didPop = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pdfToWordServiceProvider.overrideWithValue(_FakePdfToWordService()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PdfToWordScreen(initialFile: null),
                        ),
                      );
                      didPop = true;
                    },
                    child: const Text('Open'),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Select PDF'), findsOneWidget);

      // Access state to simulate file picked
      final state = tester.state(find.byType(PdfToWordScreen)) as dynamic;
      // ignore: invalid_use_of_protected_member
      state.setState(() {
        state.selectedFileForTesting = sampleFile;
      });
      await tester.pumpAndSettle();

      // Now showing file card and change file button
      expect(find.text('contract.pdf'), findsOneWidget);
      expect(find.text('Change file'), findsOneWidget);

      // Press Back (AppBar leading button)
      final backButton = find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == 'DocIconButton',
      );
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Must NOT have popped the screen yet; resets to empty picker
      expect(didPop, isFalse);
      expect(find.byType(PdfToWordScreen), findsOneWidget);
      expect(find.text('Select PDF'), findsOneWidget);

      // Press Back again on empty picker
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Now popped
      expect(didPop, isTrue);
      expect(find.byType(PdfToWordScreen), findsNothing);
    });

    testWidgets('PdfToWordScreen opened from reader with initialFile pops immediately on Back', (tester) async {
      final sampleFile = _mockDocFile(name: 'reader_source.pdf');
      var didPop = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pdfToWordServiceProvider.overrideWithValue(_FakePdfToWordService()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PdfToWordScreen(initialFile: sampleFile),
                        ),
                      );
                      didPop = true;
                    },
                    child: const Text('From Reader'),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('From Reader'));
      await tester.pumpAndSettle();

      expect(find.byType(PdfToWordScreen), findsOneWidget);
      expect(find.text('reader_source.pdf'), findsOneWidget);

      // Press Back
      final backButton = find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == 'DocIconButton',
      );
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Immediately pops back to reader
      expect(didPop, isTrue);
      expect(find.byType(PdfToWordScreen), findsNothing);
    });
  });
}
