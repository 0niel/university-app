import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';

class UserPreferencesScope extends StatelessWidget {
  const UserPreferencesScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppBloc, AppState, String>(
      selector: (state) => state.user.id,
      builder: (context, userId) => MultiBlocProvider(
        key: ValueKey(userId),
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) {
              final cubit = FriendsMapCubit(
                repository: context.read(),
                preferencesRepository: context.read(),
              );
              if (context.read<AppBloc>().state.status.isLoggedIn) {
                unawaited(cubit.initialize());
              }
              return cubit;
            },
          ),
          BlocProvider(create: (_) => NotificationsCubit(userId: userId)),
          BlocProvider(
            create: (context) {
              final cubit = GeoSharingCubit(
                preferencesRepository: context.read(),
                friendsRepository: context.read(),
                mapCubit: context.read(),
              );
              unawaited(cubit.load());
              return cubit;
            },
          ),
        ],
        child: child,
      ),
    );
  }
}
