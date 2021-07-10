import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/settings/settings_screen.dart';

class HomeNavigatorScreen extends StatelessWidget {
  static const String routeName = '/';
  HomeNavigatorScreen({Key? key}) : super(key: key);

  static const _navBarItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      label: 'Расписание',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_applications_rounded),
      label: 'Настройки',
    ),
  ];

  /// List of main screens
  static final _bodyItems = [
    ScheduleScreen(),
    SettingsScreen(),
  ];

  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeNavigatorBloc, HomeNavigatorState>(
        builder: (context, state) {
          if (state is SchedulePage) {
            _selectedPageIndex = 0;
          } else if (state is SettingsPage) {
            _selectedPageIndex = 1;
          }
          return _bodyItems.elementAt(_selectedPageIndex);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (int page) {
          switch (page) {
            case 0:
              BlocProvider.of<HomeNavigatorBloc>(context)
                  .add(ChangeScreen(ScheduleScreen.routeName));
              break;
            case 1:
              BlocProvider.of<HomeNavigatorBloc>(context)
                  .add(ChangeScreen(SettingsScreen.routeName));
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
