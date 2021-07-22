import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/settings/settings_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/news/homepage.dart';

class HomeNavigatorScreen extends StatelessWidget {
  static const String routeName = '/';

  HomeNavigatorScreen({Key? key}) : super(key: key);

  static const _navBarItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      label: 'Расписание',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Новости',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_applications_rounded),
      label: 'Настройки',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: BlocBuilder<HomeNavigatorBloc, HomeNavigatorState>(
          builder: (context, state) => state.screen),
      bottomNavigationBar: BlocBuilder<HomeNavigatorBloc, HomeNavigatorState>(
          builder: (context, state) {
        return BottomNavigationBar(
          items: _navBarItems,
          currentIndex: context
              .select((HomeNavigatorBloc bloc) => bloc.selectedPageIndex),
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: (int page) {
            switch (page) {
              case 0:
                BlocProvider.of<HomeNavigatorBloc>(context).add(ChangeScreen(
                    routeName: ScheduleScreen.routeName, pageIndex: page));
                break;
              case 1:
                BlocProvider.of<HomeNavigatorBloc>(context).add(ChangeScreen(
                    routeName: HomePage.routeName, pageIndex: page));
                break;
              case 2:
                BlocProvider.of<HomeNavigatorBloc>(context).add(ChangeScreen(
                    routeName: SettingsScreen.routeName, pageIndex: page));
                break;
              default:
                break;
            }
          },
        );
      }),
    );
  }
}
