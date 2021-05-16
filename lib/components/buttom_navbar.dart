import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/constants.dart';
import 'package:rtu_mirea_app/screens/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/screens/settings/settings_screen.dart';

class ButtonNavBar extends StatefulWidget {
  final int currentIndex;

  const ButtonNavBar({Key key, this.currentIndex}) : super(key: key);

  @override
  _ButtonNavBarState createState() => _ButtonNavBarState(currentIndex);
}

class _ButtonNavBarState extends State<ButtonNavBar> {
  // current navigation index
  int _currentIndex;

  _ButtonNavBarState(this._currentIndex);

  // navigation bar click listener
  void _onItemTapped(int index) {
    if (index != this._currentIndex) {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, ScheduleScreen.routeName);
          break;
        case 1:
          Navigator.pushNamed(context, SettingsScreen.routeName);
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
      selectedItemColor: kPrimaryColor,
      onTap: _onItemTapped,
    );
  }
}
