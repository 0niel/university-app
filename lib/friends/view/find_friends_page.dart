import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/find_friends_cubit.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_view.dart';

class FindFriendsPage extends StatelessWidget {
  const FindFriendsPage({
    this.initialQuery = '',
    this.initialUserId,
    super.key,
  });

  final String initialQuery;
  final String? initialUserId;

  static Route<void> route({String initialQuery = '', String? initialUserId}) {
    return MaterialPageRoute<void>(
      builder: (_) => FindFriendsPage(
        initialQuery: initialQuery,
        initialUserId: initialUserId,
      ),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = FindFriendsCubit(friendsRepository: context.read());
        if (initialQuery.trim().isEmpty) {
          unawaited(cubit.loadInitial());
        } else {
          unawaited(cubit.search(initialQuery));
        }
        return cubit;
      },
      child: FindFriendsView(
        initialQuery: initialQuery,
        initialUserId: initialUserId,
      ),
    );
  }
}
