import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/home_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';

class HomeLessonsGroup extends StatelessWidget {
  const HomeLessonsGroup({
    required this.entries,
    required this.onOpen,
    this.featuredEntry,
    super.key,
  });
  final List<HomeLessonEntry> entries;
  final ValueChanged<HomeLessonEntry> onOpen;
  final HomeLessonEntry? featuredEntry;

  @override
  Widget build(BuildContext context) {
    final list = entries
        .where((entry) => entry != featuredEntry)
        .toList();
    if (list.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: AppListGroup(
        showDividers: false,
        children: [
          for (final entry in list)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.colors.line),
                ),
              ),
              child: HomeLessonRow(entry: entry, onTap: () => onOpen(entry)),
            ),
        ],
      ),
    );
  }
}

class HomeLessonRow extends StatelessWidget {
  const HomeLessonRow({required this.entry, required this.onTap, super.key});
  final HomeLessonEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final tone = lessonAccentOf(context, entry.lesson);
    final dim = entry.isDimmed;
    final titleColor = dim ? colors.muted2 : colors.ink;
    final metaColor = entry.isCancelled
        ? colors.danger
        : dim
        ? colors.muted2
        : entry.isMoved
        ? colors.warn
        : colors.muted;
    final badge = entry.isCancelled
        ? AppBadge(label: l10n.lessonMetaCancelled, tone: AppBadgeTone.exam)
        : entry.isMoved
        ? AppBadge(label: l10n.scheduleChangeTagMoved, tone: AppBadgeTone.warn)
        : entry.isNext
        ? AppBadge(label: l10n.homeNextTag, tone: AppBadgeTone.lecture)
        : null;
    final time = SizedBox(
      width: MediaQuery.textScalerOf(context).scale(44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.Hm().format(entry.start),
            style: AppText.compactStrong.copyWith(
              color: titleColor,
              height: 1.5,
            ),
          ),
          Text(
            DateFormat.Hm().format(entry.end),
            style: AppText.sans(
              11.5,
              FontWeight.w500,
              height: 20.25 / 11.5,
            ).copyWith(color: metaColor),
          ),
        ],
      ),
    );
    final tile = AppIconTile(
      size: 40,
      radius: AppRadius.tile,
      background: dim ? colors.surface2 : colors.tintOf(tone),
      foreground: dim ? colors.muted2 : tone,
      child: Text(
        lessonShortLabel(l10n, entry.lesson.lessonType),
        style: AppText.tileTag.copyWith(color: dim ? colors.muted2 : tone),
        textScaler: TextScaler.noScaling,
      ),
    );
    Widget body({required bool stacked}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.lesson.subject,
          maxLines: stacked ? 3 : 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.headline.copyWith(
            color: titleColor,
            decoration: entry.isCancelled ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          homeLessonRowMeta(l10n, entry),
          maxLines: stacked ? 3 : 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.subtext.copyWith(color: metaColor),
        ),
        if (stacked && badge != null) ...[const SizedBox(height: 6), badge],
      ],
    );
    final chevron = AppLineIconWidget(
      AppLineIcon.chevronR,
      size: 16,
      color: colors.muted2,
    );
    return AppPressable(
      onTap: onTap,
      semanticsLabel:
          '${entry.lesson.subject}, ${DateFormat.Hm().format(entry.start)}',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 16, 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 280 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.3;
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      time,
                      const SizedBox(width: 12),
                      tile,
                      const Spacer(),
                      chevron,
                    ],
                  ),
                  const SizedBox(height: 12),
                  body(stacked: true),
                ],
              );
            }
            return Row(
              children: [
                time,
                const SizedBox(width: 12),
                tile,
                const SizedBox(width: 12),
                Expanded(child: body(stacked: false)),
                const SizedBox(width: 12),
                if (badge != null) badge else chevron,
              ],
            );
          },
        ),
      ),
    );
  }
}
