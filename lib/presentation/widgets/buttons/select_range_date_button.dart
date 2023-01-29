import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

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
  State<SelectRangeDateButton> createState() => _SelectRangeDateButtonState();
}

class _SelectRangeDateButtonState extends State<SelectRangeDateButton> {
  late String _selectedTextDate;
  late PickerDateRange? _initialRange;

  @override
  void initState() {
    _selectedTextDate = widget.text ?? 'Выберите даты';
    _initialRange = widget.initialRange;
    super.initState();
  }

  void _formatDatesRange(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      final firstDate =
          DateFormat('dd.MM.yyyy').format(args.value.startDate).toString();
      final lastDate = DateFormat('dd.MM.yyyy')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();

      _selectedTextDate = "с $firstDate по $lastDate";
    });
  }

  void _onSelectionChanged(DateTime? startDate, DateTime? endDate) {
    if (startDate != null && endDate != null) {
      widget.onDateSelected([startDate, endDate]);
      _initialRange = PickerDateRange(startDate, endDate);
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
            side: BorderSide(color: AppTheme.colors.deactive),
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
                color: AppTheme.colors.deactive,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppTheme.colors.deactive,
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
                monthViewSettings: DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    backgroundColor: AppTheme.colors.background02,
                    textStyle: AppTextStyle.bodyBold.copyWith(
                      color: AppTheme.colors.deactive,
                    ),
                  ),
                ),
                view: DateRangePickerView.month,
                headerHeight: 60,
                rangeSelectionColor:
                    AppTheme.colors.colorful03.withOpacity(0.7),
                headerStyle: DateRangePickerHeaderStyle(
                  textStyle: AppTextStyle.titleS
                      .copyWith(color: AppTheme.colors.active),
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: AppTextStyle.body.copyWith(
                    color: AppTheme.colors.deactive,
                  ),
                  todayTextStyle: AppTextStyle.body
                      .copyWith(color: AppTheme.colors.colorful03),
                ),
                selectionTextStyle: AppTextStyle.bodyBold,
                rangeTextStyle: AppTextStyle.body,
                todayHighlightColor: AppTheme.colors.colorful03,
                startRangeSelectionColor: AppTheme.colors.colorful03,
                endRangeSelectionColor: AppTheme.colors.colorful03,
                selectionColor: AppTheme.colors.primary,
                toggleDaySelection: true,
                showActionButtons: true,
                initialSelectedRange: _initialRange,
                cancelText: 'ОТМЕНА',
                onCancel: () => Navigator.of(context).pop(),
                onSubmit: (Object? value) {
                  if (value is PickerDateRange) {
                    _onSelectionChanged(value.startDate, value.endDate);
                    Navigator.of(context).pop();
                  }
                },
                backgroundColor: AppTheme.colors.background02,
                showNavigationArrow: true,
                minDate: widget.firstDate,
                maxDate: widget.lastDate,
                onSelectionChanged: _formatDatesRange,
                selectionMode: DateRangePickerSelectionMode.range,
              ),
            ),
          );
        },
      ),
    );
  }
}
