import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class DateTimeField extends StatelessWidget {
  const DateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.isTime = false,
    this.dateFormat,
    this.icon,
    this.iconColor,
    this.showBorder = true,
    this.borderRadius = 12.0,
    this.isRange = false,
    this.backgroundColor,
    this.height,
  });

  final String label;
  final DateTime? value;
  final Function(DateTime?) onChanged;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool isTime;
  final DateFormat? dateFormat;
  final IconData? icon;
  final Color? iconColor;
  final bool showBorder;
  final double borderRadius;
  final bool isRange;
  final Color? backgroundColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    // Определяем формат даты или времени
    final formatter = dateFormat ?? (isTime ? DateFormat('HH:mm') : DateFormat('dd.MM.yyyy (EEE)', 'ru'));

    final displayText =
        value != null
            ? formatter.format(value!)
            : isTime
            ? 'Выберите время'
            : 'Выберите дату';

    final defaultIcon = isTime ? HugeIcons.strokeRoundedClock01 : HugeIcons.strokeRoundedCalendar01;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label, style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600)),
          ),
        Material(
          color: backgroundColor ?? colors.background01,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () => _showPicker(context),
            child: Container(
              height: height ?? 56,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration:
                  showBorder
                      ? BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: value != null ? colors.primary : colors.background03,
                          width: value != null ? 1.5 : 1,
                        ),
                      )
                      : null,
              child: Row(
                children: [
                  Icon(
                    icon ?? defaultIcon,
                    size: 20,
                    color: iconColor ?? (value != null ? colors.primary : colors.deactive),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      displayText,
                      style: AppTextStyle.body.copyWith(color: value != null ? colors.active : colors.deactive),
                    ),
                  ),
                  if (value != null)
                    IconButton(
                      icon: Icon(Icons.close, size: 18, color: colors.deactive),
                      onPressed: () => onChanged(null),
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tight(const Size(20, 20)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    if (isTime) {
      final initialTime = value != null ? TimeOfDay(hour: value!.hour, minute: value!.minute) : TimeOfDay.now();

      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Theme.of(context).extension<AppColors>()!.background02,
                hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                dayPeriodBorderSide: BorderSide(color: Theme.of(context).extension<AppColors>()!.primary),
                dayPeriodColor: WidgetStateColor.resolveWith(
                  (states) =>
                      states.contains(WidgetState.selected)
                          ? Theme.of(context).extension<AppColors>()!.primary.withOpacity(0.1)
                          : Theme.of(context).extension<AppColors>()!.background02,
                ),
                dayPeriodTextColor: WidgetStateColor.resolveWith(
                  (states) =>
                      states.contains(WidgetState.selected)
                          ? Theme.of(context).extension<AppColors>()!.primary
                          : Theme.of(context).extension<AppColors>()!.active,
                ),
                dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        final now = DateTime.now();
        final newDateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        onChanged(newDateTime);
      }
    } else {
      final initialDate = this.initialDate ?? value ?? DateTime.now();
      final firstDate = this.firstDate ?? DateTime.now().subtract(const Duration(days: 365));
      final lastDate = this.lastDate ?? DateTime.now().add(const Duration(days: 365 * 5));

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        locale: const Locale('ru', 'RU'),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).extension<AppColors>()!.primary,
                onPrimary: Colors.white,
                onSurface: Theme.of(context).extension<AppColors>()!.active,
                surface: Theme.of(context).extension<AppColors>()!.background02,
              ),
              dialogTheme: DialogThemeData(backgroundColor: Theme.of(context).extension<AppColors>()!.background02),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        if (value != null) {
          final newDateTime = DateTime(picked.year, picked.month, picked.day, value!.hour, value!.minute);
          onChanged(newDateTime);
        } else {
          onChanged(picked);
        }
      }
    }
  }
}
