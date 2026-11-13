import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/app_settings.dart';
import '../../shared/widgets/dialogs/doc_dialog.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/tiles/settings_row.dart';
import '../debug/component_gallery_screen.dart';
import '../providers/providers.dart';
import 'widgets/theme_selection_sheet.dart';

/// Main Settings tab matching mockups 07_settings/01_settings_tab.
/// Implements grouped settings cards, live theme sheet, scan configuration,
/// clear recent history dialog, legal links, and package version info.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = info;
        });
      }
    } catch (_) {
      // Fallback to static info if PackageInfo cannot be resolved
    }
  }

  Future<void> _handleImportFiles() async {
    try {
      final count = await ref.read(importServiceProvider).importFiles();
      ref.invalidate(categoryCountsProvider);
      ref.invalidate(filesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count files imported')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  Future<void> _confirmClearHistory(BuildContext context) async {
    final confirmed = await showDocConfirmDialog(
      context: context,
      title: 'Clear recent history?',
      body:
          'Files will be removed from Recent. Your files and bookmarks are not affected.',
      confirmLabel: 'Clear',
      cancelLabel: 'Cancel',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await ref.read(fileActionsControllerProvider).clearRecentHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recent history cleared'),
          ),
        );
      }
    }
  }

  Future<void> _sendFeedback(BuildContext context) async {
    if (AppConstants.supportEmail.isEmpty) return;
    final version = _packageInfo?.version ?? '1.0.0';
    final build = _packageInfo?.buildNumber ?? '1';
    final platform = Theme.of(context).platform.name;

    final uri = Uri(
      scheme: 'mailto',
      path: AppConstants.supportEmail,
      queryParameters: {
        'subject': 'Doc View Feedback ($version+$build)',
        'body':
            '\n\n---\nApp: Doc View $version (Build $build)\nPlatform: $platform\n',
      },
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email client')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching email: $e')),
        );
      }
    }
  }

  Future<void> _shareApp() async {
    if (AppConstants.storeShareUrl.isEmpty) return;
    try {
      await SharePlus.instance.share(
        ShareParams(
          text:
              'Check out Doc View - Fast, private, offline document reader: ${AppConstants.storeShareUrl}',
          subject: 'Doc View',
        ),
      );
    } catch (_) {}
  }

  Future<void> _rateApp() async {
    if (AppConstants.storeRateUrl.isEmpty) return;
    final uri = Uri.parse(AppConstants.storeRateUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _openPrivacyPolicy() async {
    if (AppConstants.privacyPolicyUrl.isEmpty) return;
    final uri = Uri.parse(AppConstants.privacyPolicyUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final settings = ref.watch(settingsProvider);
    final scanState = ref.watch(scanStateProvider);
    final lastScanTimeAsync = ref.watch(lastScanTimeProvider);
    final permissionService = ref.watch(permissionServiceProvider);
    final isAndroid = Platform.isAndroid;

    final appVersionStr = _packageInfo != null
        ? '${_packageInfo!.version} (${_packageInfo!.buildNumber})'
        : '1.0.0 (1)';

    final lastScanSubtitle = scanState.isScanning
        ? 'Scanning... ${scanState.filesFound} files found'
        : FormatUtils.formatLastScanTime(lastScanTimeAsync.value);

    // Filter dynamic Help rows based on constant presence
    final hasFeedback = AppConstants.supportEmail.isNotEmpty;
    final hasShare = AppConstants.storeShareUrl.isNotEmpty;
    final hasRate = AppConstants.storeRateUrl.isNotEmpty;
    final hasPrivacy = AppConstants.privacyPolicyUrl.isNotEmpty;

    return DocScaffold(
      applyHeaderGradient: true,
      showDockedBanner: true,
      isAdLoaded: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Pale-Blue Gradient App Bar Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: DocViewTypography.headlineLg.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: tokens.hairline,
            ),
            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // 1. TOP GROUP (File manager, Import files, Rescan now on Android)
                  SettingsGroupCard(
                    children: [
                      SettingsRow(
                        key: const Key('settings_file_manager'),
                        icon: Icons.folder_open_rounded,
                        title: 'File manager',
                        subtitle: 'Browse storage directories and folders',
                        onTap: () => context.push('/directories'),
                      ),
                      SettingsRow(
                        key: const Key('settings_import_files'),
                        icon: Icons.note_add_outlined,
                        title: 'Import files',
                        subtitle:
                            'Import documents into Doc View private storage',
                        onTap: _handleImportFiles,
                      ),
                      if (isAndroid)
                        SettingsRow(
                          key: const Key('settings_rescan_now'),
                          icon: AppIcons.refresh,
                          title: 'Rescan now',
                          subtitle: lastScanSubtitle,
                          trailing: scanState.isScanning
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tokens.blueTint,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Scanning...',
                                    style: DocViewTypography.captionXs.copyWith(
                                      color: tokens.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : null,
                          onTap: scanState.isScanning
                              ? null
                              : () async {
                                  final hasAccess = await permissionService
                                      .hasAllFilesAccess();
                                  if (!hasAccess) {
                                    final granted = await permissionService
                                        .requestAllFilesAccess();
                                    if (!granted) return;
                                  }
                                  await ref
                                      .read(scanStateProvider.notifier)
                                      .startScan();
                                },
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 2. SECTION: GENERAL
                  const SettingsSectionHeader(title: 'General'),
                  SettingsGroupCard(
                    children: [
                      SettingsRow(
                        key: const Key('settings_scan_settings'),
                        icon: Icons.filter_center_focus_rounded,
                        title: 'Scan settings',
                        subtitle: settings.autoScanMode == AutoScanMode.onOpen
                            ? 'Scan on open'
                            : 'Manual only',
                        onTap: () => context.push('/settings/scan-settings'),
                      ),
                      SettingsRow(
                        key: const Key('settings_app_theme'),
                        icon: Icons.wb_sunny_outlined,
                        title: 'App theme',
                        subtitle: _themeModeLabel(settings.themeMode),
                        onTap: () => ThemeSelectionSheet.show(context),
                      ),
                      SettingsRow(
                        key: const Key('settings_clear_history'),
                        icon: Icons.delete_outline_rounded,
                        title: 'Clear recent history',
                        subtitle: 'Clear opened document history',
                        onTap: () => _confirmClearHistory(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 3. SECTION: HELP
                  const SettingsSectionHeader(title: 'Help'),
                  SettingsGroupCard(
                    children: [
                      SettingsRow(
                        key: const Key('settings_faq'),
                        icon: Icons.help_outline_rounded,
                        title: 'FAQ',
                        subtitle: 'Frequently asked questions',
                        onTap: () => context.push('/faq'),
                      ),
                      if (hasFeedback)
                        SettingsRow(
                          key: const Key('settings_send_feedback'),
                          icon: Icons.chat_bubble_outline_rounded,
                          title: 'Send feedback',
                          subtitle: 'Report bugs or suggest features',
                          onTap: () => _sendFeedback(context),
                        ),
                      if (hasShare)
                        SettingsRow(
                          key: const Key('settings_share_app'),
                          icon: Icons.share_outlined,
                          title: 'Share app',
                          subtitle: 'Recommend Doc View to friends',
                          onTap: _shareApp,
                        ),
                      if (hasRate)
                        SettingsRow(
                          key: const Key('settings_rate_us'),
                          icon: Icons.star_outline_rounded,
                          title: 'Rate us',
                          subtitle: 'Leave a review on Google Play',
                          onTap: _rateApp,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 4. SECTION: ABOUT
                  const SettingsSectionHeader(title: 'About'),
                  SettingsGroupCard(
                    children: [
                      if (hasPrivacy)
                        SettingsRow(
                          key: const Key('settings_privacy_policy'),
                          icon: Icons.shield_outlined,
                          title: 'Privacy policy',
                          subtitle: 'Read our terms and privacy policy',
                          onTap: _openPrivacyPolicy,
                        ),
                      SettingsRow(
                        key: const Key('settings_licenses'),
                        icon: Icons.description_outlined,
                        title: 'Open-source licenses',
                        subtitle: 'Third-party software libraries',
                        onTap: () {
                          showLicensePage(
                            context: context,
                            applicationName: 'Doc View',
                            applicationVersion: appVersionStr,
                          );
                        },
                      ),
                      // Version Row: Tap does nothing; long press in kDebugMode opens Component Gallery
                      SettingsRow(
                        key: const Key('settings_version'),
                        icon: Icons.info_outline_rounded,
                        title: 'Version',
                        trailing: Text(
                          appVersionStr,
                          style: DocViewTypography.bodyMedium.copyWith(
                            color: tokens.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        onTap: () {}, // Tap does nothing per owner decision
                        onLongPress: kDebugMode
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const ComponentGalleryScreen(),
                                  ),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
