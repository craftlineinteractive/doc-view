import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:docview/features/settings/faq_screen.dart';
import 'package:docview/l10n/app_localizations.dart';

void main() {
  group('FAQ and Privacy Wording Verification', () {
    testWidgets('FAQ contains Question 10 about ads and approved answer', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final l10n = AppLocalizations.of(capturedContext)!;
      final questions = FaqScreen.questions(capturedContext);

      expect(questions.length, greaterThanOrEqualTo(10));

      final faq10 = questions.firstWhere(
        (q) => q.question == l10n.faqQuestion10,
      );

      expect(faq10.question, contains('Why does Doc View show ads?'));
      expect(faq10.answer, contains('Google AdMob'));
      expect(faq10.answer, contains('never see your documents'));

      // Check FAQ 6 keeps approved text
      final faq6 = questions.firstWhere(
        (q) => q.question == l10n.faqQuestion6,
      );
      expect(faq6.answer, contains('Your documents never leave your device'));
      expect(faq6.answer, contains('Google AdMob'));

      // Check onboarding updated wording
      expect(l10n.onboardingOfflineGuarantee, equals('Your files stay on your device'));

      // Check permissions updated reassurance wording
      expect(l10n.permissionReassuranceOfflineTitle, equals('Files are never uploaded'));
    });
  });
}
