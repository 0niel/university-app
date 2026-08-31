part of 'study_group_page.dart';

class StudyGroupView extends StatelessWidget {
  const StudyGroupView({super.key});

  StudyGroupCubit _cubit(BuildContext context) => context.read();

  Future<void> _invite(BuildContext context, StudyGroup group) async {
    final friends = context.read<FriendsRepository>();
    final cubit = _cubit(context);
    await showAppSheet<void>(
      context,
      title: context.l10n.studyGroupInviteTitle,
      subtitle: context.l10n.studyGroupInviteSubtitle,
      child: NinjaInviteSheet(
        groupName: group.name,
        joinCode: group.joinCode,
        onSearch: friends.searchUsers,
        onInvite: cubit.inviteByUserId,
      ),
    );
  }

  Future<void> _createGroup(BuildContext context) async {
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
                  name: 'StudyGroupView',
                );
                if (context.mounted) {
                  showNinjaToast(
                    context,
                    showCheck: false,
                    message: l10n.studyGroupCreateError,
                  );
                }
                return false;
              }
            },
      ),
    );
    if ((created ?? false) && context.mounted) await _cubit(context).load();
  }

  Future<void> _removeMember(
    BuildContext context,
    StudyGroupMember member,
  ) async {
    final l10n = context.l10n;
    final cubit = _cubit(context);
    final confirmed = await _confirm(
      context,
      title: l10n.studyGroupRemoveMemberTitle,
      body: l10n.studyGroupRemoveMemberBody(member.fullName),
      confirmLabel: l10n.studyGroupRemove,
      destructive: true,
    );
    if (!confirmed) return;
    final ok = await cubit.removeMember(member.userId);
    if (!ok && context.mounted) {
      showNinjaToast(
        context,
        showCheck: false,
        message: l10n.studyGroupGenericError,
      );
    }
  }

  Future<void> _respondRequest(
    BuildContext context,
    StudyGroupJoinRequest request, {
    required bool accept,
  }) async {
    final cubit = _cubit(context);
    final ok = await cubit.respondJoinRequest(
      inviteId: request.id,
      accept: accept,
    );
    if (!ok && context.mounted) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.studyGroupGenericError,
      );
    }
  }

  Future<void> _leaveOrDelete(
    BuildContext context, {
    required bool isOwner,
  }) async {
    final l10n = context.l10n;
    final cubit = _cubit(context);
    final confirmed = await _confirm(
      context,
      title: isOwner ? l10n.studyGroupDeleteTitle : l10n.studyGroupLeaveTitle,
      body: isOwner ? l10n.studyGroupDeleteBody : l10n.studyGroupLeaveBody,
      confirmLabel: isOwner ? l10n.studyGroupDelete : l10n.studyGroupLeave,
      destructive: true,
    );
    if (!confirmed) return;
    final ok = isOwner ? await cubit.deleteGroup() : await cubit.leave();
    if (ok) {
      if (context.mounted) Navigator.of(context).pop();
    } else if (context.mounted) {
      showNinjaToast(
        context,
        showCheck: false,
        message: l10n.studyGroupGenericError,
      );
    }
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    bool destructive = false,
  }) {
    return showNinjaConfirmDialog(
      context,
      title: title,
      message: body,
      confirmLabel: confirmLabel,
      cancelLabel: context.l10n.studyGroupCancel,
      destructive: destructive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<StudyGroupCubit, StudyGroupState>(
          builder: (context, state) {
            return Column(
              children: [
                CommunityPageHeader(title: l10n.studyGroupTitle),
                Expanded(
                  child: NinjaStateSwitcher(child: _body(context, state)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body(BuildContext context, StudyGroupState state) {
    final colors = context.ninja;
    final group = state.group;
    if (group == null) {
      final l10n = context.l10n;
      if (state.isBusy) {
        return const NinjaStudyGroupSkeleton(key: ValueKey('loading'));
      }
      if (state.status == .failure) {
        return _Placeholder(
          key: const ValueKey('error'),
          child: NinjaErrorState(
            title: l10n.loadingError,
            message: l10n.tryAgain,
            retryLabel: l10n.retry,
            onRetry: () => unawaited(_cubit(context).load()),
          ),
        );
      }
      return _Placeholder(
        key: const ValueKey('empty'),
        child: NinjaEmptyState.screen(
          icon: AppLineIconWidget(
            AppLineIcon.people,
            size: 42,
            color: colors.muted,
          ),
          title: l10n.studyGroupNoGroupTitle,
          message: l10n.studyGroupNoGroupSubtitle,
          actionLabel: l10n.studyGroupCreateCta,
          onAction: () => unawaited(_createGroup(context)),
        ),
      );
    }
    return RefreshIndicator(
      key: const ValueKey('content'),
      color: colors.brand,
      backgroundColor: colors.surface,
      onRefresh: () => _cubit(context).load(),
      child: NinjaStudyGroupContent(
        state: state,
        group: group,
        onInvite: () => _invite(context, group),
        onRemoveMember: (member) => _removeMember(context, member),
        onAcceptRequest: (request) =>
            _respondRequest(context, request, accept: true),
        onDeclineRequest: (request) =>
            _respondRequest(context, request, accept: false),
        onLeaveOrDelete: () => _leaveOrDelete(context, isOwner: state.isOwner),
      ),
    );
  }
}
