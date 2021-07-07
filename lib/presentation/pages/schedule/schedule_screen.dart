import 'package:flutter/material.dart';
import 'components/app_bar.dart';
import 'components/schedule_page_view.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // stack нужен для скруглённых углов у блока с контентом,
      // который находится ниже appbar
      child: Stack(
        children: [
          ScheduleAppBar(),
          Padding(
            padding: EdgeInsets.only(top: 120),
            // контейнер, в котором расположены кнопки переключения
            // дня недели и page view расписания
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
            child: SchedulePageView(),
          ),
        ],
      ),
    );
  }
}
