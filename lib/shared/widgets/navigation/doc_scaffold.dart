import 'package:flutter/material.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../ads/ad_placeholders.dart';

/// App scaffold enforcing edge-to-edge layout, header background gradients,
/// docked 60pt AdMob banner slot, and >=16pt FAB clearance above ads and bottom bar.
class DocScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool showDockedBanner;
  final bool applyHeaderGradient;
  final bool isAdLoaded;
  final VoidCallback? onAdTap;

  const DocScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.showDockedBanner = false,
    this.applyHeaderGradient = false,
    this.isAdLoaded = true,
    this.onAdTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = body;

    // Apply pale-blue to white radial/linear header gradient in Light mode if requested
    if (applyHeaderGradient && !isDark) {
      content = Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    tokens.headerGradientStart,
                    tokens.headerGradientEnd,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(child: body),
        ],
      );
    }

    // Build bottom area combining docked ad banner (if enabled) + bottomNavigationBar
    Widget? combinedBottomArea;
    if (showDockedBanner || bottomNavigationBar != null) {
      combinedBottomArea = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDockedBanner)
            AdBannerSlot(
              isLoaded: isAdLoaded,
              onTap: onAdTap,
            ),
          ?bottomNavigationBar,
        ],
      );
    }

    // Wrap FAB with clearance padding if needed
    Widget? positionedFab = floatingActionButton;
    if (floatingActionButton != null) {
      // 16pt bottom clearance above the banner/bottom bar
      positionedFab = Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: floatingActionButton,
      );
    }

    return Scaffold(
      backgroundColor: isDark ? tokens.readerCanvas : tokens.surface,
      appBar: appBar,
      body: content,
      floatingActionButton: positionedFab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: combinedBottomArea,
      bottomSheet: bottomSheet,
    );
  }
}

