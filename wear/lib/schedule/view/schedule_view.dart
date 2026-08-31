import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wear/ambient_mode/ambient_mode.dart';
import 'package:wear/schedule/schedule.dart';
import 'package:wear/schedule/view/schedule_content.dart';
import 'package:wear/schedule/view/schedule_empty_view.dart';
import 'package:wear/schedule/view/schedule_error_view.dart';
import 'package:wear/schedule/view/schedule_loading_view.dart';
import 'package:wear/schedule/view/schedule_not_paired_view.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  StreamSubscription<RotaryEvent>? _rotarySubscription;

  @override
  void initState() {
    super.initState();
    _setupRotary();
  }

  void _setupRotary() {
    final scheduleCubit = context.read<ScheduleCubit>();
    _rotarySubscription = rotaryEvents.listen((event) {
      if (!mounted) return;
      if (event.direction == RotaryDirection.clockwise) {
        scheduleCubit.nextDay();
      } else {
        scheduleCubit.previousDay();
      }
    });
  }

  @override
  void dispose() {
    unawaited(_rotarySubscription?.cancel() ?? Future.value());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AmbientModeBuilder(
      builder: (context, isAmbient, child) {
        final colors = Theme.of(context).colors;
        return Scaffold(
          backgroundColor: colors.background01,
          body: BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              if (state.status == ScheduleStatus.loading) {
                return ScheduleLoadingView(
                  isAmbient: isAmbient,
                  isPaired: state.isPaired,
                  isReachable: state.isReachable,
                );
              }

              if (state.status == ScheduleStatus.error) {
                return ScheduleErrorView(isAmbient: isAmbient);
              }

              if (!state.isPaired) {
                return ScheduleNotPairedView(isAmbient: isAmbient);
              }

              if (state.scheduleParts == null || state.scheduleParts!.isEmpty) {
                return ScheduleEmptyView(isAmbient: isAmbient);
              }

              return ScheduleContent(
                isAmbient: isAmbient,
                scheduleName: state.scheduleName ?? 'Schedule',
                lessons: state.lessonsForCurrentDay,
                currentDayIndex: state.currentDayIndex,
                availableDays: state.availableDays,
              );
            },
          ),
        );
      },
    );
  }
}
