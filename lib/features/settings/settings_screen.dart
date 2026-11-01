import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

/// Screen managing application settings, manual scans, and manual file imports.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
            'About',
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
            child: const ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('Doc Reader'),
              subtitle: Text('Version 1.0.0 (Phase 1)'),
            ),
          ),
        ],
      ),
    );
  }
}
