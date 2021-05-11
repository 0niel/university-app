import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/constants.dart';

import 'lessons.dart';

class ScheduleContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      color: Colors.white,
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
              Lessons(),
              Lessons(),
              Lessons(),
              Lessons(),
            ],
          ),
        ),
      ),
    );
  }
}
