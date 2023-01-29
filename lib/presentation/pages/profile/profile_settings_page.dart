import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rtu_mirea_app/presentation/app_notifier.dart';
import 'package:rtu_mirea_app/presentation/core/routes/routes.gr.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

    void rebuildRouterStack(StackRouter router) {
      final tabsRouter = AutoTabsRouter.of(context);

      // Rebuild current router stack
      router.popUntil((route) => false);
      router.replaceAll([const ProfileRoute()]);

      final currentTabIndex = tabsRouter.activeIndex;

      // Rebuild tabs router stack
      for (var i = 0; i < tabsRouter.pageCount; i++) {
        if (i == currentTabIndex) continue;
        final route = tabsRouter.stackRouterOfIndex(i);
        final routeName = route?.current.name;
        if (routeName == null) continue;

        route?.popUntilRoot();
        route?.pushNamed(routeName);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            const SizedBox(height: 24),
            ListTile(
              title: Text("Тема", style: AppTextStyle.body),
              leading: Icon(Icons.brightness_6, color: AppTheme.colors.active),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: Text("Выбор темы", style: AppTextStyle.titleS),
                    contentPadding: const EdgeInsets.all(16),
                    backgroundColor: AppTheme.colors.background02,
                    elevation: 0,
                    children: [
                      ListTile(
                        title: Text("Светлая", style: AppTextStyle.body),
                        onTap: () {
                          context
                              .read<AppNotifier>()
                              .updateTheme(AppThemeType.light);
                          // Close dialog
                          Navigator.pop(context);
                          rebuildRouterStack(router);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        trailing:
                            AppTheme.defaultThemeType == AppThemeType.light
                                ? const Icon(Icons.check)
                                : null,
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: Text("Тёмная", style: AppTextStyle.body),
                        onTap: () {
                          context
                              .read<AppNotifier>()
                              .updateTheme(AppThemeType.dark);
                          // Close dialog
                          Navigator.pop(context);
                          rebuildRouterStack(router);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        trailing: AppTheme.defaultThemeType == AppThemeType.dark
                            ? const Icon(Icons.check)
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
