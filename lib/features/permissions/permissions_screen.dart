import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../providers/providers.dart';

/// Platform-specific permissions explainer and transparent pre-consent flow.
/// Frame A: Android All Files Access (MANAGE_EXTERNAL_STORAGE).
/// Frame B: iOS Document Import & Files app guide.
/// Frame C: Free with ads / Privacy explainer before entering main app shell.
class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  // If true, showing Frame C (Free with ads).
  // If false, showing Frame A (Android) or Frame B (iOS).
  bool _showingFrameC = false;

  void _proceedToFrameC() {
    setState(() => _showingFrameC = true);
  }

  void _enterMainApp() {
    context.go('/home');
  }

  Future<void> _handleAndroidGrantAccess() async {
    final granted =
        await ref.read(allFilesAccessProvider.notifier).requestAccess();
    if (granted) {
      await ref.read(scanStateProvider.notifier).startScan();
    }
    if (mounted) {
      _proceedToFrameC();
    }
  }

  Future<void> _handleIOSImportFiles() async {
    try {
      await ref.read(importServiceProvider).importFiles();
      ref.invalidate(categoryCountsProvider);
      ref.invalidate(filesProvider);
    } catch (_) {
      // User cancelled picker
    }
    if (mounted) {
      _proceedToFrameC();
    }
  }

  Future<void> _openPrivacyPolicy() async {
    if (AppConstants.privacyPolicyUrl.isNotEmpty) {
      final uri = Uri.parse(AppConstants.privacyPolicyUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isIOS = Platform.isIOS;

    return Scaffold(
      backgroundColor: isDark
          ? DocViewColors.backgroundDark
          : DocViewColors.backgroundLight,
      body: SafeArea(
        child: _showingFrameC
            ? _FrameCView(
                isDark: isDark,
                tokens: tokens,
                onContinue: _enterMainApp,
                onPrivacyPolicy: _openPrivacyPolicy,
              )
            : (isIOS
                ? _FrameBView(
                    isDark: isDark,
                    tokens: tokens,
                    onImportFiles: _handleIOSImportFiles,
                    onSkip: _proceedToFrameC,
                  )
                : _FrameAView(
                    isDark: isDark,
                    tokens: tokens,
                    onGrantAccess: _handleAndroidGrantAccess,
                    onSkip: _proceedToFrameC,
                  )),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FRAME A: Android "All files access" (MANAGE_EXTERNAL_STORAGE)
// ---------------------------------------------------------------------------
class _FrameAView extends StatelessWidget {
  final bool isDark;
  final DocViewTokens tokens;
  final VoidCallback onGrantAccess;
  final VoidCallback onSkip;

  const _FrameAView({
    required this.isDark,
    required this.tokens,
    required this.onGrantAccess,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Top Tag Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: tokens.blueTint,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 16,
                  color: DocViewColors.interactiveBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Device Storage Access',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: tokens.primaryBlue,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Illustration: Storage Flow into Doc View Catalog
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: tokens.hairline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Left: Device Storage Phone Mockup
                Container(
                  width: 90,
                  height: 120,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? tokens.surfaceAlt : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: tokens.hairline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 24,
                          height: 3,
                          decoration: BoxDecoration(
                            color: tokens.hairline,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _miniDocRow(DocViewColors.pdfSolid, 'P', tokens),
                      const SizedBox(height: 6),
                      _miniDocRow(DocViewColors.wordSolid, 'W', tokens),
                      const SizedBox(height: 6),
                      _miniDocRow(DocViewColors.excelSolid, 'X', tokens),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.folder,
                            size: 12,
                            color: DocViewColors.interactiveBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Storage',
                            style: TextStyle(
                              fontSize: 8,
                              color: tokens.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Flowing arrow & 'Automatic' badge
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: DocViewColors.interactiveBlue,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.blueTint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Automatic',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: tokens.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),

                // Right: Doc View Structured Catalog
                Container(
                  width: 104,
                  height: 120,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? tokens.surfaceAlt : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: DocViewColors.interactiveBlue,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: DocViewColors.interactiveBlue.withValues(
                          alpha: 0.15,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Doc View',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: tokens.textPrimary,
                            ),
                          ),
                          const CircleAvatar(
                            radius: 3,
                            backgroundColor: Color(0xFF1FA971),
                          ),
                        ],
                      ),
                      const Divider(height: 8),
                      _miniCatalogItem('PDF', DocViewColors.pdfSolid, '2 MB', tokens),
                      const SizedBox(height: 4),
                      _miniCatalogItem('DOC', DocViewColors.wordSolid, '84 KB', tokens),
                      const SizedBox(height: 4),
                      _miniCatalogItem('XLS', DocViewColors.excelSolid, '1.4 MB', tokens),
                      const Spacer(),
                      Center(
                        child: Text(
                          'Indexed Offline',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: tokens.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Headline & Body
          Text(
            'Let Doc View find your documents',
            textAlign: TextAlign.center,
            style: DocViewTypography.headlineLg.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To list PDFs, Word, Excel and other files saved by any app, Android needs your permission to access all files. Your files never leave your phone.',
            textAlign: TextAlign.center,
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // 3 Reassurance Rows
          _reassuranceRow(
            tokens: tokens,
            icon: Icons.wifi_off_outlined,
            iconColor: tokens.primaryBlue,
            title: 'Works offline',
            subtitle: 'No internet connection required. Operates 100% locally.',
          ),
          const SizedBox(height: 10),
          _reassuranceRow(
            tokens: tokens,
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF1FA971),
            title: 'No uploads',
            subtitle: 'Zero cloud servers. Your files stay strictly in phone memory.',
          ),
          const SizedBox(height: 10),
          _reassuranceRow(
            tokens: tokens,
            icon: Icons.settings_outlined,
            iconColor: tokens.primaryBlue,
            title: 'You can change this any time',
            subtitle: 'Easily toggle in your Android System App Settings.',
          ),

          const SizedBox(height: 28),

          // Action Buttons
          DocPrimaryButton(
            label: 'Grant access',
            icon: const Icon(Icons.arrow_forward),
            onPressed: onGrantAccess,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onSkip,
            child: Text(
              'Import files instead',
              style: DocViewTypography.labelLg.copyWith(
                color: tokens.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _miniDocRow(Color color, String letter, DocViewTokens tokens) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: tokens.hairline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _miniCatalogItem(
    String label,
    Color color,
    String size,
    DocViewTokens tokens,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 6,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Container(
                  width: 16,
                  height: 4,
                  decoration: BoxDecoration(
                    color: tokens.hairline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 2),
        Text(
          size,
          style: TextStyle(
            fontSize: 7,
            color: tokens.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// FRAME B: iOS Storage Guide (Document Import & Sandbox)
// ---------------------------------------------------------------------------
class _FrameBView extends StatelessWidget {
  final bool isDark;
  final DocViewTokens tokens;
  final VoidCallback onImportFiles;
  final VoidCallback onSkip;

  const _FrameBView({
    required this.isDark,
    required this.tokens,
    required this.onImportFiles,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Top Tag Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tokens.hairline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.apple,
                  size: 16,
                  color: DocViewColors.interactiveBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  'iOS Storage Guide',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Hero Tile: Apple Files & Sandbox Graphic
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: tokens.hairline),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2F7BEA), DocViewColors.primaryBlue],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.folder,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'On My iPhone',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Doc View Folder',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: tokens.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Headline & Body
          Text(
            'Bring your documents to Doc View',
            textAlign: TextAlign.center,
            style: DocViewTypography.headlineLg.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Due to Apple's privacy architecture, iOS doesn't allow any app to scan your entire phone automatically. Choose how you'd like to read your files:",
            textAlign: TextAlign.center,
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // Option Card 1: Import Files (Primary)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: DocViewColors.interactiveBlue,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DocViewColors.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Import files',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: tokens.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: DocViewColors.primaryBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'FASTEST',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pick documents directly from your iCloud Drive, Downloads, or any folder in seconds.',
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: DocViewColors.primaryBlue,
                  size: 20,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Option Card 2: Doc View folder in Files app
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tokens.hairline),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? tokens.surfaceAlt : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tokens.hairline),
                  ),
                  child: const Icon(
                    Icons.folder_open,
                    color: DocViewColors.interactiveBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Open Doc View folder in Files app',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Save or AirDrop documents directly into the "Doc View" folder in the iOS Files app for instant sync.',
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          DocPrimaryButton(
            label: 'Import files',
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: onImportFiles,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onSkip,
            child: Text(
              'Continue to app',
              style: DocViewTypography.labelLg.copyWith(
                color: tokens.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FRAME C: "Free with ads" / Transparency & Consent Explainer
// ---------------------------------------------------------------------------
class _FrameCView extends StatelessWidget {
  final bool isDark;
  final DocViewTokens tokens;
  final VoidCallback onContinue;
  final VoidCallback onPrivacyPolicy;

  const _FrameCView({
    required this.isDark,
    required this.tokens,
    required this.onContinue,
    required this.onPrivacyPolicy,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Top Tag Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: tokens.blueTint,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: DocViewColors.interactiveBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Transparency & Consent',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: tokens.primaryBlue,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Hero Shield Illustration
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: tokens.hairline),
            ),
            child: Center(
              child: SizedBox(
                width: 140,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isDark ? tokens.surfaceAlt : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.3 : 0.08,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              DocViewColors.primaryBlue,
                              DocViewColors.interactiveBlue,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.verified_user,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),

                    // Badge: 100% Free App
                    Positioned(
                      top: -6,
                      right: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? tokens.surfaceAlt : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: tokens.hairline),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: Color(0xFF1FA971),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '100% Free App',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Badge: Minimal Ads
                    Positioned(
                      bottom: -6,
                      left: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? tokens.surfaceAlt : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: tokens.hairline),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: tokens.blueTint,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                'AD',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: tokens.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Minimal Ads',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
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

          const SizedBox(height: 20),

          // Headline & Body
          Text(
            'Free with ads',
            textAlign: TextAlign.center,
            style: DocViewTypography.headlineLg.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Doc View is free thanks to ads. We'll ask for your choice about personalised ads next.",
            textAlign: TextAlign.center,
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // 3 Info Rows
          _reassuranceRow(
            tokens: tokens,
            icon: Icons.visibility_outlined,
            iconColor: tokens.primaryBlue,
            title: 'What ads you may see',
            subtitle:
                'Small banner ads and non-intrusive sponsor cards. No popups or video interruptions while reading.',
          ),
          const SizedBox(height: 10),
          _reassuranceRow(
            tokens: tokens,
            icon: Icons.lock_outline,
            iconColor: const Color(0xFF1FA971),
            title: 'Documents stay completely private',
            subtitle:
                'Ad partners never have access to your document names, text contents, or file locations.',
          ),
          const SizedBox(height: 10),
          _reassuranceRow(
            tokens: tokens,
            icon: Icons.tune,
            iconColor: tokens.primaryBlue,
            title: 'You can change your choice in Settings',
            subtitle:
                'Update personalized ad consent or privacy preferences anytime in Doc View Settings.',
          ),

          const SizedBox(height: 28),

          DocPrimaryButton(
            label: 'Continue',
            icon: const Icon(Icons.arrow_forward),
            onPressed: onContinue,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onPrivacyPolicy,
            child: Text(
              'Privacy policy',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: tokens.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _reassuranceRow({
  required DocViewTokens tokens,
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: tokens.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: tokens.hairline),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: tokens.surfaceAlt,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: tokens.hairline),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: tokens.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
