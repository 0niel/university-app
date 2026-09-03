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
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final month = toBeginningOfSentenceCase(
      DateFormat.MMMM(locale).format(_focused),
    );
    return Column(
      mainAxisSize: .min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: month,
                  style: AppText.section.copyWith(color: colors.ink),
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: DateFormat.y(locale).format(_focused),
                      style: AppText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
            ),
            AppDatePickerNavButton(
              icon: .chevronL,
              semanticsLabel: MaterialLocalizations.of(
                context,
              ).previousMonthTooltip,
              onTap: () => _shiftMonth(-1),
            ),
            const SizedBox(width: 8),
            AppDatePickerNavButton(
              icon: .chevronR,
              semanticsLabel: MaterialLocalizations.of(
                context,
              ).nextMonthTooltip,
              onTap: () => _shiftMonth(1),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TableCalendar(
          firstDay: widget.firstDay,
          lastDay: widget.lastDay,
          focusedDay: _focused,
          headerVisible: false,
          startingDayOfWeek: .monday,
          rowHeight: AppDatePickerDayCell.height + 4,
          daysOfWeekHeight: 22,
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
                DateFormat.E(locale).format(day).toUpperCase(),
                style: AppText.sans(10, .w700, letterSpacingEm: 0.04).copyWith(
                  color: day.weekday >= DateTime.saturday
                      ? colors.muted2
                      : colors.muted,
                ),
              ),
            ),
            defaultBuilder: (context, day, _) => AppDatePickerDayCell(day: day),
            outsideBuilder: (context, day, _) => const SizedBox.shrink(),
            disabledBuilder: (context, day, _) => AppDatePickerDayCell(
              day: day,
              state: AppDatePickerDayState.disabled,
            ),
            todayBuilder: (context, day, _) => AppDatePickerDayCell(
              day: day,
              state: AppDatePickerDayState.today,
            ),
            selectedBuilder: (context, day, _) => AppDatePickerDayCell(
              day: day,
              state: AppDatePickerDayState.selected,
            ),
          ),
        ),
      ],
    );
  }
}
