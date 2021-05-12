import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/screens/schedule/components/schedule_container.dart';

import '../../../constants.dart';

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

class DaySelectorTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "ПН\n",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBCC1CD),
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: "21",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
        ),
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
