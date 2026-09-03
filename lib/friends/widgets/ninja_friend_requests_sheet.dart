import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/friends_layout.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_circle_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'request_card.dart';

class NinjaFriendRequestsSheet extends StatelessWidget {
  const NinjaFriendRequestsSheet({super.key});

  Future<void> _respond(
    BuildContext context, {
    required String friendshipId,
    required bool accept,
  }) async {
    final succeeded = await context.read<FriendsMapCubit>().respondRequest(
      friendshipId: friendshipId,
      accept: accept,
    );
    if (context.mounted && !succeeded) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<FriendsMapCubit>().state;
    return NinjaStateSwitcher(
      child: state.requests.isEmpty
          ? Center(
              key: const ValueKey('empty'),
              child: AppEmptyState(
                title: l10n.friendsNoRequests,
                subtitle: l10n.friendsNoRequestsSub,
              ).animateEmptyState(),
            )
          : Column(
              key: const ValueKey('requests'),
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                for (final (index, request) in state.requests.indexed)
                  _RequestCard(
                    fullName: request.fullName,
                    group: request.group,
                    busy: state.pendingResponseIds.contains(
                      request.friendshipId,
                    ),
                    onRespond: (accept) => unawaited(
                      _respond(
                        context,
                        friendshipId: request.friendshipId,
                        accept: accept,
                      ),
                    ),
                  ).animateListItem(index: index),
              ],
            ),
    );
  }
}
