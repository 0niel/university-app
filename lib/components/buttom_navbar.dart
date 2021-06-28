import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/constants.dart';
import 'package:rtu_mirea_app/screens/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/screens/settings/settings_screen.dart';

class ButtomNavBar extends StatefulWidget {
  final int currentIndex;

  const ButtomNavBar({Key key, this.currentIndex}) : super(key: key);

  @override
  _ButtomNavBarState createState() => _ButtomNavBarState(currentIndex);
}

class _ButtomNavBarState extends State<ButtomNavBar> {
  // current navigation index
  int _currentIndex;

  _ButtomNavBarState(this._currentIndex);

  // navigation bar click listener
  void _onItemTapped(int index) {
    if (index != this._currentIndex) {
      switch (index) {
        case 0:
          Navigator.popAndPushNamed(context, ScheduleScreen.routeName);
          break;
        case 1:
          Navigator.popAndPushNamed(context, SettingsScreen.routeName);
          break;
        default:
          return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Расписание',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_applications_rounded),
          label: 'Настройки',
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: _onItemTapped,
    );
  }
}
