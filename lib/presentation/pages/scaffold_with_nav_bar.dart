import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rtu_mirea_app/presentation/app_notifier.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:unicons/unicons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../constants.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({Key? key, required this.navigationShell})
      : super(key: key);

  final StatefulNavigationShell navigationShell;

  static final isDesktop = !(Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > tabletBreakpoint) {
          return Scaffold(
            appBar: AppBar(title: const Text('РТУ МИРЭА')),
            body: Row(
              children: [
                _buildSidebar(context),
                Expanded(
                  child: Consumer<AppNotifier>(
                    builder: (context, value, child) => navigationShell,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: AppTheme.colors.background03,
            body: Consumer<AppNotifier>(
              builder: (_, value, child) => navigationShell,
            ),
            bottomNavigationBar: AppBottomNavigationBar(
              index: navigationShell.currentIndex,
              onClick: (index) => _setActiveIndex(index),
            ),
          );
        }
      },
    );
  }

  void _setActiveIndex(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: sidebarWith,
      color: AppTheme.colors.background01,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.library_books_rounded),
            title: Text("Новости", style: AppTextStyle.tab),
            selected: navigationShell.currentIndex == 0,
            onTap: () => _setActiveIndex(0),
            selectedColor: AppTheme.colors.primary,
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_rounded),
            title: Text("Расписание", style: AppTextStyle.tab),
            selected: navigationShell.currentIndex == 1,
            onTap: () => _setActiveIndex(1),
            selectedColor: AppTheme.colors.primary,
          ),
          ListTile(
            leading: const Icon(Icons.widgets_rounded),
            title: Text("Сервисы", style: AppTextStyle.tab),
            selected: navigationShell.currentIndex == 2,
            onTap: () => _setActiveIndex(2),
            selectedColor: AppTheme.colors.primary,
          ),
          isDesktop
              ? ListTile(
                  leading: const Icon(UniconsLine.info_circle),
                  title: Text("О приложении", style: AppTextStyle.tab),
                  selected: navigationShell.currentIndex == 3,
                  onTap: () => _setActiveIndex(3),
                  selectedColor: AppTheme.colors.primary,
                )
              : ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("Профиль", style: AppTextStyle.tab),
                  selected: navigationShell.currentIndex == 3,
                  onTap: () => _setActiveIndex(3),
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
            icon: const Icon(Icons.widgets_rounded),
            title: const Text("Сервисы"),
            selectedColor: AppTheme.colors.primary,
          ),
          ScaffoldWithNavBar.isDesktop
              ? SalomonBottomBarItem(
                  icon: const Icon(UniconsLine.info_circle),
                  title: const Text("О приложении"),
                  selectedColor: AppTheme.colors.primary,
                )
              : SalomonBottomBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text("Профиль"),
                  selectedColor: AppTheme.colors.primary,
                ),
        ],
      ),
    );
  }
}
