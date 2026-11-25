import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/feature_flags.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/l10n/language_catalog.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../data/models/app_settings.dart';
import '../../data/services/ads/consent_gateway.dart';
import '../../data/services/notifications/quick_access_notification_service.dart';
import '../../shared/widgets/dialogs/doc_dialog.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/settings/settings_footer.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../../shared/widgets/tiles/settings_row.dart';
import '../debug/component_gallery_screen.dart';
import '../providers/providers.dart';
import 'widgets/add_widget_bottom_sheet.dart';
import 'widgets/rate_us_sheet.dart';
import 'widgets/theme_selection_sheet.dart';

/// Main Settings tab structured per G2 owner decisions:
/// - Top group: File manager, FAQ, Share (if storeShareUrl set)
/// - General: Scan settings, App theme, Language (conditional), Rate us
/// - Others (when non-empty): Add Widget (flag), Terms of use, Privacy policy,
///   Manage subscriptions (flag)
/// - Centered footer: Version X.Y.Z (N).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({
    super.key,
    this.isLoading = false,
    this.isReleaseOverride,
    this.shippedLanguageCountOverride,
    this.premiumEnabledOverride,
    this.widgetsEnabledOverride,
    this.storeShareUrlOverride,
    this.termsOfUseUrlOverride,
    this.privacyPolicyUrlOverride,
    this.storeRateUrlOverride,
    this.showAdChoicesOverride,
    this.onExternalUrlLaunch,
  });

  /// Displays grouped skeleton placeholders while true.
  final bool isLoading;

  /// Optional test overrides for release/flag/constant gating.
  final bool? isReleaseOverride;
  final int? shippedLanguageCountOverride;
  final bool? premiumEnabledOverride;
  final bool? widgetsEnabledOverride;
  final String? storeShareUrlOverride;
  final String? termsOfUseUrlOverride;
  final String? privacyPolicyUrlOverride;
  final String? storeRateUrlOverride;
  final bool? showAdChoicesOverride;
  final Future<void> Function(Uri uri)? onExternalUrlLaunch;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;
  bool _isQuickAccessNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
    _loadNotificationPref();
  }

  Future<void> _loadNotificationPref() async {
    try {
      final enabled =
          await ref.read(quickAccessNotificationServiceProvider).isEnabled();
      if (mounted) {
        setState(() => _isQuickAccessNotificationEnabled = enabled);
      }
    } catch (_) {}
  }

  Future<void> _toggleQuickAccessNotification(bool enabled) async {
    final service = ref.read(quickAccessNotificationServiceProvider);
    if (enabled && Platform.isAndroid) {
      final granted = await service.requestPermission();
      if (!granted && mounted) {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (dCtx) => DocDialog(
            title: context.l10n.notificationPermissionDialogTitle,
            body: context.l10n.notificationPermissionDialogDesc,
            confirmLabel: context.l10n.actionConfirm,
            onConfirm: () => Navigator.of(dCtx).pop(true),
            onCancel: () => Navigator.of(dCtx).pop(false),
          ),
        );
        if (proceed != true) return;
        await service.requestPermission();
      }
    }
    if (!mounted) return;
    await service.setEnabled(
      enabled,
      title: context.l10n.notificationTitle,
      body: context.l10n.notificationBody,
      scanLabel: context.l10n.notificationActionScan,
      imageToPdfLabel: context.l10n.notificationActionImageToPdf,
      searchLabel: context.l10n.notificationActionSearch,
    );
    if (mounted) {
      setState(() => _isQuickAccessNotificationEnabled = enabled);
    }
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = info;
        });
      }
    } catch (_) {
      // Fall back to default version 1.0.0 (1) when platform channel unavailable.
    }
  }

  String get _effectiveShareUrl =>
      widget.storeShareUrlOverride ?? AppConstants.storeShareUrl;
  String get _effectiveTermsUrl =>
      widget.termsOfUseUrlOverride ?? AppConstants.termsOfUseUrl;
  String get _effectivePrivacyUrl =>
      widget.privacyPolicyUrlOverride ?? AppConstants.privacyPolicyUrl;
  bool get _effectivePremiumEnabled =>
      widget.premiumEnabledOverride ?? premiumEnabled;
  bool get _effectiveWidgetsEnabled =>
      widget.widgetsEnabledOverride ?? widgetsEnabled;

  Future<void> _openFileManager() async {
    final opened =
        await ref.read(fileManagerServiceProvider).openSystemFileManager();
    if (!opened && mounted) {
      context.push('/directories');
    }
  }

  Future<void> _shareApp() async {
    final shareUrl = _effectiveShareUrl;
    if (shareUrl.isEmpty) return;
    final message = context.l10n.settingsShareMessage(shareUrl);
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: message,
          subject: AppConstants.appName,
        ),
      );
    } catch (_) {}
  }

  Future<void> _openExternalUrl(String rawUrl) async {
    if (rawUrl.isEmpty) return;
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) return;
    if (widget.onExternalUrlLaunch != null) {
      await widget.onExternalUrlLaunch!(uri);
      return;
    }
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _openManageSubscriptions() async {
    final url = Platform.isIOS
        ? AppConstants.iosSubscriptionsUrl
        : AppConstants.androidSubscriptionsUrl;
    await _openExternalUrl(url);
  }

  String _themeModeLabel(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return context.l10n.settingsThemeSystem;
      case ThemeMode.light:
        return context.l10n.settingsThemeLight;
      case ThemeMode.dark:
        return context.l10n.settingsThemeDark;
    }
  }

  Widget _buildSkeleton(DocViewTokens tokens) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        Shimmer(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tokens.hairline),
            ),
            child: const Column(
              children: [
                SkeletonBox(width: double.infinity, height: 40, borderRadius: 12),
                SizedBox(height: 16),
                SkeletonBox(width: double.infinity, height: 40, borderRadius: 12),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Shimmer(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tokens.hairline),
            ),
            child: const Column(
              children: [
                SkeletonBox(width: double.infinity, height: 40, borderRadius: 12),
                SizedBox(height: 16),
                SkeletonBox(width: double.infinity, height: 40, borderRadius: 12),
                SizedBox(height: 16),
                SkeletonBox(width: double.infinity, height: 40, borderRadius: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final settings = ref.watch(settingsProvider);

    final version = (_packageInfo?.version.isNotEmpty ?? false)
        ? _packageInfo!.version
        : '1.0.0';
    final buildNumber = (_packageInfo?.buildNumber.isNotEmpty ?? false)
        ? _packageInfo!.buildNumber
        : '1';

    final isRelease = widget.isReleaseOverride ?? kReleaseMode;
    final showLanguage = LanguageCatalog.shouldShowLanguageSetting(
      isRelease: isRelease,
      shippedCountOverride: widget.shippedLanguageCountOverride,
    );

    final hasShare = _effectiveShareUrl.isNotEmpty;
    final hasTerms = _effectiveTermsUrl.isNotEmpty;
    final hasPrivacy = _effectivePrivacyUrl.isNotEmpty;

    final othersRows = <Widget>[
      if (_effectiveWidgetsEnabled)
        SettingsRow(
          key: const Key('settings_add_widget'),
          icon: Icons.widgets_outlined,
          title: context.l10n.settingsAddWidgetTitle,
          subtitle: context.l10n.settingsAddWidgetSubtitle,
          onTap: () => AddWidgetBottomSheet.show(context),
        ),
      if (hasTerms)
        SettingsRow(
          key: const Key('settings_terms_of_use'),
          icon: Icons.article_outlined,
          title: context.l10n.settingsTermsTitle,
          subtitle: context.l10n.settingsTermsSubtitle,
          onTap: () => _openExternalUrl(_effectiveTermsUrl),
        ),
      if (hasPrivacy)
        SettingsRow(
          key: const Key('settings_privacy_policy'),
          icon: Icons.shield_outlined,
          title: context.l10n.settingsPrivacyTitle,
          subtitle: context.l10n.settingsPrivacySubtitle,
          onTap: () => _openExternalUrl(_effectivePrivacyUrl),
        ),
      if (_effectivePremiumEnabled)
        SettingsRow(
          key: const Key('settings_manage_subscriptions'),
          icon: Icons.subscriptions_outlined,
          title: context.l10n.settingsManageSubscriptionsTitle,
          subtitle: context.l10n.settingsManageSubscriptionsSubtitle,
          onTap: _openManageSubscriptions,
        ),
      if (widget.showAdChoicesOverride ??
          (ref.watch(isPrivacyOptionsRequiredProvider).asData?.value ?? false))
        SettingsRow(
          key: const Key('settings_ad_choices'),
          icon: Icons.ads_click_outlined,
          title: context.l10n.settingsAdChoicesTitle,
          subtitle: context.l10n.settingsAdChoicesSubtitle,
          onTap: () async {
            await ref.read(consentGatewayProvider).showPrivacyOptionsForm();
            ref.invalidate(isPrivacyOptionsRequiredProvider);
          },
        ),
    ];

    return DocScaffold(
      applyHeaderGradient: true,
      showDockedBanner: true,
      isAdLoaded: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                context.l10n.settingsTitle,
                style: DocViewTypography.headlineLg.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: tokens.hairline,
            ),
            // Body
            Expanded(
              child: widget.isLoading
                  ? _buildSkeleton(tokens)
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      children: [
                        // 1. TOP GROUP: File manager, FAQ, Share
                        SettingsGroupCard(
                          children: [
                            SettingsRow(
                              key: const Key('settings_file_manager'),
                              icon: Icons.folder_open_rounded,
                              title: context.l10n.settingsFileManagerTitle,
                              subtitle: context.l10n.settingsFileManagerSubtitle,
                              onTap: _openFileManager,
                            ),
                            SettingsRow(
                              key: const Key('settings_faq'),
                              icon: Icons.help_outline_rounded,
                              title: context.l10n.settingsFaqTitle,
                              subtitle: context.l10n.settingsFaqSubtitle,
                              onTap: () => context.push('/faq'),
                            ),
                            if (hasShare)
                              SettingsRow(
                                key: const Key('settings_share_app'),
                                icon: Icons.share_outlined,
                                title: context.l10n.settingsShareTitle,
                                subtitle: context.l10n.settingsShareSubtitle,
                                onTap: _shareApp,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 2. SECTION: GENERAL
                        SettingsSectionHeader(
                          title: context.l10n.settingsSectionGeneral,
                        ),
                        SettingsGroupCard(
                          children: [
                            SettingsRow(
                              key: const Key('settings_scan_settings'),
                              icon: Icons.filter_center_focus_rounded,
                              title: context.l10n.settingsScanSettingsTitle,
                              subtitle:
                                  settings.autoScanMode == AutoScanMode.onOpen
                                      ? context.l10n.settingsScanModeOnOpen
                                      : context.l10n.settingsScanModeManual,
                              onTap: () =>
                                  context.push('/settings/scan-settings'),
                            ),
                            SettingsRow(
                              key: const Key('settings_app_theme'),
                              icon: Icons.wb_sunny_outlined,
                              title: context.l10n.settingsAppThemeTitle,
                              subtitle:
                                  _themeModeLabel(context, settings.themeMode),
                              onTap: () => ThemeSelectionSheet.show(context),
                            ),
                            if (showLanguage)
                              SettingsRow(
                                key: const Key('settings_language'),
                                icon: Icons.language_rounded,
                                title: context.l10n.settingsLanguageTitle,
                                subtitle: LanguageCatalog.displayNameForCode(
                                  context,
                                  settings.localeCode,
                                ),
                                onTap: () => context.push('/settings/language'),
                              ),
                            if (_effectiveWidgetsEnabled)
                              SettingsRow(
                                key: const Key('settings_quick_access_notification'),
                                icon: Icons.notifications_active_outlined,
                                title: context.l10n.settingsQuickAccessNotificationTitle,
                                subtitle: context.l10n.settingsQuickAccessNotificationSubtitle,
                                trailing: Semantics(
                                  label: context.l10n.settingsQuickAccessNotificationTitle,
                                  child: Switch.adaptive(
                                    key: const Key('settings_quick_access_notification_switch'),
                                    value: _isQuickAccessNotificationEnabled,
                                    onChanged: _toggleQuickAccessNotification,
                                  ),
                                ),
                                onTap: () => _toggleQuickAccessNotification(!_isQuickAccessNotificationEnabled),
                              ),
                            SettingsRow(
                              key: const Key('settings_rate_us'),
                              icon: Icons.star_outline_rounded,
                              title: context.l10n.settingsRateUsTitle,
                              subtitle: context.l10n.settingsRateUsSubtitle,
                              onTap: () => RateUsSheet.show(
                                context,
                                storeRateUrlOverride:
                                    widget.storeRateUrlOverride,
                              ),
                            ),
                          ],
                        ),

                        // 3. SECTION: OTHERS (only rendered when at least one row is visible)
                        if (othersRows.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SettingsSectionHeader(
                            title: context.l10n.settingsSectionOthers,
                          ),
                          SettingsGroupCard(children: othersRows),
                        ],

                        // 4. CENTERED FOOTER: Version
                        SettingsFooter(
                          version: version,
                          buildNumber: buildNumber,
                          onVersionLongPress: kDebugMode
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const ComponentGalleryScreen(),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
