import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:rtu_mirea_app/common/utils/calendar_utils.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:university_app_server_api/client.dart';
import "package:collection/collection.dart";

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.pageViewController,
    required this.schedule,
    required this.comments,
    required this.showCommentsIndicators,
    this.calendarFormat = CalendarFormat.week,
    this.canChangeFormat = true,
  });

  final PageController pageViewController;
  final List<SchedulePart> schedule;
  final List<LessonComment> comments;
  final bool showCommentsIndicators;
  final CalendarFormat calendarFormat;
  final bool canChangeFormat;

  static const startingDayOfWeek = StartingDayOfWeek.monday;

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
  late CalendarFormat _calendarFormat;

  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late int _selectedPage;
  late int _selectedWeek;

  /// Page controller for [TableCalendar.onCalendarCreated].
  PageController? _pageController;

  @override
  void initState() {
    super.initState();

    _calendarFormat = widget.calendarFormat;
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
  void didUpdateWidget(covariant Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.calendarFormat != widget.calendarFormat) {
      setState(() {
        _calendarFormat = widget.calendarFormat;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _calculateFocusedPage(CalendarFormat format, DateTime startDay, DateTime focusedDay) {
    switch (format) {
      case CalendarFormat.month:
        return _getMonthCount(startDay, focusedDay);
      case CalendarFormat.twoWeeks:
        return _getTwoWeekCount(startDay, focusedDay);
      case CalendarFormat.week:
        return _getWeekCount(startDay, focusedDay);
      default:
        return _getMonthCount(startDay, focusedDay);
    }
  }

  int _getMonthCount(DateTime first, DateTime last) {
    final yearDif = last.year - first.year;
    final monthDif = last.month - first.month;

    return yearDif * 12 + monthDif;
  }

  int _getWeekCount(DateTime first, DateTime last) {
    return last.difference(_firstDayOfWeek(first)).inDays ~/ 7;
  }

  int _getTwoWeekCount(DateTime first, DateTime last) {
    return last.difference(_firstDayOfWeek(first)).inDays ~/ 14;
  }

  int _getDaysBefore(DateTime firstDay) {
    return (firstDay.weekday + 7 - getWeekdayNumber(Calendar.startingDayOfWeek)) % 7;
  }

  late final ValueNotifier<int> _focusedMonth = ValueNotifier<int>(_focusedDay.month);

  DateTime _firstDayOfWeek(DateTime week) {
    final daysBefore = _getDaysBefore(week);
    return week.subtract(Duration(days: daysBefore));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TableCalendar(
            onCalendarCreated: (controller) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _pageController = controller;
                });
              });
            },
            weekendDays: const [DateTime.sunday],
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return _pageController == null
                    ? const SizedBox.shrink()
                    : CalendarHeader(
                        onHeaderTap: () {
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
                        day: day,
                        week: _selectedWeek,
                        format: _calendarFormat,
                        pageController: _pageController,
                        onMonthChanged: (month) {
                          if (mounted && _pageController != null) {
                            final now = Calendar.getNowWithoutTime();
                            final newFocusedDay = DateTime(now.year, month);
                            final newPage = _calculateFocusedPage(
                              _calendarFormat,
                              Calendar.firstCalendarDay,
                              newFocusedDay,
                            );

                            if (newPage == _pageController?.page?.round()) {
                              return;
                            }

                            _pageController?.animateToPage(
                              newPage,
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ).animate().fadeIn(
                          duration: const Duration(milliseconds: 200),
                        );
              },
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
                          ? Theme.of(context).extension<AppColors>()!.colorful02
                          : (day.weekday == DateTime.sunday
                              ? Theme.of(context).extension<AppColors>()!.deactiveDarker
                              : Theme.of(context).extension<AppColors>()!.active),
                    ),
                  ),
                );
              },
            ),
            calendarFormat: _calendarFormat,
            firstDay: Calendar.firstCalendarDay,
            lastDay: Calendar.lastCalendarDay,
            sixWeekMonthsEnforced: true,
            startingDayOfWeek: Calendar.startingDayOfWeek,
            headerVisible: true,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            calendarStyle: CalendarStyle(
              rangeHighlightColor: Theme.of(context).extension<AppColors>()!.secondary,
              cellAlignment: Alignment.center,
              cellMargin: const EdgeInsets.all(10),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
              weekendStyle: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.deactiveDarker),
            ),
            focusedDay: _focusedDay,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Месяц',
              CalendarFormat.twoWeeks: '2 недели',
              CalendarFormat.week: 'Неделя'
            },
            eventLoader: (day) {
              final events = Calendar.getSchedulePartsByDay(schedule: widget.schedule, day: day)
                  .whereType<LessonSchedulePart>()
                  .toList();
              final eventsByTime = groupBy(events, (LessonSchedulePart e) => e.lessonBells.number);
              return eventsByTime.values.map((e) => e.first).toList();
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
              if (!widget.canChangeFormat) {
                return;
              }
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
          ),
        );
      },
    );
  }
}
