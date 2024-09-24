import 'package:flutter/material.dart';

import 'calendar/table_calendar.dart';

class EventsPageView extends StatelessWidget {
  const EventsPageView({
    super.key,
    required this.controller,
    required this.itemBuilder,
  });

  final PageController controller;

  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: Calendar.lastCalendarDay.difference(Calendar.firstCalendarDay).inDays,
      itemBuilder: itemBuilder,
    );
  }
}
