import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/widgets/group_space/group_space_relative_time.dart';

class NinjaGroupAnnouncementCard extends StatelessWidget {
  const NinjaGroupAnnouncementCard({
    required this.announcement,
    required this.onComments,
    super.key,
  });

  final GroupAnnouncement announcement;
  final VoidCallback onComments;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                spacing: 10,
                children: [
                  NinjaAvatar(
                    initials: ninjaInitials(announcement.authorName),
                    size: 32,
                  ),
                  Expanded(
                    child: Text(
                      announcement.authorName,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppText.caption.copyWith(
                        color: colors.muted,
                        fontWeight: .w700,
                      ),
                    ),
                  ),
                  NinjaBadge(l10n.groupSpaceNotePinned),
                  Text(
                    groupSpaceRelativeTime(context, announcement.createdAt),
                    style: AppText.captionSmall.copyWith(color: colors.muted),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                announcement.title,
                style: AppText.headline.copyWith(color: colors.ink),
              ),
              if (announcement.body.isNotEmpty) ...[
                const SizedBox(height: 6),
                AppExpandableText(
                  text: announcement.body,
                  expandLabel: l10n.groupSpaceShowFull,
                  collapseLabel: l10n.groupSpaceCollapse,
                  style: AppText.subtext.copyWith(
                    color: colors.muted,
                    height: 1.45,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              AppPressable(
                onTap: onComments,
                semanticsLabel: l10n.groupSpaceCommentsCount(
                  announcement.commentsCount,
                ),
                semanticsButton: true,
                child: Row(
                  mainAxisSize: .min,
                  spacing: 4,
                  children: [
                    AppLineIconWidget(
                      .message,
                      size: 16,
                      color: colors.muted,
                    ),
                    Text(
                      '${announcement.commentsCount}',
                      style: AppText.caption.copyWith(
                        color: colors.muted,
                        fontWeight: .w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
