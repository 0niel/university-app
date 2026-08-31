import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/find_friends_cubit.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_add_action.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friend_card.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_results_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaFindFriendsResults extends StatelessWidget {
  const NinjaFindFriendsResults({
    required this.state,
    this.selectedUserId,
    super.key,
  });

  final FindFriendsState state;
  final String? selectedUserId;

  Future<void> _sendRequest(BuildContext context, String userId) async {
    final cubit = context.read<FindFriendsCubit>();
    final sent = await cubit.sendRequest(userId);
    if (context.mounted && !sent) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _content(context));
  }

  Widget _content(BuildContext context) {
    if (state.searching) {
      return const NinjaFindFriendsResultsSkeleton(key: ValueKey('searching'));
    }
    if (state.results.isEmpty) {
      return Padding(
        key: const ValueKey('empty'),
        padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
        child: NinjaEmptyState(
          icon: const AppLineIconWidget(AppLineIcon.search),
          title: context.l10n.friendsNoneFound,
          message: context.l10n.friendsNoneFoundSub,
        ).animateEmptyState(),
      );
    }
    final selected = selectedUserId;
    final results = selected == null
        ? state.results
        : [
            ...state.results.where((user) => user.userId == selected),
            ...state.results.where((user) => user.userId != selected),
          ];
    return Column(
      key: const ValueKey('results'),
      children: [
        for (final (index, user) in results.indexed)
          NinjaFindFriendCard(
            name: user.fullName,
            subtitle: [
              if (user.handle != null) '@${user.handle}',
              if (user.group != null) user.group ?? '',
            ].join(' · '),
            trailing: FindFriendsAddAction(
              sent: state.isSent(user.userId, user.friendshipStatus),
              isFriend: user.friendshipStatus == 'accepted',
              onAdd: () => unawaited(_sendRequest(context, user.userId)),
            ),
            selected: user.userId == selected,
          ).animateListItem(index: index),
      ],
    );
  }
}
