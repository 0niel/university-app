import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/view/free_rooms_view.dart';

class FreeRoomsPage extends StatelessWidget {
  const FreeRoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = FreeRoomsCubit(campusRepository: context.read());
        unawaited(cubit.load());
        return cubit;
      },
      child: const FreeRoomsView(),
    );
  }
}
