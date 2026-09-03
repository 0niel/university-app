part of '../schedule_details_page.dart';

class _TeacherRow extends StatelessWidget {
  const _TeacherRow({required this.teacher, this.profile});
  final Teacher teacher;
  final TeacherProfile? profile;

  @override
  Widget build(BuildContext context) {
    final rating = profile?.overall;
    final formattedRating = rating == null
        ? null
        : NumberFormat('0.0', context.l10n.localeName).format(rating);
    return AppCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sectionGap,
      ),
      onTap: () => showTeacherProfileSheet(context, teacher: teacher),
      child: Row(
        children: [
          if (teacher.photoUrl?.isNotEmpty ?? false)
            AppAvatar(name: teacher.name, imageUrl: teacher.photoUrl, size: 40)
          else
            Container(
              width: AppSpacing.xxlg,
              height: AppSpacing.xxlg,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.surface2,
                shape: BoxShape.circle,
              ),
              child: Text(
                AppAvatar.initialsOf(teacher.name),
                style: AppText.sans(
                  13,
                  FontWeight.w800,
                ).copyWith(color: context.colors.muted),
              ),
            ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.lessonDetailsTeacherFallback,
                  style: AppText.captionSmall.copyWith(
                    color: context.colors.muted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  teacher.name,
                  style: AppText.headlineStrong.copyWith(
                    color: context.colors.ink,
                  ),
                ),
              ],
            ),
          ),
          if (rating != null) ...[
            const SizedBox(width: AppSpacing.sm),
            AppLineIconWidget(
              AppLineIcon.star,
              size: 14,
              color: context.colors.accent,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(formattedRating!, style: AppText.labelStrong),
          ],
          const SizedBox(width: AppSpacing.sm),
          AppLineIconWidget(
            AppLineIcon.chevronR,
            size: 16,
            color: context.colors.muted2,
          ),
        ],
      ),
    );
  }
}
