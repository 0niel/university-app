import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/app_cubit/app_cubit.dart';
import 'package:rtu_mirea_app/presentation/core/routes/routes.gr.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AutoRouter.of(context); // <-- this is needed to initialize the router
    return BlocConsumer<AppCubit, AppState>(builder: (context, state) {
      if (state is AppClean) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > tabletBreakpoint) {
              return Scaffold(
                appBar: AppBar(title: const Text('RTU Mirea App')),
                body: AutoTabsRouter(
                  routes: const [
                    NewsRouter(),
                    ScheduleRouter(),
                    MapRoute(),
                    ProfileRouter()
                  ],
                  builder: (context, child, animation) {
                    return Row(
                      children: [
                        _buildSidebar(context),
                        Expanded(child: child),
                      ],
                    );
                  },
                ),
              );
            } else {
              return AutoTabsScaffold(
                routes: const [
                  NewsRouter(),
                  ScheduleRouter(),
                  MapRoute(),
                  ProfileRouter()
                ],
                navigatorObservers: () => [
                  HeroController(),
                ],
                bottomNavigationBuilder: (context, tabsRouter) {
                  return AppBottomNavigationBar(
                    index: tabsRouter.activeIndex,
                    onClick: tabsRouter.setActiveIndex,
                  );
                },
              );
            }
          },
        );
      }

      context.read<AppCubit>().checkOnboarding();
      return Container();
    }, listener: (context, state) {
      if (state is AppOnboarding) {
        context.router.replace(const OnBoardingRoute());
      }
    });
  }

  Widget _buildSidebar(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);
    return Container(
      width: sidebarWith,
      color: AppTheme.colors.background01,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.library_books_rounded),
            title: Text("Новости", style: AppTextStyle.tab),
            selected: tabsRouter.activeIndex == 0,
            onTap: () => tabsRouter.setActiveIndex(0),
            selectedColor: AppTheme.colors.primary,
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_rounded),
            title: Text("Расписание", style: AppTextStyle.tab),
            selected: tabsRouter.activeIndex == 1,
            onTap: () => tabsRouter.setActiveIndex(1),
            selectedColor: AppTheme.colors.primary,
          ),
          ListTile(
            leading: const Icon(Icons.map_rounded),
            title: Text("Карта", style: AppTextStyle.tab),
            selected: tabsRouter.activeIndex == 2,
            onTap: () => tabsRouter.setActiveIndex(2),
            selectedColor: AppTheme.colors.primary,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text("Профиль", style: AppTextStyle.tab),
            selected: tabsRouter.activeIndex == 3,
            onTap: () => tabsRouter.setActiveIndex(3),
            selectedColor: AppTheme.colors.primary,
          ),
        ],
      ),
    );
  }
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar(
      {Key? key, required this.index, required this.onClick})
      : super(key: key);

  final Function(int) onClick;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colors.background01,
      child: SalomonBottomBar(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        currentIndex: index,
        onTap: onClick,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.library_books_rounded),
            title: const Text("Новости"),
            selectedColor: AppTheme.colors.primary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.calendar_today_rounded),
            title: const Text("Расписание"),
            selectedColor: AppTheme.colors.primary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.map_rounded),
            title: const Text("Карта"),
            selectedColor: AppTheme.colors.primary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Профиль"),
            selectedColor: AppTheme.colors.primary,
          ),
        ],
      ),
    );
  }
}
