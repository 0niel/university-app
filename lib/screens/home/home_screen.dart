import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/screens/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/screens/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  /// список виджетов экранов, которые доступны из нижней навигации
  static final List<Widget> _screensWidgets = <Widget>[
    ScheduleScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedPageIndex) {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screensWidgets.elementAt(_selectedPageIndex),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedPageIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
