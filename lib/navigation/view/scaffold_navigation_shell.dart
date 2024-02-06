import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import '../../presentation/constants.dart';

class ScaffoldNavigationShell extends StatelessWidget {
  const ScaffoldNavigationShell({Key? key, required this.navigationShell}) : super(key: key);

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
            backgroundColor: AppTheme.colorsOf(context).background03,
            body: navigationShell,
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
