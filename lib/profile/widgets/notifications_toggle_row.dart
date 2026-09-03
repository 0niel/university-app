import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';

class NotificationsToggleRow extends StatefulWidget {
  const NotificationsToggleRow({required this.label, super.key, this.sub});

  final String label;
  final String? sub;

  @override
  State<NotificationsToggleRow> createState() => _NotificationsToggleRowState();
}

class _NotificationsToggleRowState extends State<NotificationsToggleRow> {
  var _requesting = false;

  @override
  Widget build(BuildContext context) {
    final settings = context.select<ProfileCubit, UserSettings>(
      (cubit) => cubit.state.settings,
    );
    return SettingsToggleRow(
      label: widget.label,
      sub: widget.sub,
      value: settings.notificationsEnabled,
      onChanged: _requesting
          ? null
          : (enabled) => unawaited(_setEnabled(enabled: enabled)),
    );
  }

  Future<void> _setEnabled({
    required bool enabled,
  }) async {
    if (_requesting) return;
    final profileCubit = context.read<ProfileCubit>();
    setState(() => _requesting = true);
    try {
      if (!enabled) {
        await profileCubit.updateSettings(
          profileCubit.state.settings.copyWith(notificationsEnabled: false),
        );
        return;
      }
      final repository = context.read<LocalNotificationsRepository>();
      final isGranted = await repository.ensurePermission();
      if (!mounted || profileCubit.isClosed) return;
      if (isGranted) {
        await profileCubit.updateSettings(
          profileCubit.state.settings.copyWith(notificationsEnabled: true),
        );
      } else {
        showNinjaToast(context, message: context.l10n.error, showCheck: false);
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
