import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class SelectRangeDateButton extends StatefulWidget {
  const SelectRangeDateButton({
    Key? key,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.text,
    this.initialRange,
  }) : super(key: key);

  final Function(List<DateTime> dates) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final PickerDateRange? initialRange;
  final String? text;

  @override
  _SelectRangeDateButtonState createState() => _SelectRangeDateButtonState();
}

class _SelectRangeDateButtonState extends State<SelectRangeDateButton> {
  late String _selectedTextDate;

  @override
  void initState() {
    _selectedTextDate = widget.text ?? 'Выберите даты';
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      final firstDate =
          DateFormat('dd.MM.yyyy').format(args.value.startDate).toString();
      final lastDate = DateFormat('dd.MM.yyyy')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();

      _selectedTextDate = "с $firstDate по $lastDate";

      if (args.value.startDate != null && args.value.endDate != null) {
        widget.onDateSelected([args.value.startDate, args.value.endDate]);
      }
    });
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
            side: const BorderSide(color: DarkThemeColors.deactive),
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
              style: DarkTextTheme.captionL,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.calendar_today_rounded,
              size: 18,
            ),
          ],
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 360),
              child: SfDateRangePicker(
                monthViewSettings:
                    const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                toggleDaySelection: true,
                showActionButtons: true,
                initialSelectedRange: widget.initialRange,
                cancelText: 'ОТМЕНА',
                //backgroundColor: DarkThemeColors.background02,
                showNavigationArrow: true,
                minDate: widget.firstDate,
                maxDate: widget.lastDate,
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
              ),
            ),
          );
        },
      ),
    );
  }
}
