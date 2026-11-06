import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/app_settings.dart';
import '../providers/providers.dart';

/// Screen managing application preferences, file management tools, offline FAQs, and legal info.
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

  Future<void> _showDocumentEngineLicense(BuildContext context) async {
    String licenseText = '';
    try {
      licenseText = await rootBundle.loadString(
        'packages/offline_document_viewer/assets/licenses/LICENSE-liberation',
      );
    } catch (_) {
      return;
    }

    if (!context.mounted || licenseText.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Liberation Font License'),
            ),
            body: SelectionArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  licenseText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.4,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final liveTheme = ref.watch(settingsProvider).themeMode;
            final theme = Theme.of(context);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Text(
                        'Choose App Theme',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    RadioGroup<ThemeMode>(
                      groupValue: liveTheme,
                      onChanged: (mode) {
                        if (mode != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .setThemeMode(mode);
                          Navigator.of(sheetContext).pop();
                        }
                      },
                      child: const Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.system,
                            title: Text('System default'),
                            subtitle: Text('Follows device system appearance'),
                          ),
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.light,
                            title: Text('Light'),
                            subtitle: Text('Clean, bright appearance'),
                          ),
                          RadioListTile<ThemeMode>(
                            value: ThemeMode.dark,
                            title: Text('Dark'),
                            subtitle: Text('Easier on the eyes in low light'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showScanSettingsSheet(BuildContext context, AppSettings settings) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final liveSettings = ref.watch(settingsProvider);
            final theme = Theme.of(context);

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Text(
                        'Scan Settings',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Configure how Doc View scans storage and indexes your documents.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Auto-Scan Mode',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    RadioGroup<AutoScanMode>(
                      groupValue: liveSettings.autoScanMode,
                      onChanged: (mode) {
                        if (mode != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .setAutoScanMode(mode);
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<AutoScanMode>(
                            value: AutoScanMode.onOpen,
                            title: Text(AutoScanMode.onOpen.label),
                            subtitle: Text(AutoScanMode.onOpen.description),
                          ),
                          RadioListTile<AutoScanMode>(
                            value: AutoScanMode.manualOnly,
                            title: Text(AutoScanMode.manualOnly.label),
                            subtitle: Text(AutoScanMode.manualOnly.description),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 24),
                    SwitchListTile(
                      value: liveSettings.includeImages,
                      title: const Text('Include images'),
                      subtitle: const Text(
                        'Scan and index image files (JPG, PNG, WEBP). When turned off, non-imported images are removed on next scan.',
                      ),
                      onChanged: (value) {
                        ref
                            .read(settingsProvider.notifier)
                            .setIncludeImages(value);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value
                                    ? 'Images will be included in storage scans.'
                                    : 'Images will be excluded from scans.',
                              ),
                              action: SnackBarAction(
                                label: 'Rescan now',
                                onPressed: () {
                                  ref
                                      .read(scanStateProvider.notifier)
                                      .startScan();
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmClearHistory(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.history_toggle_off_rounded,
            size: 36,
            color: Colors.amber,
          ),
          title: const Text('Clear Recent History?'),
          content: const Text(
            'This will clear all entries from your Recently Opened list.\n\n'
            'Your actual documents on storage will not be affected or deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
                foregroundColor: Theme.of(dialogContext).colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      final count = await ref
          .read(fileActionsControllerProvider)
          .clearRecentHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              count > 0
                  ? 'Cleared $count recent history entries.'
                  : 'Recent history is already empty.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _sendFeedback(BuildContext context) async {
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

  Future<void> _shareApp(BuildContext context) async {
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

  Future<void> _rateApp(BuildContext context) async {
    final uri = Uri.parse(AppConstants.storeRateUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
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
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final scanState = ref.watch(scanStateProvider);
    final permissionService = ref.watch(permissionServiceProvider);
    final isAndroid = permissionService.isAndroid;

    final appVersionStr = _packageInfo != null
        ? 'Version ${_packageInfo!.version} (Build ${_packageInfo!.buildNumber})'
        : 'Version 1.0.0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section: File Management
          _SectionHeader(title: 'File Management'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _SettingsTile(
                  key: const Key('settings_file_manager'),
                  icon: Icons.folder_open_rounded,
                  iconColor: theme.colorScheme.primary,
                  title: 'File manager',
                  subtitle: 'Browse storage directories and folders',
                  onTap: () => context.push('/directories'),
                ),
                if (isAndroid) ...[
                  const _TileDivider(),
                  _SettingsTile(
                    key: const Key('settings_rescan_now'),
                    icon: Icons.sync_rounded,
                    iconColor: theme.colorScheme.primary,
                    title: 'Rescan now',
                    subtitle: scanState.isScanning
                        ? 'Scanning storage... ${scanState.filesFound} files found'
                        : 'Scan device storage to refresh the document catalog',
                    trailing: scanState.isScanning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right_rounded),
                    onTap: scanState.isScanning
                        ? null
                        : () async {
                            final hasAccess =
                                await permissionService.hasAllFilesAccess();
                            if (!hasAccess) {
                              final granted = await permissionService
                                  .requestAllFilesAccess();
                              if (!granted) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'All files access is required to scan storage',
                                      ),
                                    ),
                                  );
                                }
                                return;
                              }
                            }
                            await ref
                                .read(scanStateProvider.notifier)
                                .startScan();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Scanning started...'),
                                ),
                              );
                            }
                          },
                  ),
                ],
                const _TileDivider(),
                _SettingsTile(
                  key: const Key('settings_import_files'),
                  icon: Icons.file_upload_outlined,
                  iconColor: Colors.green,
                  title: 'Import files',
                  subtitle: 'Import documents into Doc View private storage',
                  onTap: () async {
                    try {
                      final count =
                          await ref.read(importServiceProvider).importFiles();
                      ref.invalidate(categoryCountsProvider);
                      ref.invalidate(filesProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$count files imported')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Import error: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: General
          _SectionHeader(title: 'General'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _SettingsTile(
                  key: const Key('settings_app_theme'),
                  icon: Icons.palette_outlined,
                  iconColor: Colors.purple,
                  title: 'App theme',
                  subtitle: _themeModeLabel(settings.themeMode),
                  onTap: () => _showThemeDialog(context),
                ),
                const _TileDivider(),
                _SettingsTile(
                  key: const Key('settings_scan_settings'),
                  icon: Icons.manage_search_rounded,
                  iconColor: Colors.teal,
                  title: 'Scan settings',
                  subtitle:
                      '${settings.autoScanMode.label} • Images ${settings.includeImages ? "on" : "off"}',
                  onTap: () => _showScanSettingsSheet(context, settings),
                ),
                const _TileDivider(),
                _SettingsTile(
                  key: const Key('settings_clear_history'),
                  icon: Icons.history_toggle_off_rounded,
                  iconColor: Colors.orange,
                  title: 'Clear recent history',
                  subtitle: 'Reset recently opened documents list',
                  onTap: () => _confirmClearHistory(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: Help
          _SectionHeader(title: 'Help'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _SettingsTile(
                  key: const Key('settings_faq'),
                  icon: Icons.help_outline_rounded,
                  iconColor: Colors.blue,
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions & privacy details',
                  onTap: () => context.push('/faq'),
                ),
                if (AppConstants.supportEmail.isNotEmpty) ...[
                  const _TileDivider(),
                  _SettingsTile(
                    key: const Key('settings_feedback'),
                    icon: Icons.mail_outline_rounded,
                    iconColor: Colors.indigo,
                    title: 'Send feedback',
                    subtitle: 'Report an issue or suggest an improvement',
                    onTap: () => _sendFeedback(context),
                  ),
                ],
                if (AppConstants.storeShareUrl.isNotEmpty) ...[
                  const _TileDivider(),
                  _SettingsTile(
                    key: const Key('settings_share_app'),
                    icon: Icons.share_outlined,
                    iconColor: Colors.green,
                    title: 'Share app',
                    subtitle: 'Share Doc View with colleagues or friends',
                    onTap: () => _shareApp(context),
                  ),
                ],
                if (AppConstants.storeRateUrl.isNotEmpty) ...[
                  const _TileDivider(),
                  _SettingsTile(
                    key: const Key('settings_rate_us'),
                    icon: Icons.star_outline_rounded,
                    iconColor: Colors.amber,
                    title: 'Rate us',
                    subtitle: 'Rate Doc View on the app store',
                    onTap: () => _rateApp(context),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: About
          _SectionHeader(title: 'About'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _SettingsTile(
                  key: const Key('settings_app_info'),
                  icon: Icons.info_outline_rounded,
                  iconColor: theme.colorScheme.primary,
                  title: AppConstants.appName,
                  subtitle: appVersionStr,
                ),
                if (AppConstants.privacyPolicyUrl.isNotEmpty) ...[
                  const _TileDivider(),
                  _SettingsTile(
                    key: const Key('settings_privacy_policy'),
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Colors.teal,
                    title: 'Privacy policy',
                    subtitle: 'Read our privacy commitments',
                    onTap: () => _openPrivacyPolicy(context),
                  ),
                ],
                const _TileDivider(),
                _SettingsTile(
                  key: const Key('settings_licenses'),
                  icon: Icons.description_outlined,
                  iconColor: theme.colorScheme.secondary,
                  title: 'Open-source licenses',
                  subtitle: 'Third-party libraries used in Doc View',
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: AppConstants.appName,
                      applicationVersion: appVersionStr,
                    );
                  },
                ),
                const _TileDivider(),
                _SettingsTile(
                  key: const Key('settings_fonts_license'),
                  icon: Icons.font_download_outlined,
                  iconColor: theme.colorScheme.secondary,
                  title: 'Document engine fonts license',
                  subtitle: 'Liberation Fonts and third-party notices',
                  onTap: () => _showDocumentEngineLicense(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: onTap != null,
      label: subtitle != null ? '$title, $subtitle' : title,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing!
                else if (onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      color: theme.dividerColor.withValues(alpha: 0.08),
    );
  }
}
