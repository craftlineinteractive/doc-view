import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../data/models/app_settings.dart';
import '../../shared/widgets/navigation/doc_app_bar.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/tiles/settings_row.dart';
import '../providers/providers.dart';

/// Sub-screen configuring scan frequency, media filters, and storage diagnostics
/// matching mockups 07_settings/02_settings_sub_screens.
class ScanSettingsScreen extends ConsumerWidget {
  const ScanSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final settings = ref.watch(settingsProvider);
    final scanState = ref.watch(scanStateProvider);
    final allFilesAccessAsync = ref.watch(allFilesAccessProvider);
    final permissionService = ref.watch(permissionServiceProvider);
    final isAndroid = Platform.isAndroid;
    final hasAllFilesAccess = allFilesAccessAsync.value ?? false;

    return DocScaffold(
      applyHeaderGradient: true,
      showDockedBanner: true,
      isAdLoaded: true,
      appBar: const DocSubAppBar(
        title: 'Scan settings',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Section 1: Scan Frequency
          const SettingsSectionHeader(title: 'Scan frequency'),
          Container(
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tokens.hairline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _FrequencyRadioTile(
                  key: const Key('radio_scan_on_open'),
                  title: 'Scan on app open',
                  subtitle:
                      'Automatically find new files when you open Doc View.',
                  isSelected: settings.autoScanMode == AutoScanMode.onOpen,
                  onTap: () {
                    ref
                        .read(settingsProvider.notifier)
                        .setAutoScanMode(AutoScanMode.onOpen);
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 52,
                  color: tokens.hairline,
                ),
                _FrequencyRadioTile(
                  key: const Key('radio_scan_manual_only'),
                  title: 'Manual only',
                  subtitle:
                      'Only scan when you pull to refresh or tap Rescan now.',
                  isSelected: settings.autoScanMode == AutoScanMode.manualOnly,
                  onTap: () {
                    ref
                        .read(settingsProvider.notifier)
                        .setAutoScanMode(AutoScanMode.manualOnly);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section 2: Document Filters
          const SettingsSectionHeader(title: 'Document filters'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tokens.hairline),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 18,
                            color: tokens.image.solid,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Include images',
                            style: DocViewTypography.titleMd.copyWith(
                              color: tokens.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Turn off to hide thousands of photos from your document list',
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Switch.adaptive(
                  key: const Key('switch_include_images'),
                  value: settings.includeImages,
                  activeTrackColor: tokens.primaryBlue,
                  activeThumbColor: Colors.white,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .setIncludeImages(value);

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Image list updated'),
                        action: SnackBarAction(
                          label: 'Rescan now',
                          onPressed: () {
                            ref.read(scanStateProvider.notifier).startScan();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section 3: Storage Diagnostics (Android only)
          if (isAndroid) ...[
            const SettingsSectionHeader(title: 'Storage diagnostics'),
            Container(
              key: const Key('card_storage_diagnostics'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: tokens.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: hasAllFilesAccess
                              ? tokens.blueTint
                              : tokens.ppt.tint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          hasAllFilesAccess
                              ? Icons.verified_user_outlined
                              : Icons.warning_amber_rounded,
                          size: 20,
                          color: hasAllFilesAccess
                              ? tokens.primaryBlue
                              : tokens.ppt.solid,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasAllFilesAccess
                                  ? 'All files access granted'
                                  : 'All files access needed',
                              style: DocViewTypography.titleMd.copyWith(
                                color: tokens.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasAllFilesAccess
                                  ? 'Doc View has permission to discover files in Downloads and SD cards.'
                                  : 'Permission is required to scan downloads and external storage folders.',
                              style: DocViewTypography.bodySm.copyWith(
                                color: tokens.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: tokens.hairline,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MANAGE_EXTERNAL_STORAGE',
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (hasAllFilesAccess)
                        OutlinedButton(
                          key: const Key('btn_open_storage_settings'),
                          onPressed: () => permissionService.openAppSettingsScreen(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: tokens.hairline),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                          child: Text(
                            'Open settings',
                            style: DocViewTypography.labelSm.copyWith(
                              color: tokens.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          key: const Key('btn_grant_storage_access'),
                          onPressed: () async {
                            final granted = await ref
                                .read(allFilesAccessProvider.notifier)
                                .requestAccess();
                            if (granted) {
                              await ref
                                  .read(scanStateProvider.notifier)
                                  .startScan();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tokens.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                          child: Text(
                            'Grant access',
                            style: DocViewTypography.labelSm.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 4: Outlined Rescan Button (Android only)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                key: const Key('btn_scan_settings_rescan'),
                onPressed: scanState.isScanning
                    ? null
                    : () async {
                        if (!hasAllFilesAccess) {
                          final granted = await ref
                              .read(allFilesAccessProvider.notifier)
                              .requestAccess();
                          if (!granted) return;
                        }
                        await ref.read(scanStateProvider.notifier).startScan();
                      },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: tokens.primaryBlue,
                    width: 2.0,
                  ),
                  backgroundColor: tokens.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: scanState.isScanning
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                tokens.primaryBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Scanning... ${scanState.filesFound} files found',
                            style: DocViewTypography.labelLg.copyWith(
                              color: tokens.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            AppIcons.refresh,
                            color: tokens.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rescan now',
                            style: DocViewTypography.labelLg.copyWith(
                              color: tokens.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FrequencyRadioTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _FrequencyRadioTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title, $subtitle',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? tokens.primaryBlue : tokens.textSecondary,
                    width: 2.0,
                  ),
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: tokens.primaryBlue,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DocViewTypography.titleMd.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

