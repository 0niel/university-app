import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/view/friends_map_view.dart';

class FriendsMapPage extends StatelessWidget {
  const FriendsMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = FriendsMapCubit(
          repository: context.read(),
          preferencesRepository: context.read(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const FriendsMapView(),
    );
  }
}
