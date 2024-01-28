import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:unicons/unicons.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({Key? key, required this.index, required this.onClick}) : super(key: key);

  final Function(int) onClick;
  final int index;

  static final isDesktop = !(Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorsOf(context).background01,
      child: SalomonBottomBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          isDesktop
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
