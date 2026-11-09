import 'package:flutter/material.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_colors.dart';

/// Renders a document icon shaped like a rounded rectangle with the
/// top-right corner folded forward to the front side.
///
/// In the center of the document, displays the format indicator:
/// - PDF: 'PDF'
/// - Word: 'W'
/// - Excel: 'X'
/// - PPT: 'PPT'
/// - TXT: 'TXT'
/// - Image: Photo/camera icon
/// - Folders / All: Folder / search icon
class DocFoldedIcon extends StatelessWidget {
  final FileCategory? category;
  final String? label;
  final IconData? icon;
  final Color? color;
  final double width;
  final double height;
  final double borderRadius;
  final double? foldSize;
  final double? fontSize;
  final double? iconSize;
  final bool hasFold;

  const DocFoldedIcon({
    super.key,
    this.category,
    this.label,
    this.icon,
    this.color,
    this.width = 32,
    this.height = 38,
    this.borderRadius = 5.0,
    this.foldSize,
    this.fontSize,
    this.iconSize,
    this.hasFold = true,
  });

  Color _defaultColor() {
    if (color != null) return color!;
    if (category == null) {
      final clean = label?.toLowerCase() ?? '';
      if (clean.contains('folder') || clean.contains('director')) {
        return DocViewColors.folderSolid;
      }
      return DocViewColors.interactiveBlue;
    }
    switch (category!) {
      case FileCategory.pdf:
        return DocViewColors.pdfSolid;
      case FileCategory.word:
        return DocViewColors.wordSolid;
      case FileCategory.excel:
        return DocViewColors.excelSolid;
      case FileCategory.ppt:
        return DocViewColors.pptSolid;
      case FileCategory.txt:
        return DocViewColors.txtSolid;
      case FileCategory.image:
        return DocViewColors.imageSolid;
      case FileCategory.other:
        return DocViewColors.txtSolid;
    }
  }

  Widget _buildContent() {
    if (icon != null) {
      return Icon(
        icon,
        size: iconSize ?? (width * 0.50),
        color: Colors.white,
      );
    }

    if (category == null) {
      final cleanLabel = label?.toLowerCase() ?? '';
      if (cleanLabel.contains('folder') || cleanLabel.contains('director')) {
        return Icon(
          Icons.manage_search,
          size: iconSize ?? (width * 0.52),
          color: Colors.white,
        );
      }
      return Icon(
        Icons.folder,
        size: iconSize ?? (width * 0.52),
        color: Colors.white,
      );
    }

    switch (category!) {
      case FileCategory.pdf:
        return Text(
          label ?? 'PDF',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: fontSize ?? (width * 0.32),
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        );
      case FileCategory.word:
        return Text(
          label ?? 'W',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: fontSize ?? (width * 0.44),
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        );
      case FileCategory.excel:
        return Text(
          label ?? 'X',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: fontSize ?? (width * 0.44),
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        );
      case FileCategory.ppt:
        return Text(
          label ?? 'PPT',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: fontSize ?? (width * 0.32),
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        );
      case FileCategory.txt:
        return Text(
          label ?? 'TXT',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: fontSize ?? (width * 0.28),
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        );
      case FileCategory.image:
        return Icon(
          Icons.photo_camera_outlined,
          size: iconSize ?? (width * 0.52),
          color: Colors.white,
        );
      case FileCategory.other:
        return Icon(
          Icons.insert_drive_file,
          size: iconSize ?? (width * 0.50),
          color: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = _defaultColor();
    final effectiveFold = foldSize ?? (width * 0.28).clamp(7.0, 12.0);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: _DocFoldedPainter(
              color: effectiveColor,
              borderRadius: borderRadius,
              foldSize: effectiveFold,
              hasFold: hasFold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: hasFold ? (effectiveFold * 0.15) : 0),
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}

class _DocFoldedPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double foldSize;
  final bool hasFold;

  const _DocFoldedPainter({
    required this.color,
    required this.borderRadius,
    required this.foldSize,
    required this.hasFold,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = borderRadius.clamp(0.0, w / 4);
    final fold = foldSize.clamp(4.0, w / 2);

    if (!hasFold) {
      // Clean rounded square / rectangle for Folders and All categories
      final rrect = RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(r),
      );
      final shadowPaint = Paint()
        ..color = const Color(0x1F000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawRRect(rrect.shift(const Offset(0, 1.2)), shadowPaint);

      final bodyPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, bodyPaint);
      return;
    }

    // 1. Base document path with diagonal cut at top-right
    final bodyPath = Path()
      ..moveTo(r, 0)
      ..lineTo(w - fold, 0)
      ..lineTo(w, fold)
      ..lineTo(w, h - r)
      ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
      ..lineTo(r, h)
      ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..close();

    // 2. Soft shadow under the document
    final shadowPaint = Paint()
      ..color = const Color(0x1F000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(bodyPath.shift(const Offset(0, 1.2)), shadowPaint);

    // 3. Fill document body with vibrant category color
    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, bodyPaint);

    // 4. Folded corner flap path (folded forward onto the front face)
    // Triangle: (w - fold, 0) -> (w - fold, fold) -> (w, fold)
    final flapPath = Path()
      ..moveTo(w - fold, 0)
      ..lineTo(w - fold, fold - 1.5)
      ..arcToPoint(Offset(w - fold + 1.5, fold), radius: const Radius.circular(1.5))
      ..lineTo(w, fold)
      ..close();

    // 5. Crease drop shadow under the flap onto the body (to bottom-left)
    final flapShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawPath(flapPath.shift(const Offset(-0.8, 0.8)), flapShadowPaint);

    // 6. Fill flap with crisp paper highlight
    final flapFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.36)
      ..style = PaintingStyle.fill;
    canvas.drawPath(flapPath, flapFill);

    // 7. Flap outline for high-contrast crispness
    final flapStroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;
    canvas.drawPath(flapPath, flapStroke);
  }

  @override
  bool shouldRepaint(covariant _DocFoldedPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.foldSize != foldSize ||
        oldDelegate.hasFold != hasFold;
  }
}
