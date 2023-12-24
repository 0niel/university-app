import 'package:flutter/material.dart';

import 'calendar.dart';

class EventsPageView extends StatelessWidget {
  const EventsPageView({
    Key? key,
    required this.controller,
    required this.itemBuilder,
  }) : super(key: key);

  final PageController controller;

  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      // onPageChanged: (value) {
      //   setState(() {
      //     // if the pages are moved by swipes
      //     if ((value - _selectedPage).abs() == 1) {
      //       if (value > _selectedPage) {
      //         _selectedDay = _selectedDay.add(const Duration(days: 1));
      //       } else if (value < _selectedPage) {
      //         _selectedDay = _selectedDay.subtract(const Duration(days: 1));
      //       }
      //       final int currentNewWeek =
      //           CalendarUtils.getCurrentWeek(mCurrentDate: _selectedDay);
      //       _selectedWeek = currentNewWeek;
      //     }
      //     _focusedDay = Calendar.isDayInAvailableRange(_selectedDay);
      //     _selectedPage = value;
      //   });
      // },
      itemCount:
          Calendar.lastCalendarDay.difference(Calendar.firstCalendarDay).inDays,
      // itemBuilder: (context, index) {
      //   final DateTime lessonDay = _firstCalendarDay.add(Duration(days: index));
      //   final int week = CalendarUtils.getCurrentWeek(mCurrentDate: lessonDay);
      //   final int lessonIndex =
      //       week >= 1 && week <= CalendarUtils.kMaxWeekInSemester
      //           ? lessonDay.weekday - 1
      //           : 6;
      //   return _buildPageViewContent(context, lessonIndex, week);
      // },
      itemBuilder: itemBuilder,
    );
  }
}
