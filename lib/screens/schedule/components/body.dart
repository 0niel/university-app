import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/screens/schedule/components/schedule_container.dart';
import 'days_selector.dart';

class SchedulePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);
    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      scrollDirection: Axis.horizontal,
      controller: controller,
      children: <Widget>[
        Center(
          child: ScheduleContainer(),
        ),
        Center(
          child: ScheduleContainer(),
        ),
        Center(
          child: ScheduleContainer(),
        )
      ],
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                DaySelectorTabBar(),
                SchedulePageView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
