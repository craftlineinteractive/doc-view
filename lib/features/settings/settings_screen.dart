import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

/// Screen managing application settings, manual scans, manual file imports, and open-source licenses.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showDocumentEngineLicense(BuildContext context) async {
    String licenseText = '';
    try {
      licenseText = await rootBundle.loadString(
        'packages/offline_document_viewer/assets/licenses/LICENSE-liberation',
      );
    } catch (_) {
      // If loading fails, catch the error and skip it silently as per requirements
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final permissionService = ref.watch(permissionServiceProvider);
    final isAndroid = permissionService.isAndroid;
    final scanState = ref.watch(scanStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Text(
            'Document Management',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Android Rescan action
          if (isAndroid) ...[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.sync_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: const Text('Rescan now'),
                subtitle: Text(
                  scanState.isScanning
                      ? 'Scanning... ${scanState.filesFound} files found'
                      : 'Scan device storage to refresh the document catalog',
                ),
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
                        try {
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
                                      'All files access permission is required to scan storage',
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
                                content: Text('Scanning started in background...'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to start scan: $e')),
                            );
                          }
                        }
                      },
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Import files action
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.green,
                ),
              ),
              title: const Text('Import files'),
              subtitle: const Text(
                'Select documents from storage or iCloud to import into app',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
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
          ),

          const SizedBox(height: 24),
          Text(
            'About & Legal',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('Doc Reader'),
                  subtitle: Text('Version 1.0.0 (Phase 3A)'),
                ),
                Divider(
                  height: 1,
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Open-source licenses'),
                  subtitle: const Text('View licenses for bundled open-source software'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'Doc Reader',
                      applicationVersion: '1.0.0',
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
                ListTile(
                  leading: const Icon(Icons.font_download_outlined),
                  title: const Text('Document engine fonts license'),
                  subtitle: const Text('Liberation Fonts and third-party notices'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showDocumentEngineLicense(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
