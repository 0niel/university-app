import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/polls/cubit/polls_cubit.dart';
import 'package:rtu_mirea_app/polls/view/polls_view.dart';

class PollsPage extends StatelessWidget {
  const PollsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = PollsCubit(campusRepository: context.read());
        unawaited(cubit.load());
        return cubit;
      },
      child: const PollsView(),
    );
  }
}
