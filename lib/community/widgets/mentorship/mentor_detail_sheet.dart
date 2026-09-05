import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/view/mentorship_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MentorDetailSheet extends StatelessWidget {
  const MentorDetailSheet({required this.mentor, super.key});

  final Mentor mentor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final metadata = [
      if (mentor.course case final course?) l10n.mentorshipCourse(course),
      if (mentor.group?.isNotEmpty == true) mentor.group!,
      if (mentor.sessions > 0) l10n.mentorshipSessionsCount(mentor.sessions),
    ].join(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.md,
      children: [
        Row(
          children: [
            AppAvatar(name: mentor.fullName, size: 56),
            if (metadata.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  metadata,
                  style: AppText.subtext.copyWith(color: context.colors.muted),
                ),
              ),
            ],
          ],
        ),
        if (mentor.bio.isNotEmpty)
          Text(
            mentor.bio,
            style: AppText.body.copyWith(color: context.colors.ink),
          ),
        if (mentor.topics.isNotEmpty) ...[
          AppFieldLabel(l10n.mentorshipTopicsLabel),
          Text(
            mentor.topics
                .map((topic) => mentorTopicLabel(l10n, topic))
                .join(' · '),
            style: AppText.body.copyWith(color: context.colors.ink),
          ),
        ],
        if (mentor.level.isNotEmpty) ...[
          AppFieldLabel(l10n.mentorshipLevelLabel),
          Text(
            mentorLevelLabel(l10n, mentor.level),
            style: AppText.body.copyWith(color: context.colors.ink),
          ),
        ],
        if (mentor.formats.isNotEmpty) ...[
          AppFieldLabel(l10n.mentorshipFormatLabel),
          Text(
            mentor.formats
                .map((format) => mentorFormatLabel(l10n, format))
                .join(' · '),
            style: AppText.body.copyWith(color: context.colors.ink),
          ),
        ],
        AppButton.primary(
          label: mentor.isMe
              ? l10n.mentorshipEditProfile
              : l10n.mentorshipSendRequest,
          expanded: true,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
