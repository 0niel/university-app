import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:app_ui/app_ui.dart';

class ScaffoldNavigationShell extends StatelessWidget {
  const ScaffoldNavigationShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static final isDesktop = !(Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > tabletBreakpoint) {
          return Scaffold(
            body: Row(
              children: [
                Sidebar(
                  currentIndex: navigationShell.currentIndex,
                  onClick: (index) => _setActiveIndex(index),
                ),
                Expanded(
                  child: navigationShell,
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).extension<AppColors>()!.background03,
            body: navigationShell,
            extendBody: true,
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
}
