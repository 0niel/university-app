import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:wear/schedule/view/schedule_day_option_tile.dart';

class ScheduleDayPickerDialog extends StatelessWidget {
  const ScheduleDayPickerDialog({
    required this.availableDays,
    required this.currentDayIndex,
    super.key,
  });

  final List<DateTime> availableDays;
  final int currentDayIndex;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entries = <ScheduleDayOption>[];
    final seen = <int>{};

    for (final day in availableDays) {
      final normalized = DateTime(day.year, day.month, day.day);
      final index = normalized.difference(today).inDays;
      if (index < 0 || seen.contains(index)) continue;
      seen.add(index);
      entries.add(
        ScheduleDayOption(index: index, date: normalized, hasLessons: true),
      );
    }

    if (!seen.contains(currentDayIndex)) {
      entries.add(
        ScheduleDayOption(
          index: currentDayIndex,
          date: today.add(Duration(days: currentDayIndex)),
          hasLessons: availableDays.any((day) {
            final normalized = DateTime(day.year, day.month, day.day);
            return normalized.difference(today).inDays == currentDayIndex;
          }),
        ),
      );
    }

    if (entries.isEmpty) {
      for (var index = 0; index < 5; index++) {
        entries.add(
          ScheduleDayOption(
            index: index,
            date: today.add(Duration(days: index)),
            hasLessons: false,
          ),
        );
      }
    }

    entries.sort((first, second) => first.index.compareTo(second.index));

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Выбор дня',
              style: AppText.heading.copyWith(
                color: colors.active,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < entries.length; index++) ...[
              ScheduleDayOptionTile(
                option: entries[index],
                isSelected: entries[index].index == currentDayIndex,
              ),
              if (index != entries.length - 1) const SizedBox(height: 8),
            ],
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleDayOption {
  const ScheduleDayOption({
    required this.index,
    required this.date,
    required this.hasLessons,
  });

  final int index;
  final DateTime date;
  final bool hasLessons;
}
