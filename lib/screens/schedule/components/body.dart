import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/screens/schedule/components/app_bar.dart';
import 'schedule_page_view.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ScheduleAppBar(),
          Padding(
            padding: EdgeInsets.only(top: 120),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 120),
            child: Expanded(
              child: SchedulePageView(),
            ),
          ),
        ],
      ),
    );
  }
}
