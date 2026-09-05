import 'dart:async';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:rtu_mirea_app/app/view/app_device_token_sync.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/notification_permission.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';

class NotificationsToggleRow extends StatefulWidget {
  const NotificationsToggleRow({required this.label, super.key, this.sub});

  final String label;
  final String? sub;

  @override
  State<NotificationsToggleRow> createState() => _NotificationsToggleRowState();
}

class _NotificationsToggleRowState extends State<NotificationsToggleRow>
    with WidgetsBindingObserver {
  var _requesting = false;
  bool? _permissionGranted;
  var _permissionRead = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refreshPermission());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permissionRead++;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_requesting) {
      unawaited(_refreshPermission());
    }
  }

  Future<void> _refreshPermission() async {
    final request = ++_permissionRead;
    try {
      final granted = await hasNotificationPermission(
        context.read<LocalNotificationsRepository>(),
      );
      if (!mounted || request != _permissionRead) return;
      setState(() => _permissionGranted = granted);
    } on Exception catch (error, stackTrace) {
      log(
        'Notification permission lookup failed',
        error: error,
        stackTrace: stackTrace,
        name: 'NotificationsToggleRow',
      );
      if (mounted && request == _permissionRead) {
        setState(() => _permissionGranted = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.select<ProfileCubit, UserSettings>(
      (cubit) => cubit.state.settings,
    );
    final toggle = SettingsToggleRow(
      label: widget.label,
      sub: widget.sub,
      value: settings.notificationsEnabled && _permissionGranted == true,
      onChanged: _requesting || _permissionGranted == null
          ? null
          : (enabled) => unawaited(_setEnabled(enabled: enabled)),
    );
    if (_permissionGranted != false ||
        kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return toggle;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        toggle,
        SettingsRow(
          title: context.l10n.onboardingPushDenied,
          onTap: () => unawaited(_openSettings()),
        ),
      ],
    );
  }

  Future<void> _openSettings() async {
    try {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    } on Exception catch (error, stackTrace) {
      log(
        'Notification settings could not be opened',
        error: error,
        stackTrace: stackTrace,
        name: 'NotificationsToggleRow',
      );
      if (mounted) {
        showNinjaToast(
          context,
          message: context.l10n.onboardingPushDenied,
          showCheck: false,
        );
      }
    }
  }

  Future<void> _setEnabled({
    required bool enabled,
  }) async {
    if (_requesting) return;
    final profileCubit = context.read<ProfileCubit>();
    _permissionRead++;
    setState(() => _requesting = true);
    try {
      if (!enabled) {
        await profileCubit.updateSettings(
          profileCubit.state.settings.copyWith(notificationsEnabled: false),
        );
        return;
      }
      final repository = context.read<LocalNotificationsRepository>();
      final isGranted = await requestNotificationPermission(repository);
      if (!mounted || profileCubit.isClosed) return;
      setState(() => _permissionGranted = isGranted);
      if (isGranted) {
        unawaited(AppDeviceTokenSync.refresh(context));
        await profileCubit.updateSettings(
          profileCubit.state.settings.copyWith(notificationsEnabled: true),
        );
      } else {
        showNinjaToast(
          context,
          message: context.l10n.onboardingPushDenied,
          showCheck: false,
        );
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to request notification permission',
        error: error,
        stackTrace: stackTrace,
        name: 'NotificationsToggleRow',
      );
      if (mounted) {
        showNinjaToast(context, message: context.l10n.error, showCheck: false);
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }
}
