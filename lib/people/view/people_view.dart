import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/cubit/cubit.dart';
import 'package:rtu_mirea_app/people/widgets/widgets.dart';
import 'package:rtu_mirea_app/search/widgets/global_search_button.dart';

class PeopleView extends StatelessWidget {
  const PeopleView({
    required this.onRefresh,
    required this.onAdd,
    required this.onCreateGroup,
    required this.onJoinByCode,
    required this.onDiscoverGroups,
    required this.onManageGroup,
    required this.onAddToFriends,
    required this.onRespondFriendRequest,
    required this.onRespondGroupInvite,
    super.key,
  });

  final Future<bool> Function() onRefresh;
  final Future<void> Function() onAdd;
  final Future<void> Function() onCreateGroup;
  final Future<void> Function() onJoinByCode;
  final Future<void> Function() onDiscoverGroups;
  final Future<void> Function() onManageGroup;
  final Future<void> Function(String userId) onAddToFriends;
  final Future<void> Function({
    required String friendshipId,
    required bool accept,
  })
  onRespondFriendRequest;
  final Future<void> Function(String inviteId, {required bool accept})
  onRespondGroupInvite;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PeopleCubit, PeopleState>(
      listenWhen: (previous, current) =>
          !setEquals(previous.failedSources, current.failedSources) &&
          current.failedSources.isNotEmpty,
      listener: (context, _) => showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.peoplePartialLoadError,
      ),
      builder: (context, state) => Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          top: false,
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: NinjaPeopleHeader(
                  title: context.l10n.peopleTitle,
                  search: const GlobalSearchButton(),
                  addLabel: context.l10n.friendsAddFriend,
                  onAdd: () => unawaited(onAdd()),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const .symmetric(
                    horizontal: AppSpacing.screen,
                    vertical: 8,
                  ),
                  child: NinjaTabs<PeopleTab>(
                    value: state.tab,
                    onChanged: context.read<PeopleCubit>().tabChanged,
                    padding: EdgeInsets.zero,
                    spacing: 18,
                    tabs: [
                      NinjaTab(
                        value: .friends,
                        label: context.l10n.peopleTabFriends(
                          state.friends.length,
                        ),
                      ),
                      NinjaTab(
                        value: .group,
                        label: context.l10n.peopleTabGroup(
                          state.studyGroup.members.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: RefreshIndicator(
              color: context.colors.ink,
              onRefresh: onRefresh,
              child: NinjaStateSwitcher(
                child: NinjaPeopleBody(
                  key: ValueKey(state.tab),
                  state: state,
                  onRetry: onRefresh,
                  onAdd: onAdd,
                  onCreateGroup: onCreateGroup,
                  onJoinByCode: onJoinByCode,
                  onDiscoverGroups: onDiscoverGroups,
                  onManageGroup: onManageGroup,
                  onAddToFriends: onAddToFriends,
                  onRespondFriendRequest: onRespondFriendRequest,
                  onRespondGroupInvite: onRespondGroupInvite,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
