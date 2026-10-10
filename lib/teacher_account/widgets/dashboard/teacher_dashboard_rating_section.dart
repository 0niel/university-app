import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_rating_card.dart';

class TeacherDashboardRatingSection extends StatelessWidget {
  const TeacherDashboardRatingSection({
    required this.resource,
    required this.onRetry,
    required this.onReviews,
    super.key,
  });

  final TeacherResource<TeacherProfile> resource;
  final VoidCallback onRetry;
  final VoidCallback onReviews;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppOverline(l10n.teacherOwnRating),
        if (resource.isLoading && resource.data == null)
          AppSkeletonGroup(
            semanticsLabel: l10n.loadingContent,
            child: const AppSkeleton(height: 180, radius: AppRadius.card),
          )
        else if (resource.hasError && resource.data == null)
          AppErrorState(
            title: l10n.loadingError,
            message: l10n.tryAgain,
            footnote: null,
            primaryLabel: l10n.retry,
            onPrimary: onRetry,
          )
        else ...[
          if (resource.isLoading) ...[
            LinearProgressIndicator(
              color: colors.accent,
              backgroundColor: colors.line,
              minHeight: 2,
              semanticsLabel: l10n.loadingContent,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (resource.hasError) ...[
            AppBanner(
              key: const ValueKey('teacher-rating-refresh-error'),
              message: l10n.teacherRatingRefreshError,
              tone: AppBannerTone.warn,
              actionLabel: l10n.retry,
              onAction: onRetry,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          TeacherRatingCard(resource: resource, onReviews: onReviews),
        ],
      ],
    );
  }
}
