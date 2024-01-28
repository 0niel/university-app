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
      itemCount: Calendar.lastCalendarDay.difference(Calendar.firstCalendarDay).inDays,
      itemBuilder: itemBuilder,
    );
  }
}
