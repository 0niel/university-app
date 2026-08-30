import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wear/schedule/view/schedule_day_picker_dialog.dart';

class ScheduleDayOptionTile extends StatelessWidget {
  const ScheduleDayOptionTile({
    required this.option,
    required this.isSelected,
    super.key,
  });

  final ScheduleDayOption option;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final weekday = _weekdayLabel(option.index, option.date);
    final dateLabel = DateFormat(
      'd MMM',
      'ru',
    ).format(option.date).replaceAll('.', '').toLowerCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).pop(option.index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.15)
                : colors.surfaceLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? colors.primary : colors.borderLight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekday,
                      style: AppText.caption.copyWith(
                        color: colors.deactive,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateLabel,
                      style: AppText.captionSmall.copyWith(
                        color: colors.active,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (option.hasLessons)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : colors.deactive,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _weekdayLabel(int index, DateTime date) {
  if (index == 0) return 'Сегодня';
  if (index == 1) return 'Завтра';
  final formatted = DateFormat('EEE', 'ru').format(date).replaceAll('.', '');
  if (formatted.isEmpty) return '';
  final firstLetter = formatted.substring(0, 1).toUpperCase();
  return '$firstLetter${formatted.substring(1)}';
}
