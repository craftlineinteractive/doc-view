import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';

/// Single FAQ question and answer pair.
class FaqItem {
  final String question;
  final String answer;

  const FaqItem({
    required this.question,
    required this.answer,
  });
}

/// Frequently Asked Questions screen matching mockups 07_settings/03_faq.
/// Features a "6 Topics" header chip, 16pt radius accordion cards with single-expand
/// behavior (second question expanded by default), and a tonal "Send feedback" button.
class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  static const List<FaqItem> defaultQuestions = [
    FaqItem(
      question: 'Why does Doc View need All files access on Android?',
      answer:
          'Doc View requires All files access (MANAGE_EXTERNAL_STORAGE) on Android 11+ to discover and index supported documents (PDF, Word, Excel, PowerPoint, Text, and Images) stored in shared folders such as Downloads and Documents.\n\nWithout this permission, Android restricts file access to the app\'s private internal folder, preventing Doc View from browsing or opening files located across your device.',
    ),
    FaqItem(
      question: 'Is my data uploaded anywhere?',
      answer:
          'Your documents never leave your device. Doc View opens, converts and stores files locally. The app shows ads served by Google AdMob, which can use limited device data as described in our Privacy Policy.',
    ),
    FaqItem(
      question: 'Where are the PDFs I create saved?',
      answer:
          'Files you import or generate (such as converted PDFs, merged documents, or split pages) are saved securely in your device storage under DocView/Created or private app storage. You can view them anytime in the Created by you section on the Tools tab.',
    ),
    FaqItem(
      question: 'Why does my Word file look different?',
      answer:
          'Doc View uses a high-speed offline document engine to render files directly on your device without sending private data to cloud converters. Complex formatting or custom shapes render with native offline approximations.',
    ),
    FaqItem(
      question: 'Can I open password-protected files?',
      answer:
          'Yes, Doc View supports opening password-protected PDF documents. When opening an encrypted PDF, enter the password in the dialog to decrypt and view the document on your device.',
    ),
    FaqItem(
      question: 'Why doesn\'t it scan my whole iPhone?',
      answer:
          'iOS uses strict app sandboxing to safeguard device privacy. Apps can only access documents explicitly saved inside the Files app or shared via the system Share Sheet.\n\nTo view files on iOS, import them into the Doc View folder in the native Files app or use the Import files option in Settings.',
    ),
  ];

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  // Second question (index 1: "Is my data uploaded anywhere?") expanded by default as in the mockup
  int? _expandedIndex = 1;

  Future<void> _handleFeedback() async {
    if (AppConstants.supportEmail.isEmpty) return;
    final uri = Uri(
      scheme: 'mailto',
      path: AppConstants.supportEmail,
      queryParameters: {
        'subject': 'Doc View FAQ Feedback',
      },
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final questions = FaqScreen.defaultQuestions;
    final hasSupportEmail = AppConstants.supportEmail.isNotEmpty;

    return DocScaffold(
      applyHeaderGradient: true,
      showDockedBanner: true,
      isAdLoaded: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
              child: Row(
                children: [
                  DocIconButton(
                    icon: AppIcons.back,
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'FAQ',
                    style: DocViewTypography.headlineLg.copyWith(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: tokens.hairline),
                    ),
                    child: Text(
                      '${questions.length} Topics',
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: tokens.hairline,
            ),
            // Accordion List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                itemCount: questions.length + (hasSupportEmail ? 1 : 0),
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  // Bottom Tonal CTA button: "Still need help? Send feedback"
                  if (index == questions.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          key: const Key('btn_faq_feedback'),
                          onPressed: _handleFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tokens.blueTint,
                            foregroundColor: tokens.primaryBlue,
                            elevation: 0,
                            side: BorderSide(
                              color: tokens.primaryBlue.withValues(alpha: 0.2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 20,
                                color: tokens.primaryBlue,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Still need help? Send feedback',
                                style: DocViewTypography.labelLg.copyWith(
                                  color: tokens.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final item = questions[index];
                  final isExpanded = _expandedIndex == index;

                  return _FaqAccordionCard(
                    key: Key('faq_card_$index'),
                    item: item,
                    isExpanded: isExpanded,
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? null : index;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqAccordionCard extends StatelessWidget {
  final FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqAccordionCard({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? tokens.primaryBlue : tokens.hairline,
          width: isExpanded ? 2.0 : 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.question,
                        style: DocViewTypography.titleMd.copyWith(
                          color: isExpanded
                              ? tokens.primaryBlue
                              : tokens.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isExpanded ? tokens.primaryBlue : tokens.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isExpanded ? tokens.primaryBlue : tokens.hairline,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: isExpanded ? Colors.white : tokens.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: tokens.hairline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.answer,
                    style: DocViewTypography.bodyMedium.copyWith(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
