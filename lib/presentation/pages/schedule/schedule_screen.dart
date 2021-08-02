import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'widgets/schedule_page_view.dart';

class ScheduleScreen extends StatelessWidget {
  static const String routeName = '/schedule';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Расписание',
          style: DarkTextTheme.title,
        ),
      ),
      body: SafeArea(
        child: SchedulePageView(),
      ),
    );
  }
}
