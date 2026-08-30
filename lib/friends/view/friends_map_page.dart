import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/view/friends_map_view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FriendsMapPage extends StatelessWidget {
  const FriendsMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) {
        final cubit = FriendsMapCubit(
          repository: context.read(),
          preferencesRepository: context.read(),
          geoNotificationTitle: l10n.friendsGeoServiceTitle,
          geoNotificationText: l10n.friendsGeoServiceText,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const FriendsMapView(),
    );
  }
}
