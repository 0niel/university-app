part of '../schedule_details_page.dart';

class _SubjectHero extends StatelessWidget {
  const _SubjectHero({required this.lesson, required this.selectedDate});

  final LessonSchedulePart lesson;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final room = lesson.classrooms.firstOrNull;
    final campus = room?.campus?.shortName ?? room?.campus?.name;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppBadge(
                key: const ValueKey('lesson-type-badge'),
                label: _lessonTypeName(l10n, lesson),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xsm,
                ),
                textStyle: AppText.sans(12, FontWeight.w700),
                tone: switch (lesson.lessonType) {
                  LessonType.lecture => AppBadgeTone.lecture,
                  LessonType.practice => AppBadgeTone.practice,
                  LessonType.laboratoryWork => AppBadgeTone.lab,
                  LessonType.exam || LessonType.credit => AppBadgeTone.exam,
                  _ => AppBadgeTone.accent,
                },
              ),
              Text(
                capitalizeFirst(
                  DateFormat('EEEE, d MMMM', locale).format(selectedDate),
                ),
                style: AppText.sans(
                  13,
                  FontWeight.w500,
                ).copyWith(color: colors.muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppBalancedText(
            lesson.subject,
            style: AppText.serif(
              32,
              height: 1.1,
              letterSpacingEm: -.02,
            ).copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.contentGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 320 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.5;
              final cards = [
                _LessonInfoCard(
                  label: l10n.scheduleDiffFieldTime,
                  value: _timeRange(lesson),
                  caption: [
                    if (lessonNumberOf(lesson) case final number?)
                      l10n.lessonPairOrdinal(number),
                    if (campus != null && campus.isNotEmpty) campus,
                  ].join(' · '),
                ),
                _LessonInfoCard(
                  label: l10n.classroom,
                  value: _classroomLine(l10n, lesson),
                  caption: [
                    if (campus != null && campus.isNotEmpty) campus,
                    l10n.lessonOnMap,
                  ].join(' · '),
                  onTap: () => const MapRoute().push<void>(context),
                ),
              ];
              return stacked
                  ? Column(spacing: AppSpacing.sm, children: cards)
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: cards.first),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: cards.last),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}

class _LessonInfoCard extends StatelessWidget {
  const _LessonInfoCard({
    required this.label,
    required this.value,
    required this.caption,
    this.onTap,
  });
  final String label;
  final String value;
  final String caption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => AppCard(
    radius: AppRadius.lg,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sectionGap,
    ),
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppText.captionSmall.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: AppSpacing.xsm),
        Text(
          value,
          style: AppText.sans(
            17,
            FontWeight.w700,
            tabular: true,
          ).copyWith(color: context.colors.ink),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          caption,
          style: AppText.caption.copyWith(
            color: onTap == null ? context.colors.muted : context.colors.accent,
          ),
        ),
      ],
    ),
  );
}
