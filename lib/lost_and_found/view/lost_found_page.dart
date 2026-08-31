import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/view/lost_found_view.dart';

class LostFoundPage extends StatelessWidget {
  const LostFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = LostFoundCubit(
          lostFoundRepository: context.read(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const LostFoundView(),
    );
  }
}
