import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_cubit.dart';
import 'package:rtu_mirea_app/people/utils/external_link_launcher.dart';
import 'package:rtu_mirea_app/people/widgets/group_space/group_space_widgets.dart';
import 'package:rtu_mirea_app/study_group/study_group.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

part 'group_post_details.dart';
part 'ninja_group_space_section_header.dart';

class GroupSpaceView extends StatefulWidget {
  const GroupSpaceView({this.initialPostId, super.key});

  final String? initialPostId;

  @override
  State<GroupSpaceView> createState() => _GroupSpaceViewState();
}

class _GroupSpaceViewState extends State<GroupSpaceView> {
  var _handledInitialPost = false;
  final _searchController = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<GroupSpaceCubit, GroupSpaceState>(
        listenWhen: (previous, current) =>
            (previous.mutationFailure != current.mutationFailure &&
                current.mutationFailure != null) ||
            (!_handledInitialPost &&
                widget.initialPostId?.isNotEmpty == true &&
                current.status == .success),
        listener: (context, state) {
          _showMutationFailure(context, state);
          if (!_handledInitialPost &&
              widget.initialPostId?.isNotEmpty == true &&
              state.status == .success) {
            unawaited(_showInitialPost(context, state));
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: context.colors.canvas,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                CommunityPageHeader(
                  title: context.l10n.peopleGroupSpaceTitle,
                  subtitle: switch (state.space.group) {
                    final String group =>
                      context.l10n.groupSpaceHeaderSubtitleGroup(group),
                    null => context.l10n.groupSpaceHeaderSubtitle,
                  },
                ),
                Expanded(child: _body(context, state)),
              ],
            ),
          ),
        ),
      );

  Future<void> _showInitialPost(
    BuildContext context,
    GroupSpaceState state,
  ) async {
    _handledInitialPost = true;
    final postId = widget.initialPostId;
    final announcement = state.space.announcement;
    if (announcement != null && announcement.id == postId) {
      await showAppSheet<void>(
        context,
        title: announcement.title.isEmpty
            ? context.l10n.postDetailTitle
            : announcement.title,
        subtitle: announcement.authorName.isEmpty
            ? null
            : announcement.authorName,
        child: _GroupPostDetails(body: announcement.body),
      );
    } else {
      GroupNote? selected;
      for (final note in state.space.notes) {
        if (note.id == postId) {
          selected = note;
          break;
        }
      }
      if (selected == null) {
        if (context.mounted) {
          showNinjaToast(
            context,
            showCheck: false,
            message: context.l10n.loadingError,
          );
        }
      } else {
        await showAppSheet<void>(
          context,
          title: selected.title.isEmpty
              ? context.l10n.postDetailTitle
              : selected.title,
          subtitle: selected.authorName.isEmpty ? null : selected.authorName,
          child: _GroupPostDetails(body: selected.body),
        );
      }
    }
    if (mounted) this.context.go('/services/people/group-space');
  }

  Widget _body(BuildContext context, GroupSpaceState state) {
    final l10n = context.l10n;
    return NinjaStateSwitcher(
      child: switch (state.status) {
        .initial || .loading => const NinjaGroupSpaceSkeleton(
          key: ValueKey('group-space-loading'),
        ),
        .failure => Padding(
          key: const ValueKey('group-space-error'),
          padding: const .fromLTRB(
            AppSpacing.screen,
            24,
            AppSpacing.screen,
            0,
          ),
          child: NinjaErrorState(
            title: l10n.loadingError,
            message: l10n.tryAgain,
            retryLabel: l10n.retry,
            onRetry: () => unawaited(context.read<GroupSpaceCubit>().load()),
          ),
        ),
        .success when !state.space.hasGroup => Padding(
          key: const ValueKey('group-space-empty'),
          padding: const .fromLTRB(
            AppSpacing.screen,
            24,
            AppSpacing.screen,
            0,
          ),
          child: NinjaEmptyState(
            icon: AppLineIconWidget(
              AppLineIcon.people,
              color: context.colors.muted,
            ),
            title: l10n.noGroupsSelected,
            message: l10n.peopleGroupSpaceSub,
            actionLabel: l10n.peopleTitle,
            onAction: () => context.go('/services/people'),
          ).animateEmptyState(),
        ),
        .success => _content(context, state),
      },
    );
  }

  List<GroupNote> _filteredNotes(GroupSpace space) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return space.notes;
    return space.notes
        .where(
          (note) =>
              note.title.toLowerCase().contains(query) ||
              note.body.toLowerCase().contains(query),
        )
        .toList();
  }

  bool _announcementMatches(GroupAnnouncement? announcement) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty || announcement == null) return announcement != null;
    return announcement.title.toLowerCase().contains(query) ||
        announcement.body.toLowerCase().contains(query);
  }

  Widget _content(BuildContext context, GroupSpaceState state) {
    final space = state.space;
    final l10n = context.l10n;
    final telegram = space.telegram;
    final searching = _query.trim().isNotEmpty;
    final announcement = space.announcement;
    final showAnnouncement = _announcementMatches(announcement);
    final notes = _filteredNotes(space);
    final noResults = searching && !showAnnouncement && notes.isEmpty;
    return RefreshIndicator(
      key: const ValueKey('group-space-content'),
      onRefresh: context.read<GroupSpaceCubit>().load,
      color: context.colors.ink,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 12),
                NinjaGroupSpaceHero(
                  space: space,
                  onlineCount: state.onlineCount,
                  onInvite: () => unawaited(_invite(context, space)),
                ),
                const SizedBox(height: 16),
                GroupSpaceQuickActions(actions: _quickActions(context, space)),
                Padding(
                  padding: const .fromLTRB(
                    AppSpacing.screen,
                    20,
                    AppSpacing.screen,
                    0,
                  ),
                  child: AppSearchField(
                    controller: _searchController,
                    hintText: l10n.groupSpaceSearchHint,
                    onChanged: (value) => setState(() => _query = value),
                    onClear: () => setState(() => _query = ''),
                  ),
                ),
                if (!searching) ...[
                  const _NinjaGroupSpaceSectionHeader(),
                  if (telegram != null)
                    NinjaGroupTelegramCard(
                      link: telegram,
                      onOpen: () => unawaited(_openLink(context, telegram)),
                      onDelete: space.isOwner || telegram.isMine
                          ? () => unawaited(_deleteLink(context, telegram))
                          : null,
                    )
                  else if (space.isOwner)
                    NinjaGroupAddTelegramCard(
                      label: l10n.groupSpaceAddTelegramRow,
                      onTap: () => unawaited(_addLink(context, telegram: true)),
                    )
                  else
                    NinjaGroupEmptyHint(
                      text: l10n.groupSpaceAddTelegramSubtitle,
                    ),
                ],
                _NinjaGroupSpaceSectionHeader(
                  title: l10n.groupSpaceSectionAnnouncement,
                  actionLabel: space.isOwner ? l10n.groupSpaceActionNew : null,
                  onAction: space.isOwner
                      ? () => unawaited(_addPost(context, announcement: true))
                      : null,
                ),
                if (showAnnouncement && announcement != null)
                  NinjaGroupAnnouncementCard(
                    announcement: announcement,
                    onComments: () =>
                        unawaited(_openComments(context, announcement.id)),
                  )
                else if (!searching)
                  NinjaGroupEmptyHint(text: l10n.groupSpaceAnnouncementEmpty),
                if (!searching)
                  NinjaGroupCreateNoteCard(
                    onTap: () =>
                        unawaited(_addPost(context, announcement: false)),
                  ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final note = notes.elementAtOrNull(index);
                if (note == null) return null;
                return NinjaGroupNoteCard(
                  note: note,
                  pending: state.pendingLikeIds.contains(note.id),
                  onLike: () => unawaited(
                    context.read<GroupSpaceCubit>().toggleLike(note.id),
                  ),
                  onComments: () => unawaited(_openComments(context, note.id)),
                );
              },
              childCount: notes.length,
            ),
          ),
          if (noResults)
            SliverToBoxAdapter(
              child: Padding(
                padding: const .fromLTRB(
                  AppSpacing.screen,
                  8,
                  AppSpacing.screen,
                  0,
                ),
                child: NinjaEmptyState(
                  icon: AppLineIconWidget(
                    AppLineIcon.search,
                    color: context.colors.muted,
                  ),
                  title: l10n.groupSpaceSearchEmpty,
                ).animateEmptyState(),
              ),
            ),
          if (!searching) ...[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  _NinjaGroupSpaceSectionHeader(
                    title: l10n.groupSpaceSectionNotes,
                    actionLabel: l10n.groupSpaceOpen,
                    onAction: () => _openCollabNotes(context),
                  ),
                  if (state.notesPreview.isEmpty)
                    NinjaGroupEmptyHint(text: l10n.groupSpaceNotesPreviewEmpty)
                  else
                    GroupSpaceNotesPreviewSection(
                      notes: state.notesPreview,
                      onOpen: (_) => _openCollabNotes(context),
                    ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  _NinjaGroupSpaceSectionHeader(
                    title: l10n.groupSpaceSectionLinks,
                    actionLabel: l10n.groupSpaceActionAdd,
                    onAction: () =>
                        unawaited(_addLink(context, telegram: false)),
                  ),
                  if (space.plainLinks.isEmpty)
                    NinjaGroupEmptyHint(text: l10n.groupSpaceLinksEmpty)
                  else
                    Column(
                      children: [
                        for (final link in space.plainLinks)
                          NinjaGroupLinkCard(
                            link: link,
                            pending: state.pendingLinkDeleteIds.contains(
                              link.id,
                            ),
                            onOpen: () => unawaited(_openLink(context, link)),
                            onDelete: space.isOwner || link.isMine
                                ? () => unawaited(_deleteLink(context, link))
                                : null,
                          ),
                      ],
                    ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  _NinjaGroupSpaceSectionHeader(
                    title: l10n.studyGroupMembersSection,
                    actionLabel: l10n.groupSpaceOpen,
                    onAction: () => unawaited(_manageGroup(context)),
                  ),
                  GroupSpaceMembersSection(
                    members: space.members,
                    onOpenMember: (_) => unawaited(_manageGroup(context)),
                  ),
                ],
              ),
            ),
            if (!space.myBirthdaySet)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const SizedBox(height: 18),
                    GroupSpaceSetBirthdayCard(
                      onTap: () => unawaited(_setBirthday(context)),
                    ),
                  ],
                ),
              ),
            if (space.birthdays.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _NinjaGroupSpaceSectionHeader(
                      title: l10n.groupSpaceSectionBirthdays,
                    ),
                    SizedBox(
                      height: 148,
                      child: ListView.separated(
                        scrollDirection: .horizontal,
                        padding: const .symmetric(
                          horizontal: AppSpacing.screen,
                        ),
                        itemCount: space.birthdays.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (_, index) => GroupSpaceBirthdayCard(
                          birthday: space.birthdays[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          SliverToBoxAdapter(
            child: SizedBox(height: ninjaBottomInset(context) + AppSpacing.lg),
          ),
        ],
      ),
    );
  }

  List<GroupSpaceQuickAction> _quickActions(
    BuildContext context,
    GroupSpace space,
  ) {
    final l10n = context.l10n;
    return [
      if (space.isOwner)
        GroupSpaceQuickAction(
          icon: .bell,
          label: l10n.groupSpaceQuickAnnouncement,
          onTap: () => unawaited(_addPost(context, announcement: true)),
        ),
      GroupSpaceQuickAction(
        icon: .pencil,
        label: l10n.groupSpaceQuickNote,
        onTap: () => _openCollabNotes(context),
      ),
      GroupSpaceQuickAction(
        icon: .globe,
        label: l10n.groupSpaceQuickLink,
        onTap: () => unawaited(_addLink(context, telegram: false)),
      ),
      GroupSpaceQuickAction(
        icon: .share,
        label: l10n.studyGroupInviteAction,
        onTap: () => unawaited(_invite(context, space)),
      ),
    ];
  }

  void _showMutationFailure(BuildContext context, GroupSpaceState state) {
    final failure = state.mutationFailure;
    if (failure == null) return;
    final message = switch (failure) {
      .refresh => context.l10n.loadingError,
      .like ||
      .link ||
      .post ||
      .deleteLink ||
      .comment ||
      .deleteComment ||
      .birthday => context.l10n.error,
    };
    showNinjaToast(context, showCheck: false, message: message);
    context.read<GroupSpaceCubit>().clearMutationFailure();
  }

  Future<void> _openLink(BuildContext context, GroupLink link) async {
    final uri = link.safeUri;
    if (uri == null) {
      showNinjaToast(context, showCheck: false, message: context.l10n.error);
      return;
    }
    try {
      final opened = await context.read<ExternalLinkLauncher>().open(uri);
      if (!opened && context.mounted) {
        showNinjaToast(context, showCheck: false, message: context.l10n.error);
      }
    } on Exception {
      if (context.mounted) {
        showNinjaToast(context, showCheck: false, message: context.l10n.error);
      }
    }
  }

  Future<void> _addLink(
    BuildContext context, {
    required bool telegram,
  }) async {
    final cubit = context.read<GroupSpaceCubit>();
    await showAppSheet<void>(
      context,
      title: telegram
          ? context.l10n.groupSpaceAddTelegramTitle
          : context.l10n.groupSpaceAddLinkTitle,
      child: BlocProvider.value(
        value: cubit,
        child: GroupLinkSheet(telegram: telegram),
      ),
    );
  }

  Future<void> _addPost(
    BuildContext context, {
    required bool announcement,
  }) async {
    final cubit = context.read<GroupSpaceCubit>();
    await showAppSheet<void>(
      context,
      title: announcement
          ? context.l10n.groupSpaceAnnouncementSheetTitle
          : context.l10n.groupSpaceNoteSheetTitle,
      child: BlocProvider.value(
        value: cubit,
        child: GroupPostSheet(announcement: announcement),
      ),
    );
  }

  Future<void> _openComments(BuildContext context, String postId) async {
    final cubit = context.read<GroupSpaceCubit>();
    await showAppSheet<void>(
      context,
      title: context.l10n.groupSpaceCommentsTitle,
      child: BlocProvider.value(
        value: cubit,
        child: GroupPostCommentsSheet(postId: postId),
      ),
    );
  }

  void _openCollabNotes(BuildContext context) {
    context.go('/services/people/collab-notes');
  }

  Future<void> _manageGroup(BuildContext context) async {
    await Navigator.of(context).push(StudyGroupPage.route());
    if (context.mounted) await context.read<GroupSpaceCubit>().load();
  }

  Future<void> _invite(BuildContext context, GroupSpace space) async {
    final groupName = space.group;
    final joinCode = space.joinCode;
    if (groupName == null || joinCode == null || joinCode.isEmpty) return;
    final friends = context.read<FriendsRepository>();
    final groups = context.read<StudyGroupsRepository>();
    await showAppSheet<void>(
      context,
      title: context.l10n.studyGroupInviteTitle,
      subtitle: context.l10n.studyGroupInviteSubtitle,
      child: NinjaInviteSheet(
        groupName: groupName,
        joinCode: joinCode,
        onSearch: friends.searchUsers,
        onInvite: (userId) => _inviteMember(groups, userId),
      ),
    );
  }

  Future<bool> _inviteMember(
    StudyGroupsRepository groups,
    String userId,
  ) async {
    try {
      await groups.inviteByUserId(userId);
      return true;
    } on Exception {
      return false;
    }
  }

  Future<void> _setBirthday(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showAppDatePicker(
      context,
      initial: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      title: context.l10n.groupSpaceSetBirthdayTitle,
      quickChips: const [],
    );
    if (picked == null || !context.mounted) return;
    final ok = await context.read<GroupSpaceCubit>().setMyBirthDate(picked);
    if (!ok && context.mounted) {
      showNinjaToast(context, showCheck: false, message: context.l10n.error);
    }
  }

  Future<void> _deleteLink(BuildContext context, GroupLink link) async {
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: context.l10n.delete,
      message: link.title,
      confirmLabel: context.l10n.delete,
      cancelLabel: context.l10n.cancel,
      destructive: true,
    );
    if (confirmed && context.mounted) {
      await context.read<GroupSpaceCubit>().deleteLink(link.id);
    }
  }
}
