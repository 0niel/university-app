import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wear/schedule/schedule.dart';
import 'package:wear/schedule/view/schedule_day_picker_dialog.dart';

class ScheduleDayPickerButton extends StatelessWidget {
  const ScheduleDayPickerButton({
    required this.currentDayIndex,
    required this.availableDays,
    super.key,
  });

  final int currentDayIndex;
  final List<DateTime> availableDays;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => unawaited(_selectDay(context)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.borderLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: colors.deactive,
              ),
              const SizedBox(width: 4),
              Text(
                'Дни',
                style: AppText.captionSmall.copyWith(
                  color: colors.deactive,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDay(BuildContext context) async {
    final selectedIndex = await showDialog<int>(
      context: context,
      builder: (_) => ScheduleDayPickerDialog(
        currentDayIndex: currentDayIndex,
        availableDays: availableDays,
      ),
    );
    if (!context.mounted ||
        selectedIndex == null ||
        selectedIndex == currentDayIndex) {
      return;
    }

    context.read<ScheduleCubit>().setCurrentDayIndex(selectedIndex);
    await HapticFeedback.lightImpact();
  }
}
