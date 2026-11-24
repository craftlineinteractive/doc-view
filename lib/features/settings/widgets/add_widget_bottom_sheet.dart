import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../data/services/widgets/widget_data_store.dart';
import '../../../shared/widgets/buttons/doc_buttons.dart';
import '../../../shared/widgets/dialogs/doc_dialog.dart';
import '../../../shared/widgets/sheets/doc_bottom_sheet.dart';

/// Modal bottom sheet allowing users to preview and pin Doc View home screen widgets.
class AddWidgetBottomSheet extends ConsumerStatefulWidget {
  const AddWidgetBottomSheet({
    super.key,
    this.widgetDataStoreOverride,
  });

  final WidgetDataStore? widgetDataStoreOverride;

  static Future<void> show(
    BuildContext context, {
    WidgetDataStore? widgetDataStoreOverride,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddWidgetBottomSheet(
        widgetDataStoreOverride: widgetDataStoreOverride,
      ),
    );
  }

  @override
  ConsumerState<AddWidgetBottomSheet> createState() => _AddWidgetBottomSheetState();
}

class _AddWidgetBottomSheetState extends ConsumerState<AddWidgetBottomSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isAdding = false;

  WidgetDataStore get _store =>
      widget.widgetDataStoreOverride ?? ref.read(widgetDataStoreProvider);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onAddWidgetPressed() async {
    if (_isAdding) return;
    setState(() => _isAdding = true);

    final isSupported = await _store.isPinSupported();
    if (!mounted) return;

    if (isSupported) {
      final widgetName = _currentPage == 0 ? 'recent_files' : 'quick_tools';
      await _store.requestPinWidget(widgetName);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() => _isAdding = false);
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (dialogCtx) => DocDialog(
            title: context.l10n.addWidgetManualTitle,
            body: context.l10n.addWidgetManualMessage,
            confirmLabel: context.l10n.actionConfirm,
            onConfirm: () => Navigator.of(dialogCtx).pop(),
            onCancel: () => Navigator.of(dialogCtx).pop(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DocBottomSheet(
      key: const Key('add_widget_bottom_sheet'),
      title: context.l10n.addWidgetSheetTitle,
      showCloseButton: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.addWidgetSheetSubtitle,
            style: DocViewTypography.bodyMedium.copyWith(
              color: tokens.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal PageView of Widgets
          SizedBox(
            height: MediaQuery.textScalerOf(context).scale(1.0) >= 1.4 ? 290 : 220,
            child: PageView(
              controller: _pageController,
              key: const Key('add_widget_page_view'),
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              children: [
                _buildRecentFilesCard(context, tokens, isDark),
                _buildQuickToolsCard(context, tokens, isDark),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Page indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPageDot(0, tokens),
              const SizedBox(width: 8),
              _buildPageDot(1, tokens),
            ],
          ),
          const SizedBox(height: 20),

          // Sticky action button
          DocPrimaryButton(
            key: const Key('add_widget_primary_button'),
            label: context.l10n.addWidgetButton,
            isLoading: _isAdding,
            onPressed: _onAddWidgetPressed,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPageDot(int index, DocViewTokens tokens) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      key: Key('widget_page_indicator_$index'),
      duration: const Duration(milliseconds: 200),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? tokens.primaryBlue : tokens.hairline,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildRecentFilesCard(
    BuildContext context,
    DocViewTokens tokens,
    bool isDark,
  ) {
    return Container(
      key: const Key('widget_card_recent_files'),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2333) : const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.widgetRecentFilesTitle,
                  style: DocViewTypography.headlineSm.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tokens.blueTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.l10n.widgetRecentFilesBadge,
                  style: DocViewTypography.labelMd.copyWith(
                    color: tokens.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.widgetRecentFilesDesc,
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),

          // Mini preview inside card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.hairline),
            ),
            child: Column(
              children: [
                _buildMiniFileRow(tokens, 'PDF', 'Contract_Agreement.pdf', '2m'),
                const SizedBox(height: 6),
                _buildMiniFileRow(tokens, 'DOCX', 'Quarterly_Report.docx', '1h'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickToolsCard(
    BuildContext context,
    DocViewTokens tokens,
    bool isDark,
  ) {
    return Container(
      key: const Key('widget_card_quick_tools'),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2333) : const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.widgetQuickToolsTitle,
                  style: DocViewTypography.headlineSm.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tokens.blueTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.l10n.widgetQuickToolsBadge,
                  style: DocViewTypography.labelMd.copyWith(
                    color: tokens.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.widgetQuickToolsDesc,
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),

          // Mini preview of 4 tools
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.hairline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniToolIcon(tokens, Icons.document_scanner_outlined, 'Scan'),
                _buildMiniToolIcon(tokens, Icons.image_outlined, 'Images'),
                _buildMiniToolIcon(tokens, Icons.search_rounded, 'Search'),
                _buildMiniToolIcon(tokens, Icons.file_upload_outlined, 'Import'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniFileRow(
    DocViewTokens tokens,
    String tag,
    String title,
    String time,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: tokens.blueTint,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tag,
            style: DocViewTypography.labelXs.copyWith(
              color: tokens.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: DocViewTypography.bodySm.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          time,
          style: DocViewTypography.bodySm.copyWith(
            color: tokens.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniToolIcon(DocViewTokens tokens, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: tokens.blueTint,
          child: Icon(icon, size: 14, color: tokens.primaryBlue),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: DocViewTypography.labelXs.copyWith(
            color: tokens.textPrimary,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
