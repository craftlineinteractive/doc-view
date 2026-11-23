import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../data/models/pdf_text_box.dart';
import '../../../../data/services/pdf/text_layout_engine.dart';

/// Interactive draggable, resizable text box widget overlaid on a PDF page.
///
/// Supports inline editing, horizontal side handles, vertical auto-expansion,
/// and >= 48dp accessible touch targets.
class TextBoxOverlay extends StatefulWidget {
  const TextBoxOverlay({
    required this.box,
    required this.isSelected,
    required this.pageSize,
    required this.onTap,
    required this.onMoved,
    required this.onResized,
    required this.onTextChanged,
    required this.onDeleted,
    required this.onEditingComplete,
    this.isEditing = false,
    super.key,
  });

  final PdfTextBox box;
  final bool isSelected;
  final Size pageSize;
  final VoidCallback onTap;
  final ValueChanged<Rect> onMoved;
  final ValueChanged<Rect> onResized;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onDeleted;
  final VoidCallback onEditingComplete;
  final bool isEditing;

  static const double minWidth = 60.0;
  static const double handleSize = 24.0;
  static const double touchTarget = 48.0;

  @override
  State<TextBoxOverlay> createState() => _TextBoxOverlayState();
}

class _TextBoxOverlayState extends State<TextBoxOverlay> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.box.text);
    _focusNode = FocusNode();

    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  void didUpdateWidget(TextBoxOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.box.text != widget.box.text && _textController.text != widget.box.text) {
      _textController.text = widget.box.text;
    }
    if (!oldWidget.isEditing && widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    var newLeft = widget.box.bounds.left + details.delta.dx;
    var newTop = widget.box.bounds.top + details.delta.dy;

    newLeft = newLeft.clamp(0.0, (widget.pageSize.width - widget.box.bounds.width).clamp(0.0, double.infinity));
    newTop = newTop.clamp(0.0, (widget.pageSize.height - widget.box.bounds.height).clamp(0.0, double.infinity));

    final newRect = Rect.fromLTWH(
      newLeft,
      newTop,
      widget.box.bounds.width,
      widget.box.bounds.height,
    );
    widget.onMoved(newRect);
  }

  void _handleSideResize(DragUpdateDetails details, {required bool isRight}) {
    final maxWidth = widget.pageSize.width;
    var newWidth = widget.box.bounds.width + (isRight ? details.delta.dx : -details.delta.dx);
    newWidth = newWidth.clamp(TextBoxOverlay.minWidth, maxWidth);

    var newLeft = isRight ? widget.box.bounds.left : widget.box.bounds.right - newWidth;
    newLeft = newLeft.clamp(0.0, widget.pageSize.width - newWidth);

    // Recompute height from new width using TextLayoutEngine
    final layout = TextLayoutEngine.layoutText(
      text: widget.box.text.isEmpty ? ' ' : widget.box.text,
      fontSize: widget.box.fontSize,
      isBold: widget.box.isBold,
      isItalic: widget.box.isItalic,
      maxWidth: newWidth,
      alignment: widget.box.alignment,
    );

    final newHeight = layout.totalHeight.clamp(widget.box.fontSize * 1.5, widget.pageSize.height);
    final newRect = Rect.fromLTWH(newLeft, widget.box.bounds.top, newWidth, newHeight);
    widget.onResized(newRect);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bounds = widget.box.bounds;

    final textStyle = TextStyle(
      fontFamily: 'Arimo',
      fontSize: widget.box.fontSize,
      color: Color(widget.box.colorValue),
      fontWeight: widget.box.isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: widget.box.isItalic ? FontStyle.italic : FontStyle.normal,
      height: 1.25,
    );

    return Positioned(
      left: bounds.left,
      top: bounds.top,
      width: bounds.width,
      height: bounds.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Body & drag gesture area
          GestureDetector(
            onTap: widget.onTap,
            onPanUpdate: widget.isSelected ? _handlePanUpdate : null,
            child: Container(
              width: bounds.width,
              height: bounds.height,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? tokens.primaryBlue.withValues(alpha: 0.08)
                    : Colors.transparent,
                border: Border.all(
                  color: widget.isSelected ? tokens.primaryBlue : Colors.transparent,
                  width: widget.isSelected ? 1.5 : 0.0,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: widget.isEditing
                  ? TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      style: textStyle,
                      textAlign: widget.box.alignment,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      maxLength: PdfTextBox.maxCharactersPerBox,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: context.l10n.addTextPlaceholder,
                        hintStyle: textStyle.copyWith(
                          color: tokens.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                      onChanged: (val) {
                        widget.onTextChanged(val);
                      },
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        _focusNode.unfocus();
                        widget.onEditingComplete();
                      },
                      onEditingComplete: () {
                        _focusNode.unfocus();
                        widget.onEditingComplete();
                      },
                      onTapOutside: (_) {
                        _focusNode.unfocus();
                        widget.onEditingComplete();
                      },
                    )
                  : Text(
                      widget.box.text.isEmpty
                          ? context.l10n.addTextPlaceholder
                          : widget.box.text,
                      style: widget.box.text.isEmpty
                          ? textStyle.copyWith(
                              color: tokens.textSecondary.withValues(alpha: 0.5),
                            )
                          : textStyle,
                      textAlign: widget.box.alignment,
                    ),
            ),
          ),

          // Delete button (top-right, >= 48dp hit area)
          if (widget.isSelected && !widget.isEditing)
            Positioned(
              right: -24,
              top: -24,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onDeleted,
                child: Container(
                  width: TextBoxOverlay.touchTarget,
                  height: TextBoxOverlay.touchTarget,
                  alignment: Alignment.center,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Left side resize handle (hit area >= 48dp)
          if (widget.isSelected && !widget.isEditing)
            Positioned(
              left: -24,
              top: bounds.height / 2 - 24,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (d) => _handleSideResize(d, isRight: false),
                child: Container(
                  width: TextBoxOverlay.touchTarget,
                  height: TextBoxOverlay.touchTarget,
                  alignment: Alignment.center,
                  child: Container(
                    width: 8,
                    height: 24,
                    decoration: BoxDecoration(
                      color: tokens.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Right side resize handle (hit area >= 48dp)
          if (widget.isSelected && !widget.isEditing)
            Positioned(
              right: -24,
              top: bounds.height / 2 - 24,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (d) => _handleSideResize(d, isRight: true),
                child: Container(
                  width: TextBoxOverlay.touchTarget,
                  height: TextBoxOverlay.touchTarget,
                  alignment: Alignment.center,
                  child: Container(
                    width: 8,
                    height: 24,
                    decoration: BoxDecoration(
                      color: tokens.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
