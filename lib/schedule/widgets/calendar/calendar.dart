import 'package:academic_calendar/academic_calendar.dart';
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

  static List<SchedulePart> getSchedulePartsByDay({required List<SchedulePart> schedule, required DateTime day}) {
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
  static final DateTime firstCalendarDay = getNowWithoutTime().subtract(const Duration(days: 365));

  /// Last day of calendar. Used to set up [TableCalendar.lastDay].
  static final DateTime lastCalendarDay = getNowWithoutTime().add(const Duration(days: 365));

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

  /// Shows week selector modal dialog
  static Future<void> showWeekSelector(BuildContext context, int currentWeek, Function(int) onWeekSelected) async {
    final colors = Theme.of(context).extension<AppColors>()!;
    return BottomModalSheet.show(
      context,
      title: 'Выберите неделю',
      description: 'Быстрый способ перейти к определённой неделе',
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.36,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: CalendarUtils.kMaxWeekInSemester,
          itemBuilder: (context, index) {
            final week = index + 1;
            final isCurrentWeek = week == currentWeek;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isCurrentWeek ? colors.primary : colors.background03,
                borderRadius: BorderRadius.circular(10),
                boxShadow:
                    isCurrentWeek
                        ? [BoxShadow(color: colors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                        : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    onWeekSelected(week);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      '$week',
                      style: AppTextStyle.titleM.copyWith(
                        color: isCurrentWeek ? Colors.white : colors.active,
                        fontWeight: isCurrentWeek ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late int _selectedPage;
  late int _selectedWeek;
  PageController? _pageController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _calendarFormat = widget.calendarFormat;
    _focusedDay = Calendar.getDayInAvailableRange(Calendar.getNowWithoutTime());
    _selectedPage = Calendar.getPageIndex(_focusedDay);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    widget.pageViewController.addListener(() {
      if (mounted) {
        setState(() {
          if (_selectedPage == widget.pageViewController.page!.round()) {
            return;
          }

          _selectedPage = widget.pageViewController.page!.round();
          _selectedDay = Calendar.firstCalendarDay.add(Duration(days: _selectedPage));
          _selectedWeek = getWeek(_selectedDay);
          _focusedDay = Calendar.getDayInAvailableRange(_selectedDay);
        });
      }
    });

    _selectedDay = Calendar.getDayInAvailableRange(Calendar.getNowWithoutTime());
    _selectedWeek = getWeek();
  }

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.calendarFormat != widget.calendarFormat) {
      setState(() {
        _calendarFormat = widget.calendarFormat;
      });

      // Animate format change
      if (_calendarFormat == CalendarFormat.month) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
    final colors = Theme.of(context).extension<AppColors>()!;
    final today = Calendar.getNowWithoutTime();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return TableCalendar(
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
                          _selectedWeek = getWeek(currentDate);
                          _selectedPage = Calendar.getPageIndex(_selectedDay);
                        });
                        if (widget.pageViewController.hasClients) {
                          widget.pageViewController.animateToPage(
                            _selectedPage,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    onHeaderLongPress: () async {
                      _showWeekSelector(context);
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
                    animationController: _animationController,
                  ).animate().fadeIn(duration: const Duration(milliseconds: 200));
            },
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return const SizedBox();
              return _buildDayMarkers(day, events, colors);
            },
            defaultBuilder: (context, day, focusedDay) {
              return _buildDayCell(context, day, today, colors);
            },
            todayBuilder: (context, day, focusedDay) {
              return _buildTodayCell(context, day, colors);
            },
            selectedBuilder: (context, day, focusedDay) {
              return _buildSelectedCell(context, day, today, colors);
            },
            outsideBuilder: (context, day, focusedDay) {
              return _buildOutsideCell(context, day, colors);
            },
            disabledBuilder: (context, day, focusedDay) {
              return _buildDisabledCell(context, day, colors);
            },
            dowBuilder: (context, day) {
              return _buildDayOfWeekCell(context, day, colors);
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
            titleCentered: true,
          ),
          calendarStyle: CalendarStyle(
            rangeHighlightColor: colors.secondary,
            cellAlignment: Alignment.center,
            cellMargin: const EdgeInsets.all(2),
            todayDecoration: BoxDecoration(color: Colors.transparent),
            selectedDecoration: BoxDecoration(color: Colors.transparent),
            outsideDaysVisible: true,
          ),
          daysOfWeekHeight: 32,
          rowHeight: _calendarFormat == CalendarFormat.month ? 36 : 42,
          focusedDay: _focusedDay,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Месяц',
            CalendarFormat.twoWeeks: '2 недели',
            CalendarFormat.week: 'Неделя',
          },
          eventLoader: (day) {
            final events =
                Calendar.getSchedulePartsByDay(
                  schedule: widget.schedule,
                  day: day,
                ).whereType<LessonSchedulePart>().toList();
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
              final int currentNewWeek = getWeek(selectedDay);
              // Call `setState()` when updating the selected day
              if (mounted) {
                setState(() {
                  _selectedWeek = currentNewWeek;
                  _selectedDay = selectedDay;
                  _focusedDay = Calendar.getDayInAvailableRange(focusedDay);
                  _selectedPage = Calendar.getPageIndex(_selectedDay);
                });
                if (widget.pageViewController.hasClients) {
                  widget.pageViewController.animateToPage(
                    _selectedPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            }
          },
          onFormatChanged: (format) {
            if (!widget.canChangeFormat) {
              return;
            }
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });

              if (format == CalendarFormat.month) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = Calendar.getDayInAvailableRange(focusedDay);
          },
        );
      },
    );
  }

  Widget _buildDayOfWeekCell(BuildContext context, DateTime day, AppColors colors) {
    final weekdayNames = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final weekday = (day.weekday - 1) % 7;
    final isWeekend = day.weekday == DateTime.sunday;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Text(
        weekdayNames[weekday],
        textAlign: TextAlign.center,
        style: AppTextStyle.captionL.copyWith(
          color: isWeekend ? colors.deactiveDarker : colors.deactive,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDayMarkers(DateTime day, List events, AppColors colors) {
    return Positioned(
      bottom: 2,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          events.length > 3 ? 3 : events.length,
          (index) => Container(
            width: 4.5,
            height: 4.5,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: LessonCard.getColorByType((events[index] as LessonSchedulePart).lessonType),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime day, DateTime today, AppColors colors) {
    final comments = widget.comments.where((element) => isSameDay(element.lessonDate, day)).toList();
    final isWeekend = day.weekday == DateTime.sunday;
    final hasComments = comments.isNotEmpty && widget.showCommentsIndicators;

    return Container(
      child: Stack(
        children: [
          Center(
            child: Text(
              day.day.toString(),
              style: AppTextStyle.body.copyWith(
                color: hasComments ? colors.colorful02 : (isWeekend ? colors.deactiveDarker : colors.active),
                fontSize: 13,
              ),
            ),
          ),
          if (hasComments)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(color: colors.colorful02, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTodayCell(BuildContext context, DateTime day, AppColors colors) {
    final comments = widget.comments.where((element) => isSameDay(element.lessonDate, day)).toList();
    final hasComments = comments.isNotEmpty && widget.showCommentsIndicators;

    return Stack(
      children: [
        // Light circle background for today
        Center(
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), shape: BoxShape.circle),
          ),
        ),
        Center(
          child: Text(
            day.day.toString(),
            style: AppTextStyle.body.copyWith(
              color: hasComments ? colors.colorful02 : colors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        if (hasComments)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: colors.colorful02, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }

  Widget _buildSelectedCell(BuildContext context, DateTime day, DateTime today, AppColors colors) {
    final comments = widget.comments.where((element) => isSameDay(element.lessonDate, day)).toList();
    final hasComments = comments.isNotEmpty && widget.showCommentsIndicators;
    final isToday = isSameDay(day, today);

    return Stack(
      children: [
        // Small circle behind the text
        Center(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
          ),
        ),
        Center(
          child: Text(
            day.day.toString(),
            style: AppTextStyle.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        if (isToday)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 4,
              height: 2,
              margin: const EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1)),
            ),
          ),
        if (hasComments)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }

  Widget _buildOutsideCell(BuildContext context, DateTime day, AppColors colors) {
    return Center(
      child: Text(
        day.day.toString(),
        style: AppTextStyle.body.copyWith(color: colors.deactive.withOpacity(0.4), fontSize: 13),
      ),
    );
  }

  Widget _buildDisabledCell(BuildContext context, DateTime day, AppColors colors) {
    return Center(
      child: Text(
        day.day.toString(),
        style: AppTextStyle.body.copyWith(
          color: colors.deactive.withOpacity(0.3),
          decoration: TextDecoration.lineThrough,
          decorationColor: colors.deactive.withOpacity(0.3),
          fontSize: 13,
        ),
      ),
    );
  }

  void _showWeekSelector(BuildContext context) async {
    Calendar.showWeekSelector(context, _selectedWeek, (week) {
      final currentDate = Calendar.getNowWithoutTime();
      final newFocusedDay = CalendarUtils.getDaysInWeek(week, currentDate).first;
      final newPage = _calculateFocusedPage(_calendarFormat, Calendar.firstCalendarDay, newFocusedDay);

      if (newPage == _pageController?.page?.round()) {
        return;
      }

      _pageController?.animateToPage(newPage, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

      setState(() {
        _focusedDay = Calendar.getDayInAvailableRange(newFocusedDay);
        _selectedDay = newFocusedDay;
        _selectedWeek = week;
        _selectedPage = newPage;
      });
    });
  }
}
