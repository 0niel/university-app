import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/friends/friends.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/cubit/cubit.dart';
import 'package:rtu_mirea_app/people/view/people_view.dart';
import 'package:rtu_mirea_app/study_group/study_group.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  late final PeopleCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PeopleCubit(
      friendsRepository: context.read(),
      studyGroupsRepository: context.read(),
      currentUserId: context.read<AppBloc>().state.user.id,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initialize());
    });
  }

  Future<void> _initialize() async {
    await _cubit.load();
    await _handleAddDeepLink();
    await _handleJoinGroupDeepLink();
    if (mounted && GoRouterState.of(context).uri.hasQuery) {
      context.go('/services/people');
    }
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  Future<void> _handleJoinGroupDeepLink() async {
    final code = GoRouterState.of(context).uri.queryParameters['joinGroup'];
    if (code == null || code.isEmpty) return;
    final joined = await _cubit.joinGroupByCode(code);
    final group = _cubit.state.studyGroup.group;
    if (!mounted) return;
    if (joined && group != null) {
      showNinjaToast(
        context,
        message: context.l10n.studyGroupJoinedToast(group.name),
      );
    } else {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.studyGroupJoinError,
      );
    }
  }

  Future<void> _handleAddDeepLink() async {
    final addUserId = GoRouterState.of(context).uri.queryParameters['add'];
    if (addUserId == null || addUserId.isEmpty) return;
    if (addUserId == context.read<AppBloc>().state.user.id) return;
    final sent = await _cubit.sendFriendRequest(addUserId);
    if (!mounted) return;
    if (sent) {
      showNinjaToast(
        context,
        message: context.l10n.peopleRequestSent,
      );
    } else {
      _showActionError();
    }
  }

  Future<void> _createGroup() async {
    final repository = context.read<StudyGroupsRepository>();
    final l10n = context.l10n;
    final created = await showAppSheet<bool>(
      context,
      title: l10n.studyGroupCreateTitle,
      subtitle: l10n.studyGroupCreateSubtitle,
      child: CreateGroupSheet(
        onCreate:
            ({
              required name,
              required emoji,
              required description,
              required isDiscoverable,
            }) => _createGroupWith(
              repository,
              name: name,
              emoji: emoji,
              description: description,
              isDiscoverable: isDiscoverable,
            ),
      ),
    );
    if (created == true && mounted) await _cubit.load();
  }

  Future<bool> _createGroupWith(
    StudyGroupsRepository repository, {
    required String name,
    required String emoji,
    required String description,
    required bool isDiscoverable,
  }) async {
    try {
      await repository.createGroup(
        name: name,
        emoji: emoji,
        description: description,
        isDiscoverable: isDiscoverable,
      );
      return true;
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to create study group',
        error: error,
        stackTrace: stackTrace,
        name: 'PeoplePage',
      );
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.studyGroupCreateError,
        );
      }
      return false;
    }
  }

  Future<void> _joinByCode() async {
    final repository = context.read<StudyGroupsRepository>();
    final joined = await showAppSheet<bool>(
      context,
      title: context.l10n.studyGroupJoinTitle,
      subtitle: context.l10n.studyGroupJoinSubtitle,
      child: JoinByCodeSheet(
        onJoin: (code) => _joinGroupWith(repository, code),
      ),
    );
    if (joined == true && mounted) await _cubit.load();
  }

  Future<bool> _joinGroupWith(
    StudyGroupsRepository repository,
    String code,
  ) async {
    try {
      await repository.joinByCode(code);
      return true;
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to join study group by code',
        error: error,
        stackTrace: stackTrace,
        name: 'PeoplePage',
      );
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.studyGroupJoinError,
        );
      }
      return false;
    }
  }

  Future<void> _discoverGroups() async {
    await Navigator.of(context).push(DiscoverGroupsPage.route());
    if (mounted) await _cubit.load();
  }

  Future<void> _manageGroup() async {
    await Navigator.of(context).push(StudyGroupPage.route());
    if (mounted) await _cubit.load();
  }

  Future<void> _respondInvite(
    String inviteId, {
    required bool accept,
  }) async {
    final succeeded = await _cubit.respondGroupInvite(
      inviteId: inviteId,
      accept: accept,
    );
    if (!succeeded && mounted) _showActionError();
  }

  Future<void> _respond({
    required String friendshipId,
    required bool accept,
  }) async {
    final succeeded = await _cubit.respondFriendRequest(
      friendshipId: friendshipId,
      accept: accept,
    );
    if (!succeeded && mounted) _showActionError();
  }

  Future<void> _addToFriends(String userId) async {
    final succeeded = await _cubit.sendFriendRequest(userId);
    if (!succeeded && mounted) _showActionError();
  }

  Future<void> _showAddFriend() async {
    await Navigator.of(
      context,
      rootNavigator: true,
    ).push(FindFriendsPage.route());
    if (mounted) await _cubit.load();
  }

  void _showActionError() {
    showNinjaToast(
      context,
      showCheck: false,
      message: context.l10n.peopleActionError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: PeopleView(
        onRefresh: _cubit.load,
        onAdd: _showAddFriend,
        onCreateGroup: _createGroup,
        onJoinByCode: _joinByCode,
        onDiscoverGroups: _discoverGroups,
        onManageGroup: _manageGroup,
        onAddToFriends: _addToFriends,
        onRespondFriendRequest: _respond,
        onRespondGroupInvite: _respondInvite,
      ),
    );
  }
}
