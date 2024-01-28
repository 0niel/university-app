import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class SelectRangeDateButton extends StatefulWidget {
  const SelectRangeDateButton({
    Key? key,
    required this.onDateSelected,
    required this.initialValue,
    this.firstDate,
    this.lastDate,
    this.text,
  }) : super(key: key);

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
      final firstDate = DateFormat('dd.MM.yyyy').format(startDate!).toString();
      final lastDate = DateFormat('dd.MM.yyyy').format(endDate!).toString();

      _selectedTextDate = "с $firstDate по $lastDate";
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
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: AppTheme.colorsOf(context).deactive),
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
                color: AppTheme.colorsOf(context).deactive,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppTheme.colorsOf(context).deactive,
            ),
          ],
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: AppTheme.colorsOf(context).background02,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 360),
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.range,
                  selectedDayHighlightColor: AppTheme.colorsOf(context).primary,
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
