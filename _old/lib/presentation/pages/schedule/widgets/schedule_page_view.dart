import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/utils/utils.dart';
import 'package:rtu_mirea_app/domain/entities/lesson.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/widgets/empty_lesson_card.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'lesson_card.dart';

class SchedulePageView extends StatefulWidget {
  const SchedulePageView({Key? key, required this.schedule}) : super(key: key);

  final Schedule schedule;

  @override
  _SchedulePageViewState createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  static final DateTime _firstCalendarDay = CalendarUtils.getSemesterStart();
  static final DateTime _lastCalendarDay = CalendarUtils.getSemesterLastDay();

  late CalendarFormat _calendarFormat;
  late final PageController _controller;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late int _selectedPage;
  late int _selectedWeek;

  @override
  void initState() {
    super.initState();

    // initialize data
    _focusedDay = _validateDayInRange(DateTime.now());
    _selectedPage = DateTime.now().difference(_firstCalendarDay).inDays;
    _controller = PageController(initialPage: _selectedPage);
    _selectedDay = _validateDayInRange(DateTime.now());
    _selectedWeek = CalendarUtils.getCurrentWeek();
    _calendarFormat = CalendarFormat.values[
        (BlocProvider.of<ScheduleBloc>(context).state as ScheduleLoaded)
            .scheduleSettings
            .calendarFormat];
  }

  /// check if current date is before [_lastCalendarDay] and after [_firstCalendarDay]
  DateTime _validateDayInRange(DateTime newDate) {
    if (newDate.isAfter(_lastCalendarDay)) {
      return _lastCalendarDay;
    } else if (newDate.isBefore(_firstCalendarDay)) {
      return _firstCalendarDay;
    } else {
      return newDate;
    }
  }

  List<List<Lesson>> _getLessonsByWeek(int week, Schedule schedule) {
    List<List<Lesson>> lessonsInWeek = [];
    for (int i = 1; i <= 6; i++) {
      lessonsInWeek.add([]);
      for (var elements in schedule.schedule[i.toString()]!.lessons) {
        for (var lesson in elements) {
          if (lesson.weeks.contains(week)) lessonsInWeek[i - 1].add(lesson);
        }
      }
    }

    return lessonsInWeek;
  }

  Widget _buildEmptyLessons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/images/Saly-18.png'),
          height: 225.0,
        ),
        Text('Пар нет!', style: DarkTextTheme.title),
      ],
    );
  }

  List<Lesson> _getLessonsWithEmpty(List<Lesson> lessons, String group) {
    List<Lesson> formattedLessons = [];
    if (ScheduleUtils.isCollegeGroup(group)) {
      ScheduleUtils.collegeTimesStart.forEach((key, value) {
        bool notEmpty = false;
        for (final lesson in lessons) {
          if (lesson.timeStart == key) {
            formattedLessons.add(lesson);
            notEmpty = true;
          }
        }
        if (notEmpty == false) {
          formattedLessons.add(
            Lesson(
              name: '',
              rooms: const [],
              timeStart: key,
              timeEnd: ScheduleUtils.collegeTimesEnd.keys.toList()[value - 1],
              weeks: const [],
              types: '',
              teachers: const [],
            ),
          );
        }
      });
    } else {
      ScheduleUtils.universityTimesStart.forEach((key, value) {
        bool notEmpty = false;
        for (final lesson in lessons) {
          if (lesson.timeStart == key) {
            formattedLessons.add(lesson);
            notEmpty = true;
          }
        }
        if (notEmpty == false) {
          formattedLessons.add(
            Lesson(
              name: '',
              rooms: const [],
              timeStart: key,
              timeEnd:
                  ScheduleUtils.universityTimesEnd.keys.toList()[value - 1],
              weeks: const [],
              types: '',
              teachers: const [],
            ),
          );
        }
      });
    }
    lessons = formattedLessons;
    return lessons;
  }

  Widget _buildPageViewContent(BuildContext context, int index, int week) {
    if (index == 6) {
      return _buildEmptyLessons();
    } else {
      var lessons = _getLessonsByWeek(week, widget.schedule)[index];

      if (lessons.isEmpty) return _buildEmptyLessons();

      final state = context.read<ScheduleBloc>().state as ScheduleLoaded;
      final ScheduleSettings settings = state.scheduleSettings;
      if (settings.showEmptyLessons) {
        lessons = _getLessonsWithEmpty(lessons, state.activeGroup);
      }

      return ListView.separated(
        itemCount: lessons.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: lessons[i].name.replaceAll(' ', '') != ''
                ? LessonCard(
                    name: lessons[i].name,
                    timeStart: lessons[i].timeStart,
                    timeEnd: lessons[i].timeEnd,
                    room: lessons[i].rooms.join(', '),
                    type: lessons[i].types,
                    teacher: lessons[i].teachers.join(', '),
                  )
                : EmptyLessonCard(
                    timeStart: lessons[i].timeStart,
                    timeEnd: lessons[i].timeEnd,
                  ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          // pageJumpingEnabled: true,
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
                      color: LessonCard.getColorByType(
                          (events[index] as Lesson).types),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
          calendarFormat: _calendarFormat,
          firstDay: _firstCalendarDay,
          lastDay: _lastCalendarDay,
          sixWeekMonthsEnforced: true,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: HeaderStyle(
            formatButtonShowsNext: false,
            titleTextStyle: DarkTextTheme.captionL,
            formatButtonTextStyle: DarkTextTheme.buttonS,
            titleTextFormatter: (DateTime date, dynamic locale) {
              String dateStr = DateFormat.yMMMM(locale).format(date);
              String weekStr = _selectedWeek.toString();
              return '$dateStr\nвыбрана $weekStr неделя';
            },
            formatButtonDecoration: const BoxDecoration(
                border: Border.fromBorderSide(
                    BorderSide(color: DarkThemeColors.deactive)),
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
          ),
          calendarStyle: const CalendarStyle(
            rangeHighlightColor: DarkThemeColors.secondary,
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle:
                DarkTextTheme.body.copyWith(color: DarkThemeColors.deactive),
            weekendStyle: DarkTextTheme.body
                .copyWith(color: DarkThemeColors.deactiveDarker),
          ),
          focusedDay: _focusedDay,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Месяц',
            CalendarFormat.twoWeeks: '2 недели',
            CalendarFormat.week: 'Неделя'
          },
          eventLoader: (day) {
            final int week = CalendarUtils.getCurrentWeek(mCurrentDate: day);
            final int weekday = day.weekday - 1;

            var lessons = _getLessonsByWeek(week, widget.schedule);
            if (weekday == 6) {
              return [];
            } else {
              return lessons[weekday];
            }
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
              final int currentNewWeek =
                  CalendarUtils.getCurrentWeek(mCurrentDate: selectedDay);
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedWeek = currentNewWeek;
                _selectedPage =
                    selectedDay.difference(_firstCalendarDay).inDays;
                _selectedDay = selectedDay;
                _focusedDay = _validateDayInRange(focusedDay);
                _controller.jumpToPage(_selectedPage);
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // update settings in local data
              BlocProvider.of<ScheduleBloc>(context).add(
                  ScheduleUpdateSettingsEvent(calendarFormat: format.index));

              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = _validateDayInRange(focusedDay);
          },
          onHeaderTapped: (date) {
            final currentDate = DateTime.now();
            setState(() {
              _focusedDay = _validateDayInRange(currentDate);
              _selectedDay = currentDate;
              _selectedPage = _selectedDay.difference(_firstCalendarDay).inDays;
              _selectedWeek =
                  CalendarUtils.getCurrentWeek(mCurrentDate: _selectedDay);
              _controller.jumpToPage(_selectedPage);
            });
          },
          onHeaderLongPressed: (date) {
            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
                contentPadding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                backgroundColor: DarkThemeColors.background02,
                title: const Text("Выберите неделю"),
                content: Wrap(
                  spacing: 4.0,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    for (int i = 1; i <= CalendarUtils.kMaxWeekInSemester; i++)
                      ElevatedButton(
                        child: Text(i.toString()),
                        style: ElevatedButton.styleFrom(
                          primary: DarkThemeColors.primary,
                          onPrimary: Colors.white,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          setState(() {
                            if (i == 1) {
                              _selectedDay = CalendarUtils.getDaysInWeek(i)[
                                  CalendarUtils.getSemesterStart().weekday - 1];
                            } else {
                              _selectedDay = CalendarUtils.getDaysInWeek(i)[0];
                            }

                            _selectedDay = _selectedDay;
                            _selectedPage = _selectedDay
                                .difference(_firstCalendarDay)
                                .inDays;
                            _selectedWeek = i;
                            _focusedDay = _validateDayInRange(_selectedDay);
                            _controller.jumpToPage(_selectedPage);
                          });
                        },
                      ),
                  ],
                ));

            // show the dialog
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                });
          },
        ),
        const SizedBox(height: 25),
        Expanded(
          child: PageView.builder(
              controller: _controller,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  // if the pages are moved by swipes
                  if ((value - _selectedPage).abs() == 1) {
                    if (value > _selectedPage) {
                      _selectedDay = _selectedDay.add(const Duration(days: 1));
                    } else if (value < _selectedPage) {
                      _selectedDay =
                          _selectedDay.subtract(const Duration(days: 1));
                    }
                    final int currentNewWeek = CalendarUtils.getCurrentWeek(
                        mCurrentDate: _selectedDay);
                    _selectedWeek = currentNewWeek;
                  }
                  _focusedDay = _validateDayInRange(_selectedDay);
                  _selectedPage = value;
                });
              },
              itemCount: _lastCalendarDay.difference(_firstCalendarDay).inDays,
              itemBuilder: (context, index) {
                final DateTime lessonDay =
                    _firstCalendarDay.add(Duration(days: index));
                final int week =
                    CalendarUtils.getCurrentWeek(mCurrentDate: lessonDay);
                final int lessonIndex =
                    week >= 1 && week <= CalendarUtils.kMaxWeekInSemester
                        ? lessonDay.weekday - 1
                        : 6;
                return _buildPageViewContent(context, lessonIndex, week);
              }),
        )
      ],
    );
  }
}
