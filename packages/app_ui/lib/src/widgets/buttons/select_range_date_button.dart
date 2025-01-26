import 'package:app_ui/app_ui.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectRangeDateButton extends StatefulWidget {
  const SelectRangeDateButton({
    required this.onDateSelected,
    required this.initialValue,
    super.key,
    this.firstDate,
    this.lastDate,
    this.text,
  });

  final Function(List<DateTime> dates) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<DateTime?> initialValue;
  final String? text;

  @override
  State<SelectRangeDateButton> createState() => _SelectRangeDateButtonState();
}

class _SelectRangeDateButtonState extends State<SelectRangeDateButton> {
  late String _selectedTextDate;

  @override
  void initState() {
    _selectedTextDate = widget.text ?? 'Выберите даты';
    super.initState();
  }

  void _updateSelectedText(DateTime? startDate, DateTime? endDate) {
    setState(() {
      final firstDate = DateFormat('dd.MM.yyyy').format(startDate!);
      final lastDate = DateFormat('dd.MM.yyyy').format(endDate!);

      _selectedTextDate = 'с $firstDate по $lastDate';
    });
  }

  void _onSelectionChanged(DateTime? startDate, DateTime? endDate) {
    if (startDate != null && endDate != null) {
      widget.onDateSelected([startDate, endDate]);
      _updateSelectedText(startDate, endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: Theme.of(context).extension<AppColors>()!.deactive,
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedTextDate,
              style: AppTextStyle.captionL.copyWith(
                color: Theme.of(context).extension<AppColors>()!.deactive,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: Theme.of(context).extension<AppColors>()!.deactive,
            ),
          ],
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).extension<AppColors>()!.background02,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 360),
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.range,
                  selectedDayHighlightColor: Theme.of(context).extension<AppColors>()!.primary,
                  dayTextStyle: AppTextStyle.body,
                  controlsTextStyle: AppTextStyle.buttonS,
                  rangeBidirectional: true,
                ),
                value: widget.initialValue,
                onValueChanged: (value) {
                  if (value.length == 2) {
                    _onSelectionChanged(value[0], value[1]);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
