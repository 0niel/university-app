part of '../schedule_details_page.dart';

class _LessonActionGrid extends StatelessWidget {
  const _LessonActionGrid({
    required this.onNote,
    required this.onRoute,
    required this.onRemind,
    required this.onMaterials,
    required this.lesson,
    required this.day,
  });
  final VoidCallback onNote;
  final VoidCallback onRoute;
  final VoidCallback onRemind;
  final VoidCallback onMaterials;
  final LessonSchedulePart lesson;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reminder = context.watch<LessonRemindersCubit?>()?.minutesFor(
      lesson,
      day,
    );
    final tiles = [
      (l10n.classActionRemind, AppLineIcon.bell, onRemind, reminder != null),
      (l10n.lessonDetailsNote, AppLineIcon.pencil, onNote, false),
      (l10n.lessonDetailsFiles, AppLineIcon.folder, onMaterials, false),
      (l10n.lessonDetailsRoute, AppLineIcon.pin, onRoute, false),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.zero,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count =
              constraints.maxWidth < 320 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.5
              ? 2
              : 4;
          final width = (constraints.maxWidth - (count - 1) * 8) / count;
          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final tile in tiles)
                SizedBox(
                  width: width,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: ScheduleMetrics.actionHeight,
                    ),
                    child: AppCard(
                      radius: AppRadius.lg,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.lg,
                      ),
                      color: tile.$4
                          ? context.colors.accent
                          : context.colors.surface,
                      onTap: tile.$3,
                      semanticsLabel: tile.$1,
                      child: Column(
                        children: [
                          AppLineIconWidget(
                            tile.$2,
                            size: 20,
                            color: tile.$4
                                ? context.colors.onAccent
                                : context.colors.ink,
                          ),
                          const SizedBox(height: AppSpacing.xsm),
                          Text(
                            tile.$1,
                            textAlign: TextAlign.center,
                            style:
                                AppText.sans(
                                  11,
                                  FontWeight.w600,
                                ).copyWith(
                                  color: tile.$4
                                      ? context.colors.onAccent
                                      : context.colors.ink,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
