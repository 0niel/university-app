import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarFormatToggle extends StatelessWidget {
  final CalendarFormat currentFormat;
  final ValueChanged<CalendarFormat> onFormatChanged;

  const CalendarFormatToggle({super.key, required this.currentFormat, required this.onFormatChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: colors.background03.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _buildFormatButton(context, CalendarFormat.week, 'Неделя', HugeIcons.strokeRoundedCalendar01),
          SizedBox(width: 8),
          _buildFormatButton(context, CalendarFormat.twoWeeks, '2 недели', HugeIcons.strokeRoundedCalendar02),
          SizedBox(width: 8),
          _buildFormatButton(context, CalendarFormat.month, 'Месяц', HugeIcons.strokeRoundedCalendar03),
        ],
      ),
    );
  }

  Widget _buildFormatButton(BuildContext context, CalendarFormat format, String label, IconData icon) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isSelected = currentFormat == format;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? colors.background02 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow:
              isSelected ? [BoxShadow(color: colors.primary.withOpacity(0.1), blurRadius: 4, spreadRadius: 0)] : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onFormatChanged(format),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(icon: icon, size: 16, color: isSelected ? colors.primary : colors.deactive),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: AppTextStyle.captionL.copyWith(
                          color: isSelected ? colors.primary : colors.deactive,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
