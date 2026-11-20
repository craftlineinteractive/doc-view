import 'package:flutter/material.dart';
import '../../core/config/feature_flags.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/tool_gradients.dart';
import '../../l10n/app_localizations.dart';

/// Logical groupings for tools displayed on the Tools tab.
enum ToolSection {
  convertAndCreate,
  editAndManage,
  others,
}

/// Definition of a tool in the centralized tool registry.
class ToolDef {
  const ToolDef({
    required this.id,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.route,
    this.onTap,
    this.isEnabled = _defaultEnabled,
    this.isPremium = _defaultDisabled,
  });

  /// Unique identifier used for widget keys and analytics (e.g. 'image_to_pdf').
  final String id;

  /// Functional section category.
  final ToolSection section;

  /// Localized title getter.
  final String Function(AppLocalizations l10n) title;

  /// Localized subtitle/caption getter.
  final String Function(AppLocalizations l10n) subtitle;

  /// Icon glyph rendered in the tool tile.
  final IconData icon;

  /// High-contrast background gradient for the tool icon.
  final LinearGradient gradient;

  /// Optional named route or path to navigate to when tapped.
  final String? route;

  /// Custom tap handler if the tool does not use simple route navigation.
  final void Function(BuildContext context)? onTap;

  /// Dynamic predicate determining whether this tool is visible.
  final bool Function() isEnabled;

  /// Dynamic predicate determining if tool requires premium status.
  final bool Function() isPremium;

  static bool _defaultEnabled() => true;
  static bool _defaultDisabled() => false;
}

/// Central registry of all current and upcoming tools.
final List<ToolDef> toolRegistry = <ToolDef>[
  // --- Section 1: Convert & Create ---
  ToolDef(
    id: 'image_to_pdf',
    section: ToolSection.convertAndCreate,
    title: (l10n) => l10n.toolImageToPdf,
    subtitle: (l10n) => l10n.toolImageToPdfSub,
    icon: AppIcons.image,
    gradient: ToolGradients.imageToPdf,
    route: null, // Handled via picker in screen
    isEnabled: () => true,
  ),
  ToolDef(
    id: 'scan_to_pdf',
    section: ToolSection.convertAndCreate,
    title: (l10n) => l10n.toolScanToPdf,
    subtitle: (l10n) => l10n.toolScanToPdfSub,
    icon: AppIcons.scanner,
    gradient: ToolGradients.scanToPdf,
    route: null, // Handled via scanner in screen
    isEnabled: () => true,
  ),
  ToolDef(
    id: 'create_pdf',
    section: ToolSection.convertAndCreate,
    title: (l10n) => l10n.toolCreatePdf,
    subtitle: (l10n) => l10n.toolCreatePdfSub,
    icon: Icons.note_add_outlined,
    gradient: ToolGradients.createPdf,
    route: '/tools/create-pdf',
    isEnabled: () => createPdfEnabled,
  ),
  ToolDef(
    id: 'word_to_pdf',
    section: ToolSection.convertAndCreate,
    title: (l10n) => l10n.toolWordToPdf,
    subtitle: (l10n) => l10n.toolWordToPdfSub,
    icon: AppIcons.word,
    gradient: ToolGradients.wordToPdf,
    isEnabled: () => conversionsEnabled,
  ),
  ToolDef(
    id: 'ppt_to_pdf',
    section: ToolSection.convertAndCreate,
    title: (l10n) => l10n.toolPptToPdf,
    subtitle: (l10n) => l10n.toolPptToPdfSub,
    icon: AppIcons.ppt,
    gradient: ToolGradients.pptToPdf,
    isEnabled: () => conversionsEnabled,
  ),

  // --- Section 2: Edit & Manage ---
  ToolDef(
    id: 'manage_pages',
    section: ToolSection.editAndManage,
    title: (l10n) => l10n.toolManagePages,
    subtitle: (l10n) => l10n.toolManagePagesSub,
    icon: Icons.auto_stories_outlined,
    gradient: ToolGradients.managePages,
    route: null, // Handled via picker in screen
    isEnabled: () => true,
  ),
  ToolDef(
    id: 'merge_pdf',
    section: ToolSection.editAndManage,
    title: (l10n) => l10n.toolMergePdf,
    subtitle: (l10n) => l10n.toolMergePdfSub,
    icon: AppIcons.merge,
    gradient: ToolGradients.mergePdf,
    route: null, // Handled via picker in screen
    isEnabled: () => true,
  ),
  ToolDef(
    id: 'split_pdf',
    section: ToolSection.editAndManage,
    title: (l10n) => l10n.toolSplitPdf,
    subtitle: (l10n) => l10n.toolSplitPdfSub,
    icon: AppIcons.split,
    gradient: ToolGradients.splitPdf,
    route: null, // Handled via picker in screen
    isEnabled: () => true,
  ),
  ToolDef(
    id: 'annotate',
    section: ToolSection.editAndManage,
    title: (l10n) => l10n.toolAnnotate,
    subtitle: (l10n) => l10n.toolAnnotateSub,
    icon: Icons.edit_note_outlined,
    gradient: ToolGradients.annotate,
    isEnabled: () => annotateEnabled,
  ),
  ToolDef(
    id: 'add_text',
    section: ToolSection.editAndManage,
    title: (l10n) => l10n.toolAddText,
    subtitle: (l10n) => l10n.toolAddTextSub,
    icon: Icons.text_fields_outlined,
    gradient: ToolGradients.addText,
    isEnabled: () => addTextEnabled,
  ),
  ToolDef(
    id: 'sign',
    section: ToolSection.editAndManage,
    title: (l10n) => l10n.toolSign,
    subtitle: (l10n) => l10n.toolSignSub,
    icon: Icons.draw_outlined,
    gradient: ToolGradients.sign,
    isEnabled: () => signEnabled,
  ),

  // --- Section 3: Others ---
  ToolDef(
    id: 'import_files',
    section: ToolSection.others,
    title: (l10n) => l10n.toolImportFiles,
    subtitle: (l10n) => l10n.toolImportFilesSub,
    icon: Icons.drive_folder_upload_outlined,
    gradient: ToolGradients.importFiles,
    route: null, // Handled via ImportService in screen
    isEnabled: () => true,
  ),
  ToolDef(
    id: 'print_pdf',
    section: ToolSection.others,
    title: (l10n) => l10n.toolPrintPdf,
    subtitle: (l10n) => l10n.toolPrintPdfSub,
    icon: AppIcons.print,
    gradient: ToolGradients.printPdf,
    route: null, // Handled via print flow in screen
    isEnabled: () => true,
  ),
  ToolDef(
    id: 'recycle_bin',
    section: ToolSection.others,
    title: (l10n) => l10n.toolRecycleBin,
    subtitle: (l10n) => l10n.toolRecycleBinSub,
    icon: Icons.restore_from_trash_outlined,
    gradient: ToolGradients.recycleBin,
    route: '/tools/recycle-bin',
    isEnabled: () => recycleBinEnabled,
  ),
];

/// Returns all currently enabled tools across all sections.
List<ToolDef> getVisibleTools() {
  return toolRegistry.where((tool) => tool.isEnabled()).toList();
}

/// Returns enabled tools belonging to a specific section.
List<ToolDef> getToolsForSection(ToolSection section) {
  return getVisibleTools().where((tool) => tool.section == section).toList();
}

/// Localized section heading string.
String getSectionHeaderTitle(ToolSection section, AppLocalizations l10n) {
  switch (section) {
    case ToolSection.convertAndCreate:
      return l10n.toolsSectionConvertCreate;
    case ToolSection.editAndManage:
      return l10n.toolsSectionEditManage;
    case ToolSection.others:
      return l10n.toolsSectionOthers;
  }
}

/// Look up a tool definition by its unique identifier.
ToolDef? getToolById(String id) {
  for (final tool in toolRegistry) {
    if (tool.id == id) return tool;
  }
  return null;
}
