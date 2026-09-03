import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/widgets/group_space/group_space_relative_time.dart';

class NinjaGroupNoteCard extends StatelessWidget {
  const NinjaGroupNoteCard({
    required this.note,
    required this.pending,
    required this.onLike,
    required this.onComments,
    super.key,
  });

  final GroupNote note;
  final bool pending;
  final VoidCallback onLike;
  final VoidCallback onComments;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Padding(
          padding: const .fromLTRB(16, 14, 8, 4),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  NinjaAvatar(
                    initials: ninjaInitials(note.authorName),
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      note.authorName,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppText.caption.copyWith(color: colors.muted),
                    ),
                  ),
                  if (note.isPinned) ...[
                    NinjaBadge(l10n.groupSpaceNotePinned),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    groupSpaceRelativeTime(context, note.createdAt),
                    style: AppText.captionSmall.copyWith(color: colors.muted),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const .only(right: 12),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    if (note.title.isNotEmpty)
                      Text(
                        note.title,
                        style: AppText.headline.copyWith(color: colors.ink),
                      ),
                    if (note.body.isNotEmpty) ...[
                      if (note.title.isNotEmpty) const SizedBox(height: 4),
                      AppExpandableText(
                        text: note.body,
                        expandLabel: l10n.groupSpaceShowFull,
                        collapseLabel: l10n.groupSpaceCollapse,
                        style: AppText.subtext.copyWith(
                          color: colors.muted,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: .end,
                spacing: 4,
                children: [
                  AppPressable(
                    onTap: onComments,
                    semanticsLabel: l10n.groupSpaceCommentsCount(
                      note.commentsCount,
                    ),
                    semanticsButton: true,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: AppControlSize.iconButton,
                        minHeight: AppControlSize.iconButton,
                      ),
                      child: Row(
                        spacing: 4,
                        mainAxisSize: .min,
                        mainAxisAlignment: .center,
                        children: [
                          AppLineIconWidget(
                            .message,
                            size: 17,
                            color: colors.muted,
                          ),
                          Text(
                            '${note.commentsCount}',
                            style: AppText.caption.copyWith(
                              color: colors.muted,
                              fontWeight: .w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    toggled: note.likedByMe,
                    enabled: !pending,
                    label: '${note.likes}',
                    child: AnimatedOpacity(
                      opacity: pending ? 0.45 : 1,
                      duration: const Duration(milliseconds: 160),
                      child: AppPressable(
                        onTap: pending
                            ? null
                            : () {
                                unawaited(HapticFeedback.lightImpact());
                                onLike();
                              },
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: AppControlSize.iconButton,
                            minHeight: AppControlSize.iconButton,
                          ),
                          child: Row(
                            spacing: 4,
                            mainAxisSize: .min,
                            mainAxisAlignment: .center,
                            children: [
                              AppLineIconWidget(
                                .heart,
                                size: 18,
                                color: note.likedByMe
                                    ? colors.accent
                                    : colors.muted,
                              ),
                              Text(
                                '${note.likes}',
                                style: AppText.caption.copyWith(
                                  color: note.likedByMe
                                      ? colors.accent
                                      : colors.muted,
                                  fontWeight: .w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
