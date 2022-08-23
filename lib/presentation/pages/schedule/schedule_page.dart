import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NinjaTableCalendar(
          firstCalendarDay: DateTime(2020, 1, 1),
          lastCalendarDay: DateTime(2023, 1, 1),
        ),
      ),
    );
  }
}
