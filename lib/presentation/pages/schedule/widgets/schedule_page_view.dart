import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/calendar.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/domain/entities/lesson.dart';

import 'lesson_list_tile.dart';

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
      child: Column(
        children: [
          LessonListTile(),
          Divider(),
          LessonListTile(),
          Divider(),
          LessonListTile(),
          Divider(),
          LessonListTile(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("12 неделя",
                            style: Theme.of(context).textTheme.subtitle1),
                        Text("Понедельник, 19 июня",
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Icon(Icons.arrow_left_outlined,
                              color: Colors.black),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: LightThemeColors.grey200)),
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
                          child: Icon(Icons.arrow_right_outlined,
                              color: Colors.black),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: LightThemeColors.grey200)),
                            onPrimary: Colors.black.withOpacity(0.25),
                            shadowColor: Colors.transparent,
                            primary: Colors.white, // <-- Splash color
                          ),
                        )
                      ],
                    )
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
