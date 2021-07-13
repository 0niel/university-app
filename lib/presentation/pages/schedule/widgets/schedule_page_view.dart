import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/calendar.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/domain/entities/lesson.dart';

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

  AnimatedContainer dayOfWeekButton(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 80),
      padding: EdgeInsets.symmetric(vertical: 8),
      height: 65,
      width: 47.5,
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _daysData[index]['day_of_week'] ?? "",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal,
              color: _currentPage == index
                  ? Colors.white
                  : LightThemeColors.grey400,
              fontSize: 14.5,
            ),
          ),
          Text(
            _daysData[index]['num'] ?? "",
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: _currentPage == index
                    ? Colors.white
                    : LightThemeColors.grey800,
                fontSize: 19,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
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
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Время",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: LightThemeColors.grey400),
            ),
            Padding(padding: EdgeInsets.only(right: 40)),
            Text(
              "Предмет",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: LightThemeColors.grey400),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LessonCard(
              Lesson(
                  timeStart: '09.00',
                  timeEnd: '10:30',
                  name: 'Математический анализ',
                  teacher: 'Зуев А.С.',
                  room: 'А-419',
                  type: 'Практика',
                  weeks: [1, 2, 3]),
            )
          ],
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                "12 неделя",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.arrow_left_outlined, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: LightThemeColors.grey200)),
                    onPrimary: Colors.black.withOpacity(0.25),
                    shadowColor: Colors.transparent,
                    primary: Colors.white,
                  ),
                ),
                Container(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.arrow_right_outlined, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: LightThemeColors.grey200)),
                    onPrimary: Colors.black.withOpacity(0.25),
                    shadowColor: Colors.transparent,
                    primary: Colors.white, // <-- Splash color
                  ),
                )
              ],
            )
          ],
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: LightThemeColors.grey100.withOpacity(0.3),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _daysData.length,
              (index) => dayOfWeekButton(index),
            ),
          ),
        ),
        Divider(height: 25, color: Colors.transparent),
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
