import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:unicons/unicons.dart';

import '../../routes/router.gr.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        NewsRouter(),
        DashboardRouter(),
      ],
      duration: const Duration(milliseconds: 400),
      builder: (context, child, animation) {
        final tabsRouter = context.tabsRouter;
        return Scaffold(
          body: child,
          bottomNavigationBar: _BottomNavigationBar(tabsRouter: tabsRouter),
        );
      },
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({Key? key, required this.tabsRouter})
      : super(key: key);

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    return NinjaBottomNavigationBar(
      activeItemColor: AppTheme.theme.colorScheme.secondary,
      itemColor: const Color(0xFFB8B8B8),
      initialIndex: tabsRouter.activeIndex,
      items: [
        NinjaBottomNavigationBarItem(
          title: 'Новости',
          icon: UniconsLine.newspaper,
          onPressed: tabsRouter.setActiveIndex,
        ),
        NinjaBottomNavigationBarItem(
          title: 'Расписание',
          icon: UniconsLine.calender,
          onPressed: tabsRouter.setActiveIndex,
        ),
        NinjaBottomNavigationBarItem(
          title: 'Карта',
          icon: UniconsLine.map_pin_alt,
          onPressed: tabsRouter.setActiveIndex,
        ),
        NinjaBottomNavigationBarItem(
          title: 'Сервисы',
          icon: UniconsLine.layer_group,
          onPressed: tabsRouter.setActiveIndex,
        ),
        NinjaBottomNavigationBarItem(
          title: 'Профиль',
          icon: UniconsLine.user_circle,
          onPressed: tabsRouter.setActiveIndex,
        ),
      ],
    );
  }
}
