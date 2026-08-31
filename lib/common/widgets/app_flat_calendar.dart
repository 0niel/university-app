part of 'app_date_picker.dart';

class AppFlatCalendar extends StatefulWidget {
  const AppFlatCalendar({
    required this.firstDay,
    required this.lastDay,
    required this.initialFocus,
    required this.dateSelectedBuilder,
    required this.onDateSelected,
    this.dateEnabledBuilder,
    super.key,
  });

  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime initialFocus;
  final bool Function(DateTime) dateSelectedBuilder;
  final void Function(DateTime) onDateSelected;
  final bool Function(DateTime)? dateEnabledBuilder;

  @override
  State<AppFlatCalendar> createState() => _AppFlatCalendarState();
}

class _AppFlatCalendarState extends State<AppFlatCalendar> {
  late DateTime _focused = _clampDate(
    widget.initialFocus,
    widget.firstDay,
    widget.lastDay,
  );

  void _shiftMonth(int delta) {
    final next = DateTime(_focused.year, _focused.month + delta);
    setState(
      () => _focused = _clampDate(next, widget.firstDay, widget.lastDay),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      spacing: 4,
      mainAxisSize: .min,
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Text(
                toBeginningOfSentenceCase(
                      DateFormat('LLLL yyyy', 'ru').format(_focused),
                    ) ??
                    '',
                style: NinjaText.body.copyWith(
                  color: colors.ink,
                  fontWeight: .w700,
                ),
              ),
            ),
            AppDatePickerNavButton(
              icon: .chevronL,
              onTap: () => _shiftMonth(-1),
            ),
            AppDatePickerNavButton(
              icon: .chevronR,
              onTap: () => _shiftMonth(1),
            ),
          ],
        ),
        TableCalendar(
          firstDay: widget.firstDay,
          lastDay: widget.lastDay,
          focusedDay: _focused,
          headerVisible: false,
          startingDayOfWeek: .monday,
          rowHeight: 44,
          availableGestures: .horizontalSwipe,
          enabledDayPredicate: widget.dateEnabledBuilder,
          selectedDayPredicate: widget.dateSelectedBuilder,
          onPageChanged: (focused) => setState(() => _focused = focused),
          onDaySelected: (selected, focused) {
            setState(() => _focused = focused);
            widget.onDateSelected(_dayOnly(selected));
          },
          calendarBuilders: CalendarBuilders<DateTime>(
            dowBuilder: (context, day) => Center(
              child: Text(
                DateFormat.E('ru').format(day),
                style: NinjaText.helper.copyWith(
                  color: colors.muted,
                ),
              ),
            ),
            defaultBuilder: (context, day, _) =>
                AppDatePickerDayCell(day: day, color: colors.ink),
            outsideBuilder: (context, day, _) => const SizedBox.shrink(),
            disabledBuilder: (context, day, _) =>
                AppDatePickerDayCell(day: day, color: colors.muted),
            todayBuilder: (context, day, _) => AppDatePickerDayCell(
              day: day,
              color: colors.ink,
              background: colors.surface,
            ),
            selectedBuilder: (context, day, _) => AppDatePickerDayCell(
              day: day,
              color: colors.onInk,
              background: colors.ink,
              bold: true,
            ),
          ),
        ),
      ],
    );
  }
}
