import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rtu_mirea_app/presentation/app_notifier.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:unicons/unicons.dart';

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
            body: Stack(
              children: [
                Consumer<AppNotifier>(
                  builder: (_, value, child) => navigationShell,
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,
                  left: 0,
                  right: 0,
                  child: FloatingNavBar(
                    index: navigationShell.currentIndex,
                    onClick: (index) => _setActiveIndex(index),
                  ),
                ),
              ],
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

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({Key? key, required this.index, required this.onClick})
      : super(key: key);

  final Function(int) onClick;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.colors.background03,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.library_books_rounded,
            title: "Новости",
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.calendar_today_rounded,
            title: "Расписание",
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.widgets_rounded,
            title: "Сервисы",
          ),
          ScaffoldWithNavBar.isDesktop
              ? _buildNavItem(
                  index: 3,
                  icon: UniconsLine.info_circle,
                  title: "О приложении",
                )
              : _buildNavItem(
                  index: 3,
                  icon: Icons.person,
                  title: "Профиль",
                ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    return GestureDetector(
      onTap: () => onClick(index),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: index == this.index
                  ? AppTheme.colors.primary
                  : AppTheme.colors.active.withOpacity(0.5),
            ).animate().fadeIn(duration: const Duration(milliseconds: 150)),
            if (index == this.index)
              ...[
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppTextStyle.tab.copyWith(
                    fontSize: 12,
                    color: index == this.index
                        ? AppTheme.colors.primary
                        : AppTheme.colors.active.withOpacity(0.5),
                  ),
                ),
              ]
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 150))
                  .move(
                      begin: const Offset(0, 8),
                      duration: const Duration(milliseconds: 150)),
          ],
        ),
      ),
    );
  }
}
