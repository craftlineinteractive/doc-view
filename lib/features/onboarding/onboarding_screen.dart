import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../../shared/widgets/tools/doc_tool_widgets.dart';
import '../providers/providers.dart';

/// 3-step onboarding flow presenting Doc View capabilities.
/// Persists completion in SharedPreferences so it only appears on first launch.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(settingsRepositoryProvider).setOnboardingCompleted(true);
    if (!mounted) return;
    context.go('/permissions');
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? DocViewColors.backgroundDark
          : DocViewColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation / Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage == 2)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        color: tokens.textPrimary,
                        tooltip: 'Back',
                        onPressed: _previousPage,
                      )
                    else
                      const SizedBox(width: 48),

                    if (_currentPage == 2)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: tokens.hairline),
                        ),
                        child: Text(
                          'Step 3 of 3',
                          style: DocViewTypography.labelXs.copyWith(
                            color: tokens.textSecondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      )
                    else
                      const Spacer(),

                    if (_currentPage < 2)
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: DocViewTypography.labelLg.copyWith(
                            color: tokens.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            // Page Content (PageView)
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _OnboardingPageOne(isDark: isDark, tokens: tokens),
                  _OnboardingPageTwo(isDark: isDark, tokens: tokens),
                  _OnboardingPageThree(isDark: isDark, tokens: tokens),
                ],
              ),
            ),

            // Bottom Navigation & Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicator Row
                  SizedBox(
                    height: 24,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_currentPage == 1)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: _previousPage,
                              icon: const Icon(Icons.chevron_left, size: 18),
                              label: const Text('Back'),
                              style: TextButton.styleFrom(
                                foregroundColor: tokens.textSecondary,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        Center(
                          child: OnboardingPageIndicator(
                            currentPage: _currentPage,
                            totalPages: 3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Primary CTA Button
                  DocPrimaryButton(
                    label: _currentPage == 2 ? 'Get started' : 'Next',
                    icon: _currentPage == 2
                        ? const Icon(Icons.arrow_forward)
                        : null,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PAGE 1: All your documents, one place
// ---------------------------------------------------------------------------
class _OnboardingPageOne extends StatelessWidget {
  final bool isDark;
  final DocViewTokens tokens;

  const _OnboardingPageOne({required this.isDark, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Illustration Area
          Expanded(
            child: Center(
              child: SizedBox(
                width: 320,
                height: 320,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Ambient decorative gradient blob
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            isDark
                                ? const Color(0x331E2A45)
                                : const Color(0x66E8F0FE),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Floating Document: Excel (Back-Left, -14deg)
                    Positioned(
                      left: 12,
                      top: 40,
                      child: Transform.rotate(
                        angle: -0.244,
                        child: _MiniDocCard(
                          isDark: isDark,
                          badgeText: 'X',
                          badgeColor: DocViewColors.excelSolid,
                          title: 'Q3_Audit.xlsx',
                          content: const _MiniSpreadsheet(),
                        ),
                      ),
                    ),

                    // Floating Document: PowerPoint (Back-Right, +15deg)
                    Positioned(
                      right: 12,
                      top: 36,
                      child: Transform.rotate(
                        angle: 0.261,
                        child: _MiniDocCard(
                          isDark: isDark,
                          badgeText: 'P',
                          badgeColor: DocViewColors.pptSolid,
                          title: 'Pitch_Deck.pptx',
                          content: const _MiniSlidePreview(),
                        ),
                      ),
                    ),

                    // Floating Document: Word (Mid-Left, -6deg)
                    Positioned(
                      left: 20,
                      bottom: 40,
                      child: Transform.rotate(
                        angle: -0.104,
                        child: _MiniDocCard(
                          isDark: isDark,
                          badgeText: 'W',
                          badgeColor: DocViewColors.wordSolid,
                          title: 'Contract.docx',
                          content: const _MiniWordLines(),
                        ),
                      ),
                    ),

                    // Hero Document: PDF (Center, -1deg)
                    Positioned(
                      top: 24,
                      child: Transform.rotate(
                        angle: -0.017,
                        child: Container(
                          width: 176,
                          height: 220,
                          decoration: BoxDecoration(
                            color: isDark ? tokens.surface : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? tokens.hairline
                                  : const Color(0xFFFDE8E8),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.35 : 0.08,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: DocViewColors.pdfSolid,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'PDF',
                                      style: TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Financial_Plan.pdf',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: tokens.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 90,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: DocViewColors.pdfSolid.withValues(
                                    alpha: 0.7,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: tokens.hairline,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 110,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: tokens.hairline,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Visual callout block
                              Container(
                                width: double.infinity,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? tokens.surfaceAlt
                                      : const Color(0xFFFDE8E8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: DocViewColors.pdfSolid
                                                  .withValues(alpha: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            width: 68,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: tokens.hairline,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.picture_as_pdf,
                                      size: 24,
                                      color: DocViewColors.pdfSolid,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: tokens.hairline,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  Text(
                                    'Page 1 of 12',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      color: tokens.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Central Foreground Anchor: Blue All Files Folder Badge
                    Positioned(
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF3B82F6),
                              DocViewColors.primaryBlue,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x661A66E8),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.folder,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'All Files',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '92',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Typography
          Text(
            'All your documents,\none place',
            textAlign: TextAlign.center,
            style: DocViewTypography.headlineLg.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Doc View automatically finds PDFs, Word, Excel, PowerPoint, text files and images on your phone and organizes them for you.',
            textAlign: TextAlign.center,
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PAGE 2: Read anything, beautifully
// ---------------------------------------------------------------------------
class _OnboardingPageTwo extends StatelessWidget {
  final bool isDark;
  final DocViewTokens tokens;

  const _OnboardingPageTwo({required this.isDark, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 300,
                height: 320,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient circular glow
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            isDark
                                ? const Color(0x334D8FF7)
                                : const Color(0x401A66E8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Reader Document Canvas Simulation
                    Container(
                      width: 220,
                      height: 260,
                      decoration: BoxDecoration(
                        color: isDark ? tokens.surface : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: tokens.hairline, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.4 : 0.08,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Reader Bar
                          Row(
                            children: [
                              const Icon(
                                Icons.format_size,
                                size: 16,
                                color: DocViewColors.interactiveBlue,
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.bookmark,
                                size: 16,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.search,
                                size: 16,
                                color: tokens.textSecondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Reader content lines
                          Container(
                            width: 140,
                            height: 10,
                            decoration: BoxDecoration(
                              color: tokens.textPrimary.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 6,
                            decoration: BoxDecoration(
                              color: tokens.hairline,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 170,
                            height: 6,
                            decoration: BoxDecoration(
                              color: tokens.hairline,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            height: 6,
                            decoration: BoxDecoration(
                              color: tokens.hairline,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Highlighted paragraph block
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: tokens.blueTint,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: tokens.primaryBlue.withValues(
                                      alpha: 0.6,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 100,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: tokens.primaryBlue.withValues(
                                      alpha: 0.6,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Floating Page Number Pill ("3 / 120")
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xE611141C),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 3,
                                    backgroundColor: DocViewColors.primaryBlue,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '3 / 120',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Reader Scrubber Bar
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? tokens.surfaceAlt : tokens.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '03',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: tokens.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: tokens.hairline,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: DocViewColors.primaryBlue,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 46,
                                        child: CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 3,
                                            backgroundColor:
                                                DocViewColors.primaryBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '120',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: tokens.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Typography
          Text(
            'Read anything,\nbeautifully',
            textAlign: TextAlign.center,
            style: DocViewTypography.headlineLg.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Open PDFs, Word, Excel and PowerPoint files with a fast, clean reader. Search, bookmark and pick up where you left off.',
            textAlign: TextAlign.center,
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PAGE 3: Powerful PDF tools, offline (EXACTLY 4 TOOLS)
// ---------------------------------------------------------------------------
class _OnboardingPageThree extends StatelessWidget {
  final bool isDark;
  final DocViewTokens tokens;

  const _OnboardingPageThree({required this.isDark, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 2x2 Grid of the EXACT 4 Tools
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.8,
                        children: [
                      _ToolMicroCard(
                        isDark: isDark,
                        tokens: tokens,
                        title: 'Image to PDF',
                        subtitle: 'Convert JPG & PNG',
                        icon: Icons.photo_library_outlined,
                      ),
                      _ToolMicroCard(
                        isDark: isDark,
                        tokens: tokens,
                        title: 'Scan to PDF',
                        subtitle: 'Camera edge detect',
                        icon: Icons.document_scanner_outlined,
                      ),
                      _ToolMicroCard(
                        isDark: isDark,
                        tokens: tokens,
                        title: 'Merge PDF',
                        subtitle: 'Combine into one',
                        icon: Icons.call_merge,
                      ),
                      _ToolMicroCard(
                        isDark: isDark,
                        tokens: tokens,
                        title: 'Split PDF',
                        subtitle: 'Extract any range',
                        icon: Icons.call_split,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Offline guarantee pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.blueTint,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: DocViewColors.interactiveBlue.withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user,
                          size: 16,
                          color: DocViewColors.interactiveBlue,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '100% Offline • Private & Secure',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: tokens.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

          // Typography
          Text(
            'Powerful PDF tools, offline',
            textAlign: TextAlign.center,
            style: DocViewTypography.headlineLg.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Turn photos into PDFs, scan documents, merge and split files. Everything stays on your device.',
            textAlign: TextAlign.center,
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HELPER MICRO-COMPONENTS
// ---------------------------------------------------------------------------

class _ToolMicroCard extends StatelessWidget {
  final bool isDark;
  final DocViewTokens tokens;
  final String title;
  final String subtitle;
  final IconData icon;

  const _ToolMicroCard({
    required this.isDark,
    required this.tokens,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              Icon(
                icon,
                size: 18,
                color: DocViewColors.interactiveBlue,
              ),
            ],
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: tokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniDocCard extends StatelessWidget {
  final bool isDark;
  final String badgeText;
  final Color badgeColor;
  final String title;
  final Widget content;

  const _MiniDocCard({
    required this.isDark,
    required this.badgeText,
    required this.badgeColor,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 170,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232838) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3042) : const Color(0xFFE6E9F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF11141C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _MiniSpreadsheet extends StatelessWidget {
  const _MiniSpreadsheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int r = 0; r < 4; r++) ...[
          if (r > 0) const SizedBox(height: 4),
          Row(
            children: [
              for (int c = 0; c < 3; c++) ...[
                if (c > 0) const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: r == 0
                          ? DocViewColors.excelSolid.withValues(alpha: 0.15)
                          : const Color(0xFFE6E9F0).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _MiniSlidePreview extends StatelessWidget {
  const _MiniSlidePreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EB),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: DocViewColors.pptSolid,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(width: 8, height: 16, color: DocViewColors.pptSolid.withValues(alpha: 0.4)),
              const SizedBox(width: 4),
              Container(width: 8, height: 26, color: DocViewColors.pptSolid.withValues(alpha: 0.7)),
              const SizedBox(width: 4),
              Container(width: 8, height: 20, color: DocViewColors.pptSolid.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Container(width: 8, height: 32, color: DocViewColors.pptSolid),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniWordLines extends StatelessWidget {
  const _MiniWordLines();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 6,
          decoration: BoxDecoration(
            color: DocViewColors.wordSolid.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 6),
        for (int i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(height: 5),
          Container(
            width: i == 3 ? 60 : double.infinity,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E9F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ],
    );
  }
}
