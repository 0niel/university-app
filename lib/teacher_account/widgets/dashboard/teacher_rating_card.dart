import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';

class TeacherRatingCard extends StatelessWidget {
  const TeacherRatingCard({
    required this.resource,
    required this.onReviews,
    super.key,
  });

  final TeacherResource<TeacherProfile> resource;
  final VoidCallback onReviews;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = resource.data;
    String formatRating(double? value) => value == null
        ? '—'
        : NumberFormat('0.0', l10n.localeName).format(value);
    final colors = context.colors;
    final criteria = [
      (l10n.teacherProfileClarity, profile?.clarity),
      (l10n.teacherProfileLoyalty, profile?.loyalty),
      (l10n.teacherProfileUsefulness, profile?.usefulness),
    ];
    return AppCard(
      key: const ValueKey('teacher-rating-summary'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                formatRating(profile?.overall),
                style: AppText.serif(36).copyWith(color: colors.ink),
              ),
              Text(
                '${l10n.scheduleTeacherReviews}: ${profile?.reviewsCount ?? 0}',
                style: AppText.subtext.copyWith(color: colors.muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final criterion in criteria) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    criterion.$1,
                    style: AppText.body.copyWith(color: colors.muted),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  formatRating(criterion.$2),
                  style: AppText.bodyBold.copyWith(color: colors.ink),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            profile?.overall == null
                ? l10n.teacherNoRating
                : l10n.teacherRatingDescription,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.secondary(
            label: l10n.teacherOwnReviews,
            expanded: true,
            onPressed: onReviews,
          ),
        ],
      ),
    );
  }
}
