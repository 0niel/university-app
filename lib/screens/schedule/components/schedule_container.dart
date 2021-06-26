import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/constants.dart';
import 'package:rtu_mirea_app/models/lesson.dart';

import 'lessons.dart';

class ScheduleContainer extends StatelessWidget {
  final List<Lesson> _lessons;

  const ScheduleContainer(this._lessons);

  List<Widget> _getScheduleList() {
    List<Widget> schedule = [];

    if (_lessons.length == 0 || _lessons == null) {
      // todo: какое-то инофрмационное поле об отстутствии пар
      schedule.add(Container());
    } else {
      for (int i = 0; i < _lessons.length; i++) {
        schedule.add(LessonsWidget(_lessons[i]));
      }
    }

    return schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Сегодня",
                style: TextStyle(
                  fontSize: 28,
                  color: kTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ..._getScheduleList(),
            ],
          ),
        ),
      ),
    );
  }
}