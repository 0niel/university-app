import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:rtu_mirea_app/models/lesson.dart';
import 'package:rtu_mirea_app/screens/schedule/components/schedule_container.dart';
import 'package:rtu_mirea_app/utils/calendar.dart';
import 'package:rtu_mirea_app/utils/schedule.dart';
import '../../../constants.dart';

class SchedulePageViewScrollPhysics extends ScrollPhysics {
  const SchedulePageViewScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  SchedulePageViewScrollPhysics applyTo(ScrollPhysics ancestor) {
    return SchedulePageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 85,
        stiffness: 80,
        damping: 1,
      );
}

class SchedulePageView extends StatefulWidget {
  @override
  _SchedulePageViewState createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  int currentWeek;
  List<int> currentWeekDays;
  int currentPage = 0;

  List<Map<String, String>> daysData;

  List<Widget> scheduleContainers = [
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  AnimatedContainer dayOfWeekButton({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 80),
      padding: EdgeInsets.symmetric(vertical: 8),
      height: 55,
      width: 47.5,
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: daysData[index]['day_of_week'] + "\n",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: currentPage == index ? Colors.white : Color(0xFFBCC1CD),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: daysData[index]['num'],
              style: TextStyle(
                  color: currentPage == index ? Colors.white : Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // initialize data
    currentWeek = Calendar.getCurrentWeek();
    currentWeekDays = Calendar.getDaysInWeek(currentWeek);
    daysData = [
      {'day_of_week': 'ПН', 'num': currentWeekDays[0].toString()},
      {'day_of_week': 'ВТ', 'num': currentWeekDays[1].toString()},
      {'day_of_week': 'СР', 'num': currentWeekDays[2].toString()},
      {'day_of_week': 'ЧТ', 'num': currentWeekDays[3].toString()},
      {'day_of_week': 'ПТ', 'num': currentWeekDays[4].toString()},
      {'day_of_week': 'СБ', 'num': currentWeekDays[5].toString()},
    ];

    buildScheduleContainers('ИКБО-25-20');
  }

  void buildScheduleContainers(String groupName) {
    Schedule schedule = Schedule();
    schedule.request(groupName).then((_) {
      print('true');
      print(schedule.scheduleData);
      List<Widget> containers = [];
      var scheduleWeekLessons = schedule.getWeekLessons(currentWeek);
      for (int i = 0; i < scheduleWeekLessons.length; i++) {
        List<Lesson> lessons = [];
        for (var lesson in scheduleWeekLessons[i]) {
          lessons.add(lesson);
        }
        containers.add(ScheduleContainer(lessons));
      }

      setState(() {
        scheduleContainers = containers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              daysData.length,
              (index) => dayOfWeekButton(index: index),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: PageView.builder(
              physics: SchedulePageViewScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: 6, // пн-пт
              itemBuilder: (context, index) => scheduleContainers[index],
            ),
          ),
        ),
      ],
    );
  }
}
