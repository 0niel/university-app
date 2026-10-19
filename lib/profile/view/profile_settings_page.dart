import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/common/utils/app_cache.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/nfc_pass_availability.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/view/notifications_settings_page.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

const kGithubUrl = 'https://github.com/0niel/university-app';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final AppCache _cache = const AppCache();
  String? _cacheLabel;
  String? _version;
  String? _buildNumber;
  var _clearingCache = false;
  var _showAdvanced = false;

  @override
  void initState() {
    super.initState();
    if (NfcPassAvailability.isSupported) {
      unawaited(context.read<PassSecurityCubit>().refreshCapability());
      unawaited(context.read<NfcHceCubit>().refresh());
    }
    unawaited(_loadCacheSize());
    unawaited(_loadVersion());
  }

  Future<void> _loadCacheSize() async {
    try {
      final bytes = await _cache.estimateBytes();
      if (!mounted) return;
      setState(() => _cacheLabel = filesize(bytes));
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to estimate cache size',
        error: error,
        stackTrace: stackTrace,
        name: 'ProfileSettingsPage',
      );
    }
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to read package version',
        error: error,
        stackTrace: stackTrace,
        name: 'ProfileSettingsPage',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: AppAmbientBackground(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: _buildBody,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    final l10n = context.l10n;
    final settings = state.settings;
    final academic = state.overview.academic;
    final cold =
        state.status == ProfileStatus.loading &&
        state.gamificationProfile.isEmpty;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: AppInnerHeader(
            title: l10n.settingsTitle,
            backSemanticsLabel: l10n.back,
            onBack: () => Navigator.of(context).maybePop(),
          ),
        ),
        if (cold)
          const SliverToBoxAdapter(child: SettingsSkeleton.settings())
        else
          SliverList.list(
            children: [
              if (state.hasFailed(.settings))
                SettingsFailureCard(
                  onRetry: () => unawaited(
                    context.read<ProfileCubit>().reloadSection(.settings),
                  ),
                ),
              SettingsSection(
                label: l10n.settingsAppearance,
                topPadding: 28,
                children: const [SettingsAppearance()],
              ),
              SettingsScheduleSection(group: academic.group),
              SettingsNotificationsSection(
                enabled: settings.notificationsEnabled,
                onTap: () => _openNotifications(context),
              ),
              SettingsPrivacySection(
                settings: settings,
                onChanged: (next) => _updateSettings(context, next),
              ),
              const SettingsAccountSection(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.section,
                  AppSpacing.screen,
                  0,
                ),
                child: SettingsCard(
                  children: [
                    SettingsRow(
                      title: l10n.settingsAdvanced,
                      trailing: AppLineIconWidget(
                        _showAdvanced
                            ? AppLineIcon.chevronU
                            : AppLineIcon.chevronD,
                      ),
                      showChevron: false,
                      onTap: () =>
                          setState(() => _showAdvanced = !_showAdvanced),
                    ),
                  ],
                ),
              ),
              if (_showAdvanced) ...[
                const SettingsHomeSection(),
                const SizedBox(height: AppSpacing.screen),
                SupportBanner(onTap: () => unawaited(_openGithub())),
                SettingsDataSection(
                  cacheLabel: _cacheLabel,
                  onClearCache: _clearingCache
                      ? null
                      : () => unawaited(_clearCache()),
                ),
                SettingsAboutSection(
                  version: _version,
                  onOpenRepository: () => unawaited(_openGithub()),
                ),
              ],
              if (_version != null && _buildNumber != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.sheetBottom,
                    AppSpacing.screen,
                    0,
                  ),
                  child: Text(
                    l10n.settingsVersionBuild(_version!, _buildNumber!),
                    textAlign: TextAlign.center,
                    style: AppText.caption.copyWith(
                      color: context.colors.muted2,
                    ),
                  ),
                ),
              SizedBox(
                key: const ValueKey('settings-bottom-inset'),
                height: ninjaBottomInset(context) + AppSpacing.lg,
              ),
            ],
          ),
      ],
    ).animatePageEntrance();
  }

  void _updateSettings(BuildContext context, UserSettings next) {
    unawaited(context.read<ProfileCubit>().updateSettings(next));
  }

  void _openNotifications(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: profileCubit,
            child: const NotificationsSettingsPage(),
          ),
        ),
      ),
    );
  }

  Future<void> _clearCache() async {
    setState(() => _clearingCache = true);
    final l10n = context.l10n;
    try {
      await _cache.clear();
      await _loadCacheSize();
      if (!mounted) return;
      showNinjaToast(context, message: l10n.settingsCacheCleared);
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to clear cache',
        error: error,
        stackTrace: stackTrace,
        name: 'ProfileSettingsPage',
      );
      if (mounted) {
        showNinjaToast(context, message: l10n.error, showCheck: false);
      }
    } finally {
      if (mounted) setState(() => _clearingCache = false);
    }
  }

  Future<void> _openGithub() async {
    final uri = Uri.parse(kGithubUrl);
    try {
      final opened = await launchUrl(uri, mode: .externalApplication);
      if (!opened && mounted) {
        showNinjaToast(context, message: context.l10n.error, showCheck: false);
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to open GitHub',
        error: error,
        stackTrace: stackTrace,
        name: 'ProfileSettingsPage',
      );
    }
  }
}
