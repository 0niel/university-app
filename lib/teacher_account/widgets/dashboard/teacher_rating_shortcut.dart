import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';

class TeacherRatingShortcut extends StatelessWidget {
  const TeacherRatingShortcut({
    required this.resource,
    required this.onTap,
    super.key,
  });

  final TeacherResource<TeacherProfile> resource;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = resource.data;
    String formatRating(double? value) => value == null
        ? '—'
        : NumberFormat('0.0', l10n.localeName).format(value);
    final colors = context.colors;
    final loading = resource.isLoading;
    final error = resource.hasError;
    final summary = profile != null
        ? profile.overall == null
              ? l10n.teacherNoRating
              : formatRating(profile.overall)
        : error
        ? l10n.teacherRatingRefreshError
        : loading
        ? l10n.loadingContent
        : l10n.teacherNoRating;
    final reviews = profile == null
        ? null
        : '${l10n.scheduleTeacherReviews}: ${profile.reviewsCount}';
    final refreshStatus = profile == null
        ? null
        : error
        ? l10n.teacherRatingRefreshError
        : loading
        ? l10n.loadingContent
        : null;
    return AppCard(
      key: const ValueKey('teacher-rating-shortcut'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      semanticsLabel: [
        l10n.teacherOwnRating,
        summary,
        reviews,
        refreshStatus,
      ].whereType<String>().join(', '),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppControlSize.touchTarget - 2 * AppSpacing.sm,
        ),
        child: Row(
          children: [
            AppLineIconWidget(
              AppLineIcon.star,
              color: colors.accent,
              size: AppIconSize.sm,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        l10n.teacherOwnRating,
                        style: AppText.subtext.copyWith(color: colors.muted),
                      ),
                      Text(
                        summary,
                        style: AppText.labelStrong.copyWith(color: colors.ink),
                      ),
                      if (reviews != null)
                        Text(
                          reviews,
                          style: AppText.subtext.copyWith(color: colors.muted),
                        ),
                      if (error && profile == null)
                        Text(
                          l10n.retry,
                          style: AppText.subtextStrong.copyWith(
                            color: colors.accent,
                          ),
                        ),
                    ],
                  ),
                  if (refreshStatus != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      refreshStatus,
                      style: AppText.caption.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: AppSpacing.sm),
              AppLineIconWidget(
                AppLineIcon.chevronR,
                color: colors.muted,
                size: AppIconSize.sm,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
