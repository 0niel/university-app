import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/calendar.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

import 'lesson_card.dart';

class SchedulePageView extends StatefulWidget {
  @override
  _SchedulePageViewState createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  late int _currentWeek;
  late List<DateTime> _currentWeekDays;
  int _currentPage = 0;

  late List<Map<String, String>> _daysData;

  Widget dayOfWeekButton(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_daysData[index]['day_of_week'] ?? "",
            style: DarkTextTheme.titleS.copyWith(
              color: _currentPage == index
                  ? DarkThemeColors.white
                  : DarkThemeColors.deactive,
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 22.5,
          width: 22.5,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? DarkThemeColors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            _daysData[index]['num'] ?? "",
            textAlign: TextAlign.center,
            style: DarkTextTheme.buttonL.copyWith(
              color: _currentPage == index
                  ? DarkThemeColors.white
                  : DarkThemeColors.deactive,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // initialize data
    _currentWeek = Calendar.getCurrentWeek();
    _currentWeekDays = Calendar.getDaysInWeek(_currentWeek);
    _daysData = [
      {'day_of_week': 'ПН', 'num': _currentWeekDays[0].day.toString()},
      {'day_of_week': 'ВТ', 'num': _currentWeekDays[1].day.toString()},
      {'day_of_week': 'СР', 'num': _currentWeekDays[2].day.toString()},
      {'day_of_week': 'ЧТ', 'num': _currentWeekDays[3].day.toString()},
      {'day_of_week': 'ПТ', 'num': _currentWeekDays[4].day.toString()},
      {'day_of_week': 'СБ', 'num': _currentWeekDays[5].day.toString()},
    ];
  }

  Widget _getPageViewContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          LessonCard(
            name: 'Математический анализ',
            timeStart: '9:00',
            timeEnd: '10:30',
            room: 'А-319',
            type: 'пр',
            teacher: 'Зуев А. С.',
          ),
          SizedBox(height: 8),
          LessonCard(
            name: 'Физика',
            timeStart: '9:00',
            timeEnd: '10:30',
            room: 'А-319',
            type: 'пр',
            teacher: 'Зуев А. С.',
          ),
          SizedBox(height: 8),
          LessonCard(
            name: 'Физика',
            timeStart: '9:00',
            timeEnd: '10:30',
            room: 'А-319',
            type: 'пр',
            teacher: 'Зуев А. С.',
          ),
          SizedBox(height: 8),
          LessonCard(
            name: 'Физика',
            timeStart: '9:00',
            timeEnd: '10:30',
            room: 'А-319',
            type: 'пр',
            teacher: 'Зуев А. С.',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 110,
          margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: DarkThemeColors.background02,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30)
                    .copyWith(bottom: 10, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("12 неделя", style: DarkTextTheme.titleM),
                        Text("Понедельник, 19 июня",
                            style: DarkTextTheme.captionL
                                .copyWith(color: DarkThemeColors.deactive)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _daysData.length,
                  (index) => dayOfWeekButton(index),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
        Expanded(
          child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemCount: 6, // пн-пт
            itemBuilder: (context, index) => _getPageViewContent(context),
          ),
        )
      ],
    );
  }
}
