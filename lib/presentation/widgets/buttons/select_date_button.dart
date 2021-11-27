import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:intl/intl.dart';

class SelectDateButton extends StatefulWidget {
  const SelectDateButton({
    Key? key,
    required this.onDateSelected,
    required this.isRange,
    this.firstDate,
    this.lastDate,
    this.text,
  }) : super(key: key);

  final Function(DateTime date) onDateSelected;
  final bool isRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? text;

  @override
  _SelectDateButtonState createState() => _SelectDateButtonState();
}

class _SelectDateButtonState extends State<SelectDateButton> {
  late String _selectedTextDate;

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      locale: const Locale('ru', 'RU'),
      initialDate: DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2019),
      lastDate: widget.lastDate ?? DateTime(2022),
    );
    if (d != null) {
      setState(() {
        _selectedTextDate = DateFormat.yMMMMd("ru_RU").format(d);
        widget.onDateSelected(d);
      });
    }
  }

  @override
  void initState() {
    _selectedTextDate = widget.text ?? 'Выберите дату';
    super.initState();
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
      onPressed: () => _showDatePicker(context),
    );
  }
}
