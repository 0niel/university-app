import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wear/schedule/schedule.dart';
import 'package:wear/schedule/view/schedule_view.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ScheduleCubit();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: const ScheduleView(),
    );
  }
}
