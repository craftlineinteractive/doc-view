import 'package:docview/features/tools/tool_registry.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:docview/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final AppLocalizations l10n = AppLocalizationsEn();

  group('Tool Registry Contract Tests', () {
    test('Default G4a visible tools count is exactly 7', () {
      final visible = getVisibleTools();
      expect(visible.length, 7);

      final visibleIds = visible.map((t) => t.id).toList();
      expect(
        visibleIds,
        [
          'image_to_pdf',
          'scan_to_pdf',
          'manage_pages',
          'merge_pdf',
          'split_pdf',
          'import_files',
          'print_pdf',
        ],
      );
    });

    test('Visible tools per section match G4a specification', () {
      final convertTools = getToolsForSection(ToolSection.convertAndCreate);
      expect(convertTools.map((t) => t.id).toList(), [
        'image_to_pdf',
        'scan_to_pdf',
      ]);

      final editTools = getToolsForSection(ToolSection.editAndManage);
      expect(editTools.map((t) => t.id).toList(), [
        'manage_pages',
        'merge_pdf',
        'split_pdf',
      ]);

      final otherTools = getToolsForSection(ToolSection.others);
      expect(otherTools.map((t) => t.id).toList(), [
        'import_files',
        'print_pdf',
      ]);
    });

    test('Future gated tools exist in registry but are disabled by default', () {
      final gatedIds = [
        'create_pdf',
        'word_to_pdf',
        'ppt_to_pdf',
        'annotate',
        'add_text',
        'sign',
        'recycle_bin',
      ];

      for (final id in gatedIds) {
        final tool = getToolById(id);
        expect(tool, isNotNull, reason: 'Tool $id should exist in registry');
        expect(tool!.isEnabled(), isFalse, reason: 'Tool $id should be flagged off by default');
      }
    });

    test('Forbidden tool ids are strictly absent from visible tools or registry', () {
      final strictlyForbiddenFromRegistry = [
        'ocr',
        'compress',
        'password',
        'unlock',
        'protect',
        'encrypt',
        'edit_text',
        'template',
      ];

      for (final tool in toolRegistry) {
        for (final keyword in strictlyForbiddenFromRegistry) {
          expect(
            tool.id.toLowerCase().contains(keyword),
            isFalse,
            reason: 'Tool id "${tool.id}" contains forbidden keyword "$keyword"',
          );
        }
      }

      final forbiddenFromVisible = [
        'ocr',
        'compress',
        'protect',
        'unlock',
        'word_to_pdf',
        'ppt_to_pdf',
        'edit_text',
        'template',
      ];

      final visibleIds = getVisibleTools().map((t) => t.id).toSet();
      for (final id in forbiddenFromVisible) {
        expect(
          visibleIds.contains(id),
          isFalse,
          reason: 'Tool id "$id" must not be enabled/visible',
        );
      }
    });

    test('Every tool definition adheres to quality and localization contract', () {
      final seenIds = <String>{};

      for (final tool in toolRegistry) {
        // Unique ID format
        expect(tool.id, isNotEmpty);
        expect(RegExp(r'^[a-z]+(_[a-z]+)*$').hasMatch(tool.id), isTrue);
        expect(seenIds.add(tool.id), isTrue, reason: 'Duplicate tool id ${tool.id}');

        // Icon and gradient
        expect(tool.icon, isNotNull);
        expect(tool.gradient.colors.length, greaterThanOrEqualTo(2));

        // Localization
        final title = tool.title(l10n);
        final subtitle = tool.subtitle(l10n);
        expect(title, isNotEmpty);
        expect(subtitle, isNotEmpty);
      }
    });

    test('Section header titles are localized', () {
      expect(getSectionHeaderTitle(ToolSection.convertAndCreate, l10n), 'CONVERT & CREATE');
      expect(getSectionHeaderTitle(ToolSection.editAndManage, l10n), 'EDIT & MANAGE');
      expect(getSectionHeaderTitle(ToolSection.others, l10n), 'OTHERS');
    });

    test('getToolById returns correct tool or null', () {
      expect(getToolById('image_to_pdf')?.id, 'image_to_pdf');
      expect(getToolById('print_pdf')?.id, 'print_pdf');
      expect(getToolById('non_existent_tool'), isNull);
    });
  });
}
