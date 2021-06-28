import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/components/buttom_navbar.dart';
import 'components/body.dart';

class ScheduleScreen extends StatefulWidget {
  static const String routeName = '/schedule';

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Body(),
      bottomNavigationBar: ButtomNavBar(currentIndex: 0),
    );
  }
}
