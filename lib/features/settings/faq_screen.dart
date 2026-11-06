import 'package:flutter/material.dart';

/// Static Frequently Asked Questions screen providing clear, honest answers
/// about storage permissions, privacy, offline execution, and file management.
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final questions = const [
      _FaqItem(
        question: 'Why does Doc View need All files access on Android?',
        answer:
            'Doc View requires All files access (MANAGE_EXTERNAL_STORAGE) on Android 11+ to discover and index supported documents (PDF, Word, Excel, PowerPoint, Text, and Images) stored in shared folders such as Downloads and Documents.\n\nWithout this permission, Android restricts file access to the app\'s private internal folder, preventing Doc View from browsing or opening files located across your device.',
      ),
      _FaqItem(
        question: 'Why is there no network or cloud sync?',
        answer:
            'Doc View is strictly offline-first. Keeping everything on-device guarantees maximum privacy, fast performance, and zero dependency on remote servers or subscriptions. Your documents are never transmitted over the internet.',
      ),
      _FaqItem(
        question: 'How do I open a file in another app?',
        answer:
            'Tap the more options icon (three dots) on any document tile and tap "Share". You can then select any installed app from the system share sheet to view or send your document.',
      ),
      _FaqItem(
        question: 'Where are imported and created files stored?',
        answer:
            'Files you import or generate (such as converted PDFs, merged documents, or split pages) are saved securely in the app\'s local documents storage or your designated device output folder.',
      ),
      _FaqItem(
        question: 'How do I delete a file?',
        answer:
            'Tap the more options icon on any file tile and select "Delete", or long-press a file to enter selection mode, pick multiple items, and tap the delete icon in the app bar. Deleting permanently removes the file from both Doc View and your device storage.',
      ),
      _FaqItem(
        question: 'Is my data uploaded anywhere?',
        answer:
            'No; the app has no network features and all operations run locally. Doc View contains zero networking libraries, telemetry trackers, or external cloud endpoints. All file parsing, indexing, and viewing happen entirely on your device.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: questions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = questions[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Text(
                item.question,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  item.answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

