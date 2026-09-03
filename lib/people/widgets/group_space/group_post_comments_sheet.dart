import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_cubit.dart';
import 'package:rtu_mirea_app/people/widgets/group_space/group_space_relative_time.dart';

class GroupPostCommentsSheet extends StatefulWidget {
  const GroupPostCommentsSheet({required this.postId, super.key});

  final String postId;

  @override
  State<GroupPostCommentsSheet> createState() => _GroupPostCommentsSheetState();
}

class _GroupPostCommentsSheetState extends State<GroupPostCommentsSheet> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(
        context.read<GroupSpaceCubit>().loadComments(widget.postId),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _controller.text.trim();
    if (body.isEmpty) return;
    _controller.clear();
    final cubit = context.read<GroupSpaceCubit>();
    final ok = await cubit.addComment(postId: widget.postId, body: body);
    if (!ok && mounted) {
      showNinjaToast(context, showCheck: false, message: context.l10n.error);
    }
  }

  Future<void> _delete(GroupPostComment comment) async {
    final cubit = context.read<GroupSpaceCubit>();
    final ok = await cubit.deleteComment(
      id: comment.id,
      postId: widget.postId,
    );
    if (!ok && mounted) {
      showNinjaToast(context, showCheck: false, message: context.l10n.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return BlocBuilder<GroupSpaceCubit, GroupSpaceState>(
      builder: (context, state) {
        final comments = state.comments[widget.postId];
        final loading = state.loadingCommentPostIds.contains(widget.postId);
        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: NinjaStateSwitcher(
                child: switch ((loading, comments)) {
                  (true, null) => const _CommentsSkeleton(
                    key: ValueKey('loading'),
                  ),
                  (_, null) => const SizedBox.shrink(key: ValueKey('idle')),
                  (_, []) => NinjaEmptyState(
                    key: const ValueKey('empty'),
                    icon: AppLineIconWidget(
                      AppLineIcon.message,
                      size: 20,
                      color: colors.muted,
                    ),
                    title: l10n.groupSpaceCommentsEmpty,
                  ).animateEmptyState(),
                  (_, final list?) => ListView.builder(
                    key: const ValueKey('list'),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final comment = list[index];
                      final pending = state.pendingCommentDeleteIds.contains(
                        comment.id,
                      );
                      return _CommentRow(
                        comment: comment,
                        pending: pending,
                        onDelete: comment.canDelete
                            ? () => unawaited(_delete(comment))
                            : null,
                      );
                    },
                  ),
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _controller,
                    placeholder: l10n.groupSpaceCommentHint,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => unawaited(_send()),
                  ),
                ),
                NinjaIconButton(
                  icon: AppLineIconWidget(.send, size: 18, color: colors.ink),
                  tooltip: l10n.groupSpaceCommentSend,
                  onPressed: state.isSubmittingComment
                      ? null
                      : () => unawaited(_send()),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({
    required this.comment,
    required this.pending,
    required this.onDelete,
  });

  final GroupPostComment comment;
  final bool pending;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: .start,
        spacing: 10,
        children: [
          NinjaAvatar(initials: ninjaInitials(comment.authorName), size: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    Text(
                      comment.authorName,
                      style: AppText.caption.copyWith(
                        fontWeight: .w700,
                        color: colors.ink,
                      ),
                    ),
                    Text(
                      groupSpaceRelativeTime(context, comment.createdAt),
                      style: AppText.captionSmall.copyWith(color: colors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  comment.body,
                  style: AppText.subtext.copyWith(color: colors.ink),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            AnimatedOpacity(
              opacity: pending ? 0.5 : 1,
              duration: const Duration(milliseconds: 160),
              child: NinjaIconButton(
                icon: AppLineIconWidget(
                  .close,
                  size: 15,
                  color: colors.muted,
                ),
                tooltip: context.l10n.delete,
                onPressed: pending ? null : onDelete,
              ),
            ),
        ],
      ),
    );
  }
}

class _CommentsSkeleton extends StatelessWidget {
  const _CommentsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      AppSkeletonRow(showTrailing: false),
      AppSkeletonRow(showTrailing: false),
      AppSkeletonRow(showTrailing: false),
    ],
  );
}
