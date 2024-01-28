import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/utils/calendar_utils.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:university_app_server_api/client.dart';

import 'lesson_card.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
    required this.pageViewController,
    required this.schedule,
    required this.comments,
    required this.showCommentsIndicators,
  }) : super(key: key);

  final PageController pageViewController;
  final List<SchedulePart> schedule;
  final List<ScheduleComment> comments;
  final bool showCommentsIndicators;

  static List<SchedulePart> getSchedulePartsByDay({
    required List<SchedulePart> schedule,
    required DateTime day,
  }) {
    return schedule.where((element) {
      return element.dates.firstWhereOrNull((d) => isSameDay(d, day)) != null;
    }).toList();
  }

  static DateTime getNowWithoutTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get page index by date. Used to set up [PageController.initialPage].
  static int getPageIndex(DateTime date) {
    // +1 because first day is 1, not 0
    return date.difference(firstCalendarDay).inDays;
  }

  /// First day of calendar. Used to set up [TableCalendar.firstDay].
  static final DateTime firstCalendarDay = getNowWithoutTime().subtract(
    const Duration(days: 365),
  );

  /// Last day of calendar. Used to set up [TableCalendar.lastDay].
  static final DateTime lastCalendarDay = getNowWithoutTime().add(
    const Duration(days: 365),
  );

  /// Check if the day is in range from [Calendar.firstCalendarDay] to
  /// [Calendar.lastCalendarDay]. If not, return first or last day in range.
  static DateTime getDayInAvailableRange(DateTime newDate) {
    if (newDate.isAfter(Calendar.lastCalendarDay)) {
      return Calendar.firstCalendarDay;
    } else if (newDate.isBefore(Calendar.firstCalendarDay)) {
      return Calendar.lastCalendarDay;
    } else {
      return newDate;
    }
  }

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late int _selectedPage;
  late int _selectedWeek;

  @override
  void initState() {
    super.initState();

    _focusedDay = Calendar.getDayInAvailableRange(Calendar.getNowWithoutTime());

    _selectedPage = Calendar.getPageIndex(_focusedDay);

    widget.pageViewController.addListener(() {
      if (mounted) {
        setState(() {
          if (_selectedPage == widget.pageViewController.page!.round()) {
            return;
          }

          _selectedPage = widget.pageViewController.page!.round();
          _selectedDay = Calendar.firstCalendarDay.add(Duration(days: _selectedPage));
          _selectedWeek = CalendarUtils.getCurrentWeek(mCurrentDate: _selectedDay);
          _focusedDay = Calendar.getDayInAvailableRange(_selectedDay);
        });
      }
    });

    _selectedDay = Calendar.getDayInAvailableRange(Calendar.getNowWithoutTime());
    _selectedWeek = CalendarUtils.getCurrentWeek();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isDesktop = constraints.maxWidth > tabletBreakpoint + 150;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TableCalendar(
            weekendDays: const [DateTime.sunday],
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    events.length,
                    (index) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 0.3),
                      decoration: BoxDecoration(
                        color: LessonCard.getColorByType((events[index] as LessonSchedulePart).lessonType),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
              defaultBuilder: (context, day, focusedDay) {
                final comments = widget.comments.where((element) => isSameDay(element.lessonDate, day)).toList();

                return Center(
                  child: Text(
                    day.day.toString(),
                    style: AppTextStyle.body.copyWith(
                      color: comments.isNotEmpty && widget.showCommentsIndicators
                          ? AppTheme.colorsOf(context).colorful02
                          : (day.weekday == DateTime.sunday
                              ? AppTheme.colorsOf(context).deactiveDarker
                              : AppTheme.colorsOf(context).active),
                    ),
                  ),
                );
              },
            ),
            calendarFormat: isDesktop ? CalendarFormat.month : _calendarFormat,
            firstDay: Calendar.firstCalendarDay,
            lastDay: Calendar.lastCalendarDay,
            sixWeekMonthsEnforced: true,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: !isDesktop,
              formatButtonShowsNext: false,
              titleTextStyle: AppTextStyle.captionL.copyWith(
                color: AppTheme.colorsOf(context).active,
              ),
              formatButtonTextStyle: AppTextStyle.captionL.copyWith(
                color: AppTheme.colorsOf(context).active,
              ),
              titleTextFormatter: (DateTime date, dynamic locale) {
                String dateStr = DateFormat.yMMMM(locale).format(date);
                String weekStr = _selectedWeek.toString();
                return '$dateStr\nвыбрана $weekStr неделя';
              },
              leftChevronIcon: Icon(Icons.chevron_left, color: AppTheme.colorsOf(context).active),
              rightChevronIcon: Icon(Icons.chevron_right, color: AppTheme.colorsOf(context).active),
              formatButtonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.colorsOf(context).deactiveDarker,
                ),
              ),
            ),
            calendarStyle: CalendarStyle(
              rangeHighlightColor: AppTheme.colorsOf(context).secondary,
              cellAlignment: Alignment.center,
              cellMargin: const EdgeInsets.all(10),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppTextStyle.body.copyWith(color: AppTheme.colorsOf(context).deactive),
              weekendStyle: AppTextStyle.body.copyWith(color: AppTheme.colorsOf(context).deactiveDarker),
            ),
            focusedDay: _focusedDay,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Месяц',
              CalendarFormat.twoWeeks: '2 недели',
              CalendarFormat.week: 'Неделя'
            },
            eventLoader: (day) {
              return Calendar.getSchedulePartsByDay(schedule: widget.schedule, day: day)
                  .whereType<LessonSchedulePart>()
                  .toList();
            },
            locale: 'ru_RU',
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                final int currentNewWeek = CalendarUtils.getCurrentWeek(mCurrentDate: selectedDay);
                // Call `setState()` when updating the selected day
                if (mounted) {
                  setState(() {
                    _selectedWeek = currentNewWeek;
                    _selectedDay = selectedDay;
                    _focusedDay = Calendar.getDayInAvailableRange(focusedDay);
                    _selectedPage = Calendar.getPageIndex(_selectedDay);
                  });
                  if (widget.pageViewController.hasClients) {
                    widget.pageViewController.jumpToPage(_selectedPage);
                  }
                }
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = Calendar.getDayInAvailableRange(focusedDay);
            },
            onHeaderTapped: (date) {
              final currentDate = Calendar.getNowWithoutTime();
              if (mounted) {
                setState(() {
                  _focusedDay = Calendar.getDayInAvailableRange(currentDate);
                  _selectedDay = currentDate;
                  _selectedWeek = CalendarUtils.getCurrentWeek(mCurrentDate: _selectedDay);
                  _selectedPage = Calendar.getPageIndex(_selectedDay);
                });
                if (widget.pageViewController.hasClients) {
                  widget.pageViewController.jumpToPage(_selectedPage);
                }
              }
            },
          ),
        );
      },
    );
  }
}
