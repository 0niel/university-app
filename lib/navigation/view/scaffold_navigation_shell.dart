import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';

class ScaffoldNavigationShell extends StatelessWidget {
  const ScaffoldNavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 720;
        final bottomInset = useRail ? 0.0 : AppBottomBar.extentOf(context);
        final body = useRail
            ? Row(
                children: [
                  ScheduleNavBadge(
                    builder: (context, {required hasUnread}) =>
                        AppNavigationRail(
                          currentIndex: navigationShell.currentIndex,
                          onSelected: _setActiveIndex,
                          scheduleBadge: hasUnread,
                        ),
                  ),
                  Expanded(child: navigationShell),
                ],
              )
            : navigationShell;
        final insetBody = useRail
            ? body
            : AppBottomBarViewport(bottomInset: bottomInset, child: body);
        return Scaffold(
          backgroundColor: context.colors.canvas,
          extendBody: true,
          body: insetBody,
          bottomNavigationBar: useRail
              ? null
              : ScheduleNavBadge(
                  builder: (context, {required hasUnread}) =>
                      AppBottomNavigationBar(
                        currentIndex: navigationShell.currentIndex,
                        onSelected: _setActiveIndex,
                        scheduleBadge: hasUnread,
                      ),
                ),
        );
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
