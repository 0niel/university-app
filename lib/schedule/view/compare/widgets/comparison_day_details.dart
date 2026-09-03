import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/compare/comparison_logic.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ComparisonDayDetails extends StatelessWidget {
  const ComparisonDayDetails({
    required this.day,
    required this.mine,
    required this.friends,
    required this.myName,
    required this.friendName,
    required this.onDay,
    this.myBusyRanges = const [],
    this.friendBusyRanges = const [],
    this.myUncertainFrom = const [],
    this.friendUncertainFrom = const [],
    super.key,
  });

  final DateTime day;
  final List<LessonSchedulePart> mine;
  final List<LessonSchedulePart> friends;
  final String myName;
  final String friendName;
  final ValueChanged<DateTime> onDay;
  final Iterable<(int start, int end)> myBusyRanges;
  final Iterable<(int start, int end)> friendBusyRanges;
  final Iterable<int> myUncertainFrom;
  final Iterable<int> friendUncertainFrom;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slots = buildComparisonSlots(
      mine,
      friends,
      busyRanges: [...myBusyRanges, ...friendBusyRanges],
      uncertainFrom: [...myUncertainFrom, ...friendUncertainFrom],
    );
    final windows = slots.where((slot) => slot.bothFree).toList();
    final hasUncertain =
        myUncertainFrom.isNotEmpty || friendUncertainFrom.isNotEmpty;
    final uncertainLabel =
        '${l10n.legendEvent} · ${l10n.pickerTimeTitle}: ${l10n.toolsNoValue}';
    return Column(
      key: const ValueKey('comparison-day-details'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        Row(
          children: [
            AppIconButton(
              key: const ValueKey('comparison-previous-day'),
              icon: const AppLineIconWidget(AppLineIcon.chevronL),
              tooltip: l10n.previousDay,
              onPressed: () => onDay(day.subtract(const Duration(days: 1))),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppPressable(
                onTap: () async {
                  final selected = await showAppDatePicker(
                    context,
                    initial: day,
                  );
                  if (selected != null && context.mounted) onDay(selected);
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Center(
                    child: Text(
                      MaterialLocalizations.of(context).formatFullDate(day),
                      textAlign: TextAlign.center,
                      style: AppText.section.copyWith(
                        color: context.colors.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppIconButton(
              key: const ValueKey('comparison-next-day'),
              icon: const AppLineIconWidget(AppLineIcon.chevronR),
              tooltip: l10n.nextDay,
              onPressed: () => onDay(day.add(const Duration(days: 1))),
            ),
          ],
        ),
        Align(
          child: AppButton.text(
            label: l10n.today,
            onPressed: () => onDay(DateTime.now()),
          ),
        ),
        if (slots.isNotEmpty)
          AppCard(
            tinted: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.sm,
              children: [
                Text(
                  l10n.compareWindowsTitle,
                  style: AppText.section.copyWith(color: context.colors.ink),
                ),
                if (windows.isEmpty)
                  Text(
                    hasUncertain ? uncertainLabel : l10n.compareNoWindows,
                    style: AppText.body.copyWith(color: context.colors.muted),
                  )
                else
                  for (final window in windows)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        Text(
                          '${window.time}–${window.untilTime}',
                          style: AppText.tabular(
                            AppText.headline.copyWith(
                              color: context.colors.accent,
                            ),
                          ),
                        ),
                        Text(
                          l10n.minutesShort(window.freeUntil! - window.minute),
                          style: AppText.subtext.copyWith(
                            color: context.colors.muted,
                          ),
                        ),
                      ],
                    ),
                Text(
                  l10n.compareWindowsHint,
                  style: AppText.caption.copyWith(color: context.colors.muted),
                ),
              ],
            ),
          ),
        if (slots.isEmpty && hasUncertain)
          AppBanner(message: uncertainLabel)
        else if (slots.isEmpty)
          AppEmptyState(
            title: l10n.compareNoLessonsBoth,
            lineIcon: AppLineIcon.calendar,
          )
        else
          for (final slot in slots)
            if (slot.bothFree)
              AppBanner(
                key: ValueKey('comparison-free-${slot.minute}'),
                tone: AppBannerTone.success,
                message: l10n.compareCommonWindow(slot.time, slot.untilTime),
              )
            else
              _ComparisonSlotCard(
                slot: slot,
                myName: myName,
                friendName: friendName,
                myBusy:
                    myBusyRanges.any(
                      (range) =>
                          slot.minute >= range.$1 && slot.minute < range.$2,
                    ) ||
                    myUncertainFrom.any(
                      (minute) => minute < (slot.freeUntil ?? slot.minute + 1),
                    ),
                friendBusy:
                    friendBusyRanges.any(
                      (range) =>
                          slot.minute >= range.$1 && slot.minute < range.$2,
                    ) ||
                    friendUncertainFrom.any(
                      (minute) => minute < (slot.freeUntil ?? slot.minute + 1),
                    ),
              ),
      ],
    );
  }
}

class _ComparisonSlotCard extends StatelessWidget {
  const _ComparisonSlotCard({
    required this.slot,
    required this.myName,
    required this.friendName,
    required this.myBusy,
    required this.friendBusy,
  });

  final ComparisonSlot slot;
  final String myName;
  final String friendName;
  final bool myBusy;
  final bool friendBusy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                slot.untilTime.isEmpty
                    ? slot.time
                    : '${slot.time}–${slot.untilTime}',
                style: AppText.tabular(
                  AppText.headline.copyWith(color: context.colors.ink),
                ),
              ),
              if (slot.isTogether)
                AppBadge(
                  label: l10n.compareTogether,
                  tone: AppBadgeTone.lecture,
                  icon: AppLineIcon.people,
                ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final mine = _ComparisonSide(
                label: '${l10n.compareYou} · $myName',
                lessons: slot.allMine,
                busy: myBusy,
              );
              final friend = _ComparisonSide(
                label: '${l10n.compareFriend} · $friendName',
                lessons: slot.allFriends,
                busy: friendBusy,
              );
              final stacked =
                  constraints.maxWidth < 300 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.4;
              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.md,
                  children: [mine, friend],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: mine),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: friend),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ComparisonSide extends StatelessWidget {
  const _ComparisonSide({
    required this.label,
    required this.lessons,
    required this.busy,
  });

  final String label;
  final List<LessonSchedulePart> lessons;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(label, style: AppText.subtext.copyWith(color: colors.muted)),
        if (lessons.isEmpty)
          Text(
            busy ? context.l10n.legendEvent : context.l10n.compareFreeCell,
            style: AppText.body.copyWith(color: colors.muted),
          ),
        for (final lesson in lessons)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.xs,
            children: [
              Text(
                LessonCard.getLessonTypeName(context.l10n, lesson.lessonType),
                style: AppText.typeTag.copyWith(
                  color: LessonCard.colorOfFor(context, lesson),
                ),
              ),
              Text(
                lesson.subject,
                style: AppText.headline.copyWith(color: colors.ink),
              ),
              Text(
                timeRangeText(lesson),
                style: AppText.tabular(
                  AppText.subtext.copyWith(color: colors.muted),
                ),
              ),
              if (lesson.classrooms.isNotEmpty)
                Text(
                  lesson.classrooms.map((room) => room.name).join(' · '),
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              if (lesson.teachers.isNotEmpty)
                Text(
                  lesson.teachers.map((teacher) => teacher.name).join(' · '),
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
            ],
          ),
      ],
    );
  }
}
