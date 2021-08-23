import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/map/map_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_screen.dart';

class HomeNavigatorScreen extends StatelessWidget {
  final bool? isFirstRun;

  static const String routeName = '/';
  HomeNavigatorScreen({Key? key, this.isFirstRun}) : super(key: key);

  static const _navBarItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.library_books_rounded),
      label: 'Новости',
      backgroundColor: DarkThemeColors.background03,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      label: 'Расписание',
      backgroundColor: DarkThemeColors.background03,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map_outlined),
      label: 'Карта',
      backgroundColor: DarkThemeColors.background03,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_rounded),
      label: 'Профиль',
      backgroundColor: DarkThemeColors.background03,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool popToFirst = isFirstRun ?? false;
    if (popToFirst) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    return Scaffold(
      body: BlocBuilder<HomeNavigatorBloc, HomeNavigatorState>(
          builder: (context, state) {
        if (state is MapPage) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitDown,
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitDown,
            DeviceOrientation.portraitUp,
          ]);
        }

        return state.screen;
      }),
      bottomNavigationBar: BlocBuilder<HomeNavigatorBloc, HomeNavigatorState>(
          builder: (context, state) {
        return SizedBox(
          height: 70,
          // TODO: make BottomNavigationBar rounded
          // child: ClipRRect(
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(20),
          //     topRight: Radius.circular(20),
          //   ),
          child: BottomNavigationBar(
            items: _navBarItems,
            currentIndex: context
                .select((HomeNavigatorBloc bloc) => bloc.selectedPageIndex),
            onTap: (int page) {
              switch (page) {
                case 0:
                  BlocProvider.of<HomeNavigatorBloc>(context).add(ChangeScreen(
                      routeName: NewsScreen.routeName, pageIndex: page));
                  break;
                case 1:
                  BlocProvider.of<HomeNavigatorBloc>(context).add(ChangeScreen(
                      routeName: ScheduleScreen.routeName, pageIndex: page));
                  break;
                case 2:
                  BlocProvider.of<HomeNavigatorBloc>(context).add(ChangeScreen(
                      routeName: MapScreen.routeName, pageIndex: page));
                  break;
                case 3:
                  BlocProvider.of<HomeNavigatorBloc>(context).add(ChangeScreen(
                      routeName: ProfileScreen.routeName, pageIndex: page));
                  break;
                default:
                  break;
              }
            },
          ),
        );
      }),
    );
  }
}
