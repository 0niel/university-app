import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines_cubit.dart';
import 'package:rtu_mirea_app/community/view/deadlines_view.dart';

class DeadlinesPage extends StatelessWidget {
  const DeadlinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = DeadlinesCubit(repository: context.read());
        unawaited(cubit.load());
        return cubit;
      },
      child: const DeadlinesView(),
    );
  }
}
