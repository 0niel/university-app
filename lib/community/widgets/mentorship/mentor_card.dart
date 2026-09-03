import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MentorCard extends StatelessWidget {
  const MentorCard({
    required this.mentor,
    super.key,
    this.onRequest,
    this.onEdit,
    this.onTelegram,
  });

  final Mentor mentor;
  final VoidCallback? onRequest;
  final VoidCallback? onEdit;
  final VoidCallback? onTelegram;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final course = mentor.course;
    final courseLabel = course == null
        ? null
        : context.l10n.mentorshipCourse(course);
    final subtitle = <String>[?courseLabel, ?mentor.group].join(' · ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 10,
            crossAxisAlignment: .start,
            children: [
              Row(
                spacing: 12,
                children: [
                  NinjaAvatar(initials: ninjaInitials(mentor.fullName)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Wrap(
                          spacing: 6,
                          crossAxisAlignment: .center,
                          children: [
                            Text(
                              mentor.fullName,
                              style: AppText.body.copyWith(color: colors.ink),
                            ),
                            if (mentor.isMe)
                              NinjaBadge(
                                context.l10n.mentorshipItsYou,
                                tone: .ink,
                              ),
                          ],
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: AppText.captionSmall.copyWith(
                              color: colors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (mentor.sessions > 0)
                    Row(
                      mainAxisSize: .min,
                      spacing: 4,
                      children: [
                        AppLineIconWidget(
                          .people,
                          size: 14,
                          color: colors.muted,
                        ),
                        Text(
                          '${mentor.sessions}',
                          style: AppText.tabular(
                            AppText.subtext.copyWith(color: colors.muted),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (mentor.bio.isNotEmpty)
                Text(
                  mentor.bio,
                  maxLines: 3,
                  overflow: .ellipsis,
                  style: AppText.subtext.copyWith(
                    color: colors.muted,
                    height: 1.4,
                  ),
                ),
              if (mentor.topics.isNotEmpty)
                Text(
                  mentor.topics.join(' · '),
                  style: AppText.captionSmall.copyWith(color: colors.accent),
                ),
              if (mentor.isMe)
                NinjaButton.secondary(
                  label: context.l10n.mentorshipEditProfile,
                  expanded: true,
                  onPressed: onEdit,
                )
              else
                NinjaButton.primary(
                  label: context.l10n.mentorshipSendRequest,
                  expanded: true,
                  onPressed: onRequest,
                ),
              if (onTelegram != null)
                NinjaButton.tonal(
                  label: context.l10n.mentorshipTelegramButton,
                  expanded: true,
                  onPressed: onTelegram,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
