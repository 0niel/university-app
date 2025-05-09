import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Настройки")),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            const SizedBox(height: 24),
            ListTile(
              title: Text("Тема", style: AppTextStyle.body),
              leading: Icon(FontAwesomeIcons.palette, color: Theme.of(context).extension<AppColors>()!.active),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => SimpleDialog(
                        title: Text("Выбор темы", style: AppTextStyle.titleS),
                        contentPadding: const EdgeInsets.all(16),
                        backgroundColor: Theme.of(context).extension<AppColors>()!.background02,
                        elevation: 0,
                        children: [
                          _ListTileThemeItem(
                            title: "Светлая",
                            trailing:
                                AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                                    ? Icon(Icons.check, color: Theme.of(context).extension<AppColors>()!.active)
                                    : null,
                            onTap: () {
                              AdaptiveTheme.of(context).setLight();
                              context.pop();
                            },
                          ),
                          const SizedBox(height: 8),
                          _ListTileThemeItem(
                            title: "Тёмная",
                            trailing:
                                AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                                    ? Icon(Icons.check, color: Theme.of(context).extension<AppColors>()!.active)
                                    : null,
                            onTap: () {
                              AdaptiveTheme.of(context).setDark();
                              context.pop();
                            },
                          ),
                          const SizedBox(height: 8),
                          _ListTileThemeItem(
                            title: "Как в системе",
                            trailing:
                                AdaptiveTheme.of(context).mode == AdaptiveThemeMode.system
                                    ? Icon(Icons.check, color: Theme.of(context).extension<AppColors>()!.active)
                                    : null,
                            onTap: () {
                              AdaptiveTheme.of(context).setSystem();
                              context.pop();
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text("Уведомления", style: AppTextStyle.body),
              leading: Icon(Icons.notifications, color: Theme.of(context).extension<AppColors>()!.active),
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

class _ListTileThemeItem extends StatelessWidget {
  const _ListTileThemeItem({required this.title, required this.onTap, this.trailing});

  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.active)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      dense: true,
      onTap: () {
        onTap();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      trailing: trailing,
    );
  }
}
