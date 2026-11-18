import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/l10n_extension.dart';
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

  static List<FaqItem> questions(BuildContext context) => [
        FaqItem(
          question: context.l10n.faqQuestion1,
          answer: context.l10n.faqAnswer1,
        ),
        FaqItem(
          question: context.l10n.faqQuestion2,
          answer: context.l10n.faqAnswer2,
        ),
        FaqItem(
          question: context.l10n.faqQuestion3,
          answer: context.l10n.faqAnswer3,
        ),
        FaqItem(
          question: context.l10n.faqQuestion4,
          answer: context.l10n.faqAnswer4,
        ),
        FaqItem(
          question: context.l10n.faqQuestion5,
          answer: context.l10n.faqAnswer5,
        ),
        FaqItem(
          question: context.l10n.faqQuestion6,
          answer: context.l10n.faqAnswer6,
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
    final questions = FaqScreen.questions(context);
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
              padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 20, 8),
              child: Row(
                children: [
                  DocIconButton(
                    icon: AppIcons.back,
                    tooltip: context.l10n.actionBack,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      context.l10n.faqShortTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DocViewTypography.headlineLg.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
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
                        context.l10n.faqHeaderTopics(questions.length),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
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
                              Flexible(
                                child: Text(
                                  context.l10n.faqStillNeedHelp,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: DocViewTypography.labelLg.copyWith(
                                    color: tokens.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
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
