import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDateButton extends StatefulWidget {
  const SelectDateButton({
    required this.onDateSelected,
    required this.isRange,
    super.key,
    this.firstDate,
    this.lastDate,
    this.text,
  });

  final Function(DateTime date) onDateSelected;
  final bool isRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? text;

  @override
  State<SelectDateButton> createState() => _SelectDateButtonState();
}

class _SelectDateButtonState extends State<SelectDateButton> {
  late String _selectedTextDate;

  Future<void> _showDatePicker(BuildContext context) async {
    final d = await showDatePicker(
      context: context,
      locale: const Locale('ru', 'RU'),
      initialDate: DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2019),
      lastDate: widget.lastDate ?? DateTime(2022),
    );
    if (d != null) {
      setState(() {
        _selectedTextDate = DateFormat.yMMMMd('ru_RU').format(d);
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
              style: AppTextStyle.captionL,
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
