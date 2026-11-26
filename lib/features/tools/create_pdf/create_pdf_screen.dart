import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/utils/app_log.dart';
import '../../../data/services/ads/ad_service.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../shared/widgets/ads/ad_placeholders.dart';
import '../../../shared/widgets/buttons/doc_buttons.dart';
import '../../../shared/widgets/create_pdf/color_swatch_row.dart';
import '../../../shared/widgets/create_pdf/page_count_stepper.dart';
import '../../../shared/widgets/create_pdf/paper_preview.dart';
import '../../../shared/widgets/create_pdf/template_card.dart';
import '../../../shared/widgets/navigation/doc_app_bar.dart';
import '../../../shared/widgets/navigation/doc_scaffold.dart';
import '../../providers/providers.dart';
import '../widgets/tool_error_sheet.dart';
import '../widgets/tool_progress_dialog.dart';
import '../widgets/tool_result_sheet.dart';
import 'create_pdf_service.dart';
import 'paper_template.dart';

/// Screen allowing users to configure and generate blank or ruled paper template PDFs.
///
/// Ad-free, enforces 1-100 page count, live preview, name sanitizer, and off-isolate generation.
class CreatePdfScreen extends ConsumerStatefulWidget {
  const CreatePdfScreen({super.key});

  @override
  ConsumerState<CreatePdfScreen> createState() => _CreatePdfScreenState();
}

class _CreatePdfScreenState extends ConsumerState<CreatePdfScreen> {
  late final TextEditingController _nameController;

  PaperTemplate _selectedTemplate = PaperTemplate.blank;
  PaperPageSize _selectedPageSize = PaperPageSize.a4;
  PaperOrientation _selectedOrientation = PaperOrientation.portrait;
  PaperColorSwatch _selectedSwatch = PaperColorSwatch.white;
  int _pageCount = 1;

  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    _nameController = TextEditingController(text: 'Doc_$timestamp');
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _getTemplateLabel(BuildContext context, PaperTemplate template) {
    final l10n = context.l10n;
    switch (template) {
      case PaperTemplate.blank:
        return l10n.createPdfTemplateBlank;
      case PaperTemplate.line1:
        return l10n.createPdfTemplateLine1;
      case PaperTemplate.line2:
        return l10n.createPdfTemplateLine2;
      case PaperTemplate.notebook:
        return l10n.createPdfTemplateNotebook;
      case PaperTemplate.cornell:
        return l10n.createPdfTemplateCornell;
      case PaperTemplate.grid:
        return l10n.createPdfTemplateGrid;
      case PaperTemplate.graph:
        return l10n.createPdfTemplateGraph;
    }
  }

  String _getSwatchLabel(BuildContext context, PaperColorSwatch swatch) {
    final l10n = context.l10n;
    switch (swatch) {
      case PaperColorSwatch.white:
        return l10n.createPdfSwatchWhite;
      case PaperColorSwatch.cream:
        return l10n.createPdfSwatchCream;
      case PaperColorSwatch.lightYellow:
        return l10n.createPdfSwatchLightYellow;
      case PaperColorSwatch.lightPeach:
        return l10n.createPdfSwatchLightPeach;
      case PaperColorSwatch.lightPink:
        return l10n.createPdfSwatchLightPink;
      case PaperColorSwatch.lightLavender:
        return l10n.createPdfSwatchLightLavender;
      case PaperColorSwatch.lightBlue:
        return l10n.createPdfSwatchLightBlue;
      case PaperColorSwatch.lightMint:
        return l10n.createPdfSwatchLightMint;
      case PaperColorSwatch.lightGreen:
        return l10n.createPdfSwatchLightGreen;
      case PaperColorSwatch.lightGray:
        return l10n.createPdfSwatchLightGray;
    }
  }

  String _getOrientationLabel(BuildContext context, PaperOrientation orientation) {
    final l10n = context.l10n;
    switch (orientation) {
      case PaperOrientation.portrait:
        return l10n.createPdfOrientationPortrait;
      case PaperOrientation.landscape:
        return l10n.createPdfOrientationLandscape;
    }
  }

  Future<void> _createPdf() async {
    final fileName = _nameController.text.trim();
    if (fileName.isEmpty) return;

    setState(() => _isGenerating = true);

    var progressDone = 0;
    StateSetter? dialogSetState;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDs) {
            dialogSetState = setDs;
            final fraction = _pageCount > 0 ? progressDone / _pageCount : 0.0;
            return ToolProgressDialog(
              title: context.l10n.createPdfCreating,
              message: context.l10n.createPdfProgress(progressDone, _pageCount),
              progress: fraction.clamp(0.0, 1.0),
              onCancel: null,
            );
          },
        );
      },
    );

    try {
      final docFile = await ref.read(createPdfServiceProvider).generateTemplatePdf(
            template: _selectedTemplate,
            pageSize: _selectedPageSize,
            orientation: _selectedOrientation,
            colorSwatch: _selectedSwatch,
            pageCount: _pageCount,
            fileName: fileName,
            onProgress: (done, total) {
              progressDone = done;
              dialogSetState?.call(() {});
            },
          );

      if (mounted) {
        // Dismiss progress dialog
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isGenerating = false);

        // Preload interstitial after successful tool operation result is produced
        unawaited(ref.read(adServiceProvider).preloadInterstitialAfterSuccess());

        // Show result sheet with created document
        await ToolResultSheet.show(
          context,
          files: [docFile],
          onDone: () async {
            if (mounted) {
              await InterstitialPlaceholder.show(context, ref: ref);
              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          },
        );
      }
    } catch (e, st) {
      AppLog.e('Tools', 'create_pdf_failed', e, st);
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isGenerating = false);

        final l10n = context.l10n;
        final String errorMessage;
        final String errorCode;
        if (e is CreatePdfException) {
          errorCode = e.reason.name.toUpperCase();
          switch (e.reason) {
            case CreatePdfErrorReason.pageCountOutOfRange:
              errorMessage = l10n.createPdfErrorPageCount;
              break;
            case CreatePdfErrorReason.invalidFileName:
              errorMessage = l10n.createPdfErrorInvalidName;
              break;
            case CreatePdfErrorReason.generationFailed:
            case CreatePdfErrorReason.saveFailed:
              errorMessage = l10n.createPdfErrorGeneration;
              break;
          }
        } else {
          errorCode = 'CREATE_FAILED';
          errorMessage = e.toString();
        }

        await ToolErrorSheet.show(
          context,
          title: l10n.createPdfErrorTitle,
          errorMessage: errorMessage,
          errorCode: errorCode,
          onRetry: _createPdf,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;

    final isNameValid = _nameController.text.trim().isNotEmpty;
    final canCreate = isNameValid && !_isGenerating && _pageCount >= 1 && _pageCount <= 100;

    return DocScaffold(
      showDockedBanner: false, // Ad-free editor
      isAdLoaded: false,
      appBar: DocSubAppBar(
        title: l10n.toolCreatePdf,
      ),
      body: Column(
        children: [
          // Scrollable Editor Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. File Name Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: l10n.toolsLabelFileName,
                        suffixText: '.pdf',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: tokens.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: tokens.hairline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: tokens.hairline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: tokens.interactiveBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Interactive Live Preview
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 240,
                        maxHeight: 220,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: PaperPreview(
                        template: _selectedTemplate,
                        pageSize: _selectedPageSize,
                        orientation: _selectedOrientation,
                        colorSwatch: _selectedSwatch,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Section: Template Cards
                  _buildSectionHeader(l10n.createPdfSectionTemplate),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: PaperTemplate.values.map((template) {
                        final isSelected = template == _selectedTemplate;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TemplateCard(
                            key: Key('template_card_${template.name}'),
                            template: template,
                            label: _getTemplateLabel(context, template),
                            isSelected: isSelected,
                            pageSize: _selectedPageSize,
                            orientation: _selectedOrientation,
                            colorSwatch: _selectedSwatch,
                            onTap: () {
                              setState(() => _selectedTemplate = template);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Section: Page Size Choice Chips
                  _buildSectionHeader(l10n.createPdfSectionPageSize),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: PaperPageSize.values.map((size) {
                        final isSelected = size == _selectedPageSize;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            key: Key('page_size_${size.name}'),
                            label: Text(size.label),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedPageSize = size);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 5. Section: Orientation Segmented Control
                  _buildSectionHeader(l10n.createPdfSectionOrientation),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SegmentedButton<PaperOrientation>(
                      segments: [
                        ButtonSegment<PaperOrientation>(
                          value: PaperOrientation.portrait,
                          label: Text(_getOrientationLabel(context, PaperOrientation.portrait)),
                          icon: const Icon(Icons.stay_current_portrait_outlined, size: 16),
                        ),
                        ButtonSegment<PaperOrientation>(
                          value: PaperOrientation.landscape,
                          label: Text(_getOrientationLabel(context, PaperOrientation.landscape)),
                          icon: const Icon(Icons.stay_current_landscape_outlined, size: 16),
                        ),
                      ],
                      selected: {_selectedOrientation},
                      onSelectionChanged: (newSelection) {
                        setState(() => _selectedOrientation = newSelection.first);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 6. Section: Page Color Swatches
                  _buildSectionHeader(l10n.createPdfSectionPageColor),
                  const SizedBox(height: 8),
                  ColorSwatchRow(
                    selectedSwatch: _selectedSwatch,
                    labelBuilder: (swatch) => _getSwatchLabel(context, swatch),
                    onSwatchSelected: (swatch) {
                      setState(() => _selectedSwatch = swatch);
                    },
                  ),

                  const SizedBox(height: 20),

                  // 7. Section: Page Count Stepper
                  _buildSectionHeader(l10n.createPdfSectionPageCount),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: PageCountStepper(
                        count: _pageCount,
                        countLabel: l10n.createPdfPagesCount(_pageCount),
                        min: 1,
                        max: 100,
                        onChanged: (newVal) {
                          setState(() => _pageCount = newVal);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Sticky Footer with Summary and Action CTA
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.paddingOf(context).bottom + 12,
            ),
            decoration: BoxDecoration(
              color: tokens.surfaceAlt,
              border: Border(
                top: BorderSide(color: tokens.hairline, width: 1),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.createPdfSummary(
                          l10n.createPdfPagesCount(_pageCount),
                          _selectedPageSize.label,
                          _getOrientationLabel(context, _selectedOrientation),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DocPrimaryButton(
                  key: const Key('create_pdf_submit_button'),
                  label: l10n.actionCreatePdf,
                  icon: const Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: canCreate ? _createPdf : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: DocViewTypography.labelMd.copyWith(
          color: context.tokens.textSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
