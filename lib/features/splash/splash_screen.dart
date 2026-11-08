import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../providers/providers.dart';

/// Splash screen displaying brand mark with floating document sheets,
/// a 120pt shimmer progress line, and app version.
/// Displays for a minimum of 1 second while awaiting DB, settings, and onboarding state.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  String _versionText = 'Version 1.0.0';

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    final disableAnimations = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    if (!disableAnimations) {
      _shimmerController.repeat();
    }

    _loadVersion();
    _startInitSequence();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted && info.version.isNotEmpty) {
        setState(() {
          _versionText = 'Version ${info.version}';
        });
      }
    } catch (_) {
      // Retain fallback constant on failure/testing
    }
  }

  Future<void> _startInitSequence() async {
    final minDisplayFuture = Future.delayed(const Duration(milliseconds: 1000));

    // Ensure database and settings are initialized
    final dbFuture = ref.read(appDatabaseProvider).database;
    final settingsFuture = ref.read(settingsRepositoryProvider).loadSettings();
    final onboardingFuture =
        ref.read(settingsRepositoryProvider).isOnboardingCompleted();

    final results = await Future.wait([
      minDisplayFuture,
      dbFuture,
      settingsFuture,
      onboardingFuture,
    ]);

    if (!mounted) return;

    final isOnboardingDone = results[3] as bool? ?? false;
    if (isOnboardingDone) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: isDark
          ? DocViewColors.backgroundDark
          : DocViewColors.backgroundLight,
      body: Stack(
        children: [
          // Ambient radial center glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    isDark
                        ? const Color(0xFF1E2A45).withValues(alpha: 0.6)
                        : const Color(0xFFE9F2FF).withValues(alpha: 0.9),
                    isDark
                        ? DocViewColors.backgroundDark
                        : DocViewColors.backgroundLight,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Center Brand Composition
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Floating sheets & Brand Mark
                      SizedBox(
                        width: 208,
                        height: 208,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // Drifting Floating Sheet 1 (Top-Left, angled -6deg)
                            Positioned(
                              top: 4,
                              left: 6,
                              child: Transform.rotate(
                                angle: -0.1047, // -6 degrees
                                child: _FloatingSheet(
                                  width: 112,
                                  height: 144,
                                  isDark: isDark,
                                  tokens: tokens,
                                  lineWidths: const [48, 64, 40],
                                ),
                              ),
                            ),

                            // Drifting Floating Sheet 2 (Bottom-Right, angled +8deg)
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: Transform.rotate(
                                angle: 0.1396, // +8 degrees
                                child: _FloatingSheet(
                                  width: 128,
                                  height: 156,
                                  isDark: isDark,
                                  tokens: tokens,
                                  lineWidths: const [56, 80, 48],
                                ),
                              ),
                            ),

                            // Primary Center Brand Icon (112x112, 28pt radius)
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                color: DocViewColors.primaryBlue,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? const Color(0x8C1A66E8)
                                        : const Color(0x5C1A66E8),
                                    blurRadius: isDark ? 40 : 36,
                                    offset: const Offset(0, 16),
                                  ),
                                  if (isDark)
                                    const BoxShadow(
                                      color: Color(0x594D8FF7),
                                      blurRadius: 24,
                                      offset: Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(27),
                                child: Image.asset(
                                  'assets/docview_icon.png',
                                  width: 112,
                                  height: 112,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Wordmark: Strictly on ONE line as specified
                      Text(
                        'Doc View',
                        maxLines: 1,
                        softWrap: false,
                        style: DocViewTypography.headlineXl.copyWith(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: tokens.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tagline
                      Text(
                        'All your documents, one place.',
                        style: DocViewTypography.bodyLg.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom 120pt Shimmer Progress Bar & Version Label
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 120pt Shimmer Line
                      SizedBox(
                        width: 120,
                        height: 3.5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: tokens.shimmerBase,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: disableAnimations
                                ? const SizedBox.shrink()
                                : AnimatedBuilder(
                                    animation: _shimmerController,
                                    builder: (context, child) {
                                      return LayoutBuilder(
                                        builder: (context, constraints) {
                                          final totalWidth =
                                              constraints.maxWidth;
                                          final dx =
                                              (-totalWidth) +
                                              (_shimmerController.value *
                                                  totalWidth *
                                                  2.0);
                                          return Transform.translate(
                                            offset: Offset(dx, 0),
                                            child: Container(
                                              width: totalWidth * 0.7,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.transparent,
                                                    isDark
                                                        ? tokens.interactiveBlue
                                                        : tokens.primaryBlue,
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Version string
                      Text(
                        _versionText,
                        style: DocViewTypography.labelXs.copyWith(
                          color: tokens.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
    );
  }
}

/// Floating translucent document sheet in the background behind the brand icon.
class _FloatingSheet extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;
  final DocViewTokens tokens;
  final List<double> lineWidths;

  const _FloatingSheet({
    required this.width,
    required this.height,
    required this.isDark,
    required this.tokens,
    required this.lineWidths,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? const Color(0xFF232838).withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.70);
    final borderColor = isDark
        ? const Color(0xFF2A3042)
        : const Color(0x331A66E8);
    final lineColor = isDark
        ? const Color(0x334D8FF7)
        : const Color(0x261A66E8);
    final flapBg = isDark
        ? const Color(0xFF1E2A45)
        : const Color(0xFFE8F0FE);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Folded corner flap hint in top-right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: flapBg,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(15),
                ),
                border: Border(
                  left: BorderSide(color: borderColor, width: 1),
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
            ),
          ),

          // Skeleton document lines
          Positioned(
            top: 36,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < lineWidths.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  Container(
                    width: lineWidths[i],
                    height: 5,
                    decoration: BoxDecoration(
                      color: lineColor,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
