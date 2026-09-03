import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:permission_client/permission_client.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/widgets.dart';
import 'package:rtu_mirea_app/onboarding/widgets/setting_toggle_row.dart';
import 'package:rtu_mirea_app/onboarding/widgets/theme_card.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';

class OnboardingSettingsStep extends StatefulWidget {
  const OnboardingSettingsStep({
    required this.step,
    required this.totalSteps,
    required this.permissionClient,
    required this.onBack,
    required this.onFinish,
    super.key,
    this.finishing = false,
  });
  final int step;
  final int totalSteps;
  final PermissionClient permissionClient;
  final VoidCallback onBack;
  final VoidCallback onFinish;
  final bool finishing;

  @override
  State<OnboardingSettingsStep> createState() => _OnboardingSettingsStepState();
}

class _OnboardingSettingsStepState extends State<OnboardingSettingsStep>
    with WidgetsBindingObserver {
  var _push = false;
  var _geo = false;
  var _busy = false;
  var _settingsLoading = true;
  var _settingsFailed = false;
  var _request = 0;
  UserSettings? _settings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_loadSettings());
    final sharing = context.read<GeoSharingCubit>();
    if (!sharing.state.loaded && !sharing.state.busy) unawaited(sharing.load());
  }

  @override
  void dispose() {
    _request++;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_busy) {
      unawaited(_loadPermissions());
    }
  }

  Future<void> _loadPermissions() async {
    final request = ++_request;
    try {
      final push =
          !kIsWeb &&
          await context.read<LocalNotificationsRepository>().hasPermission();
      final geo = await widget.permissionClient.locationWhenInUseStatus();
      if (!mounted || request != _request) return;
      setState(() {
        _push = push && (_settings?.notificationsEnabled ?? false);
        _geo = geo.isGranted;
      });
    } on Exception catch (error, stackTrace) {
      log(
        'Permission status load failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingSettingsStep',
      );
      if (mounted) setState(() => _settingsFailed = true);
    }
  }

  Future<void> _loadSettings() async {
    setState(() {
      _settingsLoading = true;
      _settingsFailed = false;
    });
    try {
      final settings = await context
          .read<GamificationRepository>()
          .getSettings();
      if (!mounted) return;
      _settings = settings;
      await _loadPermissions();
    } on Exception catch (error, stackTrace) {
      log(
        'Settings load failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingSettingsStep',
      );
      if (mounted) setState(() => _settingsFailed = true);
    } finally {
      if (mounted) setState(() => _settingsLoading = false);
    }
  }

  Future<void> _togglePush(bool value) async {
    final previous = _settings;
    if (_busy || _settingsLoading || previous == null || kIsWeb) return;
    _request++;
    setState(() => _busy = true);
    try {
      final granted =
          !value ||
          await context.read<LocalNotificationsRepository>().ensurePermission();
      if (!mounted) return;
      if (!granted) {
        ToastManager.showWarning(
          context,
          message: context.l10n.onboardingPushDenied,
        );
        return;
      }
      final saved = await context.read<GamificationRepository>().updateSettings(
        previous.copyWith(notificationsEnabled: value),
        previous: previous,
      );
      if (!mounted) return;
      setState(() {
        _settings = saved;
        _push = saved.notificationsEnabled && value;
      });
    } on Exception catch (error, stackTrace) {
      log(
        'Notification settings save failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingSettingsStep',
      );
      if (mounted) {
        ToastManager.showError(
          context,
          message: context.l10n.onboardingSettingsSaveError,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleGeo(bool value) async {
    if (_busy) return;
    _request++;
    setState(() => _busy = true);
    try {
      if (!value) {
        ToastManager.showInfo(
          context,
          message: context.l10n.onboardingGeoSystemSettings,
        );
        await widget.permissionClient.openPermissionSettings();
      } else {
        final status = await widget.permissionClient.requestLocationWhenInUse();
        if (!mounted) return;
        setState(() => _geo = status.isGranted);
        if (!status.isGranted) {
          ToastManager.showWarning(
            context,
            message: context.l10n.onboardingGeoDenied,
          );
        }
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Location permission request failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnboardingSettingsStep',
      );
      if (mounted) {
        ToastManager.showError(
          context,
          message: context.l10n.onboardingGeoDenied,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleFriends(bool value) async {
    final cubit = context.read<GeoSharingCubit>();
    if (_busy || !cubit.state.loaded || cubit.state.busy) return;
    setState(() => _busy = true);
    try {
      final saved = await cubit.setSharing(enabled: value);
      if (!saved && mounted) {
        ToastManager.showError(
          context,
          message: context.l10n.onboardingSettingsSaveError,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sharing = context.watch<GeoSharingCubit>().state;
    final busy = _busy || _settingsLoading || sharing.busy || widget.finishing;
    return AuthPageLayout(
      step: widget.step,
      totalSteps: widget.totalSteps,
      title: l10n.onboardingSettingsTitle,
      subtitle: l10n.onboardingSettingsLead,
      onBack: widget.onBack,
      actions: AppButton.primary(
        key: const Key('onboarding_finish'),
        label: l10n.done,
        size: AppButtonSize.hero,
        expanded: true,
        loading: widget.finishing,
        onPressed: busy ? null : widget.onFinish,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_settingsFailed || (!sharing.loaded && sharing.failed)) ...[
            AppBanner(
              message: l10n.onboardingSettingsSaveError,
              tone: AppBannerTone.warn,
              actionLabel: l10n.retry,
              onAction: busy
                  ? null
                  : () {
                      unawaited(_loadSettings());
                      if (!sharing.loaded) {
                        unawaited(context.read<GeoSharingCubit>().load());
                      }
                    },
            ),
            const SizedBox(height: 12),
          ],
          AppListGroup(
            children: [
              SettingToggleRow(
                key: const Key('onboarding_togglePush'),
                title: l10n.notifications,
                subtitle: l10n.onboardingPushSub,
                value: _push,
                onChanged: busy || _settings == null || kIsWeb
                    ? null
                    : (value) => unawaited(_togglePush(value)),
              ),
              SettingToggleRow(
                key: const Key('onboarding_toggleGeo'),
                title: l10n.onboardingGeoTitle,
                subtitle: l10n.onboardingGeoSub,
                value: _geo,
                onChanged: busy
                    ? null
                    : (value) => unawaited(_toggleGeo(value)),
              ),
              SettingToggleRow(
                key: const Key('onboarding_toggleFriends'),
                title: l10n.onboardingFriendsTitle,
                subtitle: l10n.onboardingFriendsSharingSub,
                value: sharing.sharing,
                onChanged: busy || !sharing.loaded
                    ? null
                    : (value) => unawaited(_toggleFriends(value)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const OnboardingThemeCard(),
        ],
      ),
    );
  }
}
