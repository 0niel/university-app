import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:unicons/unicons.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key? key,
    required this.currentIndex,
    required this.onClick,
  }) : super(key: key);

  final int currentIndex;
  final ValueSetter<int> onClick;

  static final isDesktop = !(Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sidebarWith,
      color: AppTheme.colorsOf(context).background01,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.library_books_rounded),
            title: Text("Новости", style: AppTextStyle.tab),
            selected: currentIndex == 0,
            onTap: () => onClick(0),
            selectedColor: AppTheme.colors.primary,
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_rounded),
            title: Text("Расписание", style: AppTextStyle.tab),
            selected: currentIndex == 1,
            onTap: () => onClick(1),
            selectedColor: AppTheme.colors.primary,
          ),
          ListTile(
            leading: const Icon(Icons.widgets_rounded),
            title: Text("Сервисы", style: AppTextStyle.tab),
            selected: currentIndex == 2,
            onTap: () => onClick(2),
            selectedColor: AppTheme.colors.primary,
          ),
          isDesktop
              ? ListTile(
                  leading: const Icon(UniconsLine.info_circle),
                  title: Text("О приложении", style: AppTextStyle.tab),
                  selected: currentIndex == 3,
                  onTap: () => onClick(3),
                  selectedColor: AppTheme.colors.primary,
                )
              : ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("Профиль", style: AppTextStyle.tab),
                  selected: currentIndex == 3,
                  onTap: () => onClick(3),
                  selectedColor: AppTheme.colors.primary,
                ),
        ],
      ),
    );
  }
}
