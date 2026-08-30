import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/nfc_pass/nfc_pass.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/watch/bloc/bloc.dart';

class WatchConnectivityWrapper extends StatefulWidget {
  const WatchConnectivityWrapper({required this.child, super.key});

  final Widget child;

  @override
  State<WatchConnectivityWrapper> createState() =>
      _WatchConnectivityWrapperState();
}

class _WatchConnectivityWrapperState extends State<WatchConnectivityWrapper> {
  @override
  void initState() {
    super.initState();
    context.read<WatchConnectivityCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NfcPassCubit, NfcPassState>(
          listenWhen: (previous, current) => previous.passId != current.passId,
          listener: _handlePassIdChange,
        ),
        BlocListener<ScheduleBloc, ScheduleState>(
          listenWhen: (previous, current) =>
              previous.selectedSchedule != current.selectedSchedule,
          listener: _handleScheduleChange,
        ),
        BlocListener<WatchConnectivityCubit, WatchConnectivityState>(
          listenWhen: (previous, current) =>
              previous.lastMessage != current.lastMessage,
          listener: _handleWatchMessage,
        ),
      ],
      child: widget.child,
    );
  }

  void _handlePassIdChange(BuildContext context, NfcPassState state) {
    final passId = state.passId?.toString() ?? '';
    unawaited(context.read<WatchConnectivityCubit>().sendPassId(passId));
  }

  void _handleScheduleChange(BuildContext context, ScheduleState state) {
    final selectedSchedule = state.selectedSchedule;
    if (selectedSchedule == null || selectedSchedule.schedule.isEmpty) return;

    unawaited(
      context.read<WatchConnectivityCubit>().sendSchedule(
        selectedSchedule.name,
        selectedSchedule.schedule,
      ),
    );
  }

  void _handleWatchMessage(BuildContext context, WatchConnectivityState state) {
    final message = state.lastMessage;
    if (message == null) return;

    switch (message.action) {
      case .requestPassId:
        final passId =
            context.read<NfcPassCubit>().state.passId?.toString() ?? '';
        unawaited(context.read<WatchConnectivityCubit>().sendPassId(passId));
      case .requestSchedule:
        _syncScheduleToWatch(context);
      case .openPhoneAppForBinding || .unknown:
        break;
    }
  }

  void _syncScheduleToWatch(BuildContext context) {
    final scheduleState = context.read<ScheduleBloc>().state;
    final selectedSchedule = scheduleState.selectedSchedule;

    if (selectedSchedule == null || selectedSchedule.schedule.isEmpty) return;

    unawaited(
      context.read<WatchConnectivityCubit>().sendSchedule(
        selectedSchedule.name,
        selectedSchedule.schedule,
      ),
    );
  }
}
