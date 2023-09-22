import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rtu_mirea_app/presentation/app_notifier.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          context.pop();
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
                          context.pop();
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
            ListTile(
              title: Text("Уведомления", style: AppTextStyle.body),
              leading: Icon(Icons.notifications, color: AppTheme.colors.active),
              onTap: () {
                context.go("/profile/settings/notifications");
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
