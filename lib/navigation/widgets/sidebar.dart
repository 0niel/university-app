import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SidebarNavButton(
              isSelected: currentIndex == 0,
              title: "Новости",
              icon: const Icon(Icons.library_books_rounded),
              onClick: () => onClick(0),
            ),
            SidebarNavButton(
              isSelected: currentIndex == 1,
              title: "Расписание",
              icon: const Icon(Icons.calendar_today_rounded),
              onClick: () => onClick(1),
            ),
            SidebarNavButton(
              isSelected: currentIndex == 2,
              title: "Сервисы",
              icon: const Icon(Icons.widgets_rounded),
              onClick: () => onClick(2),
            ),
            SidebarNavButton(
              isSelected: currentIndex == 3,
              title: "Профиль",
              icon: const Icon(Icons.person),
              onClick: () => onClick(3),
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarNavButton extends StatelessWidget {
  const SidebarNavButton({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  final bool isSelected;
  final String title;
  final Widget icon;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: isSelected
          ? BoxDecoration(
              color: AppTheme.colorsOf(context).colorful03,
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: TextButton(
        onPressed: onClick,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          foregroundColor: isSelected ? AppTheme.colorsOf(context).background01 : AppTheme.colorsOf(context).active,
        ),
        child: Row(
          children: [
            Theme(
              data: ThemeData(
                iconTheme: IconThemeData(
                  color: AppTheme.colorsOf(context).active,
                ),
              ),
              child: icon,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyle.buttonS.copyWith(color: AppTheme.colorsOf(context).active),
            ),
          ],
        ),
      ),
    );
  }
}
