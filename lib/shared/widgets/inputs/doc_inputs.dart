import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Pill search input field (48pt height).
class DocSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final bool autofocus;

  const DocSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = 'Search documents...',
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(AppIcons.search, size: 20, color: tokens.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              style: DocViewTypography.bodyLg.copyWith(color: tokens.textPrimary),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onClear?.call();
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(AppIcons.close, size: 18, color: tokens.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

/// Versatile form text field supporting:
/// - Floating / static top label
/// - Locked extension suffix (e.g. `.pdf` in rename dialog)
/// - Obscure password toggle eye
/// - Error text validation styling
/// - Number / numeric range input
class DocTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? lockedSuffix;
  final bool isPassword;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final int maxLines;

  const DocTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.lockedSuffix,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  State<DocTextField> createState() => _DocTextFieldState();
}

class _DocTextFieldState extends State<DocTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: DocViewTypography.labelMd.copyWith(
              color: hasError ? Theme.of(context).colorScheme.error : tokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? Theme.of(context).colorScheme.error : tokens.hairline,
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: widget.prefixIcon!,
                ),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: _obscureText,
                  keyboardType: widget.keyboardType,
                  maxLines: widget.isPassword ? 1 : widget.maxLines,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  style: DocViewTypography.bodyLg.copyWith(color: tokens.textPrimary),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
              ),
              if (widget.lockedSuffix != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: tokens.surfaceHover,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(11)),
                  ),
                  child: Text(
                    widget.lockedSuffix!,
                    style: DocViewTypography.titleMd.copyWith(
                      color: tokens.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
              if (widget.isPassword) ...[
                IconButton(
                  tooltip: _obscureText ? 'Show password' : 'Hide password',
                  icon: Icon(
                    _obscureText ? AppIcons.eye : AppIcons.eyeOff,
                    size: 20,
                    color: tokens.textSecondary,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ],
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.errorText!,
              style: DocViewTypography.bodySm.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Segmented control container with smooth pill animation.
class DocSegmentedControl<T> extends StatelessWidget {
  final Map<T, String> options;
  final T selectedValue;
  final ValueChanged<T> onValueChanged;

  const DocSegmentedControl({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Row(
        children: options.entries.map((entry) {
          final isSelected = entry.key == selectedValue;
          return Expanded(
            child: GestureDetector(
              onTap: () => onValueChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? tokens.surfaceAlt : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  entry.value,
                  style: DocViewTypography.labelMd.copyWith(
                    color: isSelected ? tokens.textPrimary : tokens.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Styled Checkbox matching design tokens.
class DocCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;

  const DocCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final box = GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: value ? tokens.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? tokens.primaryBlue : tokens.textSecondary,
            width: 2,
          ),
        ),
        child: value
            ? const Icon(AppIcons.check, size: 16, color: Colors.white)
            : null,
      ),
    );

    if (label == null) return box;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          box,
          const SizedBox(width: 10),
          Text(label!, style: DocViewTypography.bodyMd.copyWith(color: tokens.textPrimary)),
        ],
      ),
    );
  }
}

/// Styled Radio button matching design tokens.
class DocRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final String? label;

  const DocRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isSelected = value == groupValue;

    final radio = GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? tokens.primaryBlue : tokens.textSecondary,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.primaryBlue,
                  ),
                ),
              )
            : null,
      ),
    );

    if (label == null) return radio;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          radio,
          const SizedBox(width: 10),
          Text(label!, style: DocViewTypography.bodyMd.copyWith(color: tokens.textPrimary)),
        ],
      ),
    );
  }
}

/// Styled Switch toggle matching design tokens.
class DocSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const DocSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: tokens.primaryBlue,
      inactiveThumbColor: tokens.textSecondary,
      inactiveTrackColor: tokens.hairline,
    );
  }
}

