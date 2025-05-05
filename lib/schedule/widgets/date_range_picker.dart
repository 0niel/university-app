import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateRangePicker extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final List<DateTime> selectedDates;
  final bool Function(DateTime)? selectableDayPredicate;

  const DateRangePicker({super.key, this.initialDateRange, this.selectedDates = const [], this.selectableDayPredicate});

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late List<DateTime> _selectedDates;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDateRange?.start ?? DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 365));
    _lastDay = DateTime.now().add(const Duration(days: 365 * 2));
    _selectedDates = List<DateTime>.from(widget.selectedDates);
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Выберите даты', style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedDates.clear();
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Очистить'),
                style: TextButton.styleFrom(foregroundColor: colors.error),
              ),
            ],
          ),
        ),
        const Divider(),
        TableCalendar<dynamic>(
          firstDay: _firstDay,
          lastDay: _lastDay,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) {
            return _selectedDates.any((element) => isSameDay(element, day));
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              final DateTime normalizedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

              if (_selectedDates.any((date) => isSameDay(date, normalizedDay))) {
                _selectedDates.removeWhere((date) => isSameDay(date, normalizedDay));
              } else {
                _selectedDates.add(normalizedDay);
              }

              // Сортируем даты
              _selectedDates.sort();

              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            markersMaxCount: 0,
            // Стилизация выбранного дня
            selectedDecoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
            // Стилизация сегодняшнего дня
            todayDecoration: BoxDecoration(color: colors.primary.withOpacity(0.3), shape: BoxShape.circle),
            selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            // Стилизация дней вне месяца
            outsideDaysVisible: false,
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            formatButtonDecoration: BoxDecoration(color: colors.background03, borderRadius: BorderRadius.circular(12)),
            formatButtonTextStyle: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
            headerPadding: const EdgeInsets.symmetric(vertical: 4),
          ),
          availableCalendarFormats: const {
            CalendarFormat.month: 'Месяц',
            CalendarFormat.twoWeeks: '2 недели',
            CalendarFormat.week: 'Неделя',
          },
          locale: 'ru',
          enabledDayPredicate: widget.selectableDayPredicate,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Выбрано дат: ${_selectedDates.length}',
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w500),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedDates);
                },
                child: const Text('Применить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
