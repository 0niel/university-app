import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/cowork/cubit/cowork_cubit.dart';
import 'package:rtu_mirea_app/cowork/data/cowork_repository.dart';
import 'package:rtu_mirea_app/cowork/view/cowork_view.dart';

class CoworkPage extends StatelessWidget {
  const CoworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CoworkCubit(
          repository: const LocalCoworkRepository(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const CoworkView(),
    );
  }
}
