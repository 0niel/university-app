import 'dart:io';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unicons/unicons.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({Key? key, required this.index, required this.onClick}) : super(key: key);

  final Function(int) onClick;
  final int index;

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  static final isDesktop = !(Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return DotNavigationBar(
      currentIndex: widget.index,
      onTap: widget.onClick,
      dotIndicatorColor: AppTheme.colors.primary,
      backgroundColor: AppTheme.colorsOf(context).background03,
      borderRadius: 18,
      enablePaddingAnimation: false,
      marginR: const EdgeInsets.only(left: 24, right: 24),
      paddingR: const EdgeInsets.only(bottom: 5, top: 7),
      splashBorderRadius: 50,
      items: [
        DotNavigationBarItem(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedNews,
            color: AppTheme.colorsOf(context).active,
          ),
          selectedColor: AppTheme.colors.primary,
        ),
        DotNavigationBarItem(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedCalendar04,
            color: AppTheme.colorsOf(context).active,
          ),
          selectedColor: AppTheme.colors.primary,
        ),
        DotNavigationBarItem(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedDashboardSquare01,
            color: AppTheme.colorsOf(context).active,
          ),
          selectedColor: AppTheme.colors.primary,
        ),
        DotNavigationBarItem(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedProfile02,
            color: AppTheme.colorsOf(context).active,
          ),
          selectedColor: AppTheme.colors.primary,
        ),
      ],
    );
  }
}
