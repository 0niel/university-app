import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 24),
              ListTile(
                title: Text("Тема", style: AppTextStyle.body),
                leading: Icon(FontAwesomeIcons.palette,
                    color: AppTheme.colors.active),
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
                        _ListTileThemeItem(
                          title: "Светлая",
                          trailing: AppTheme.defaultThemeType ==
                                  AppThemeType.light
                              ? Icon(Icons.check, color: AppTheme.colors.active)
                              : null,
                          onTap: () {
                            context
                                .read<AppNotifier>()
                                .updateTheme(AppThemeType.light);

                            context.pop();
                          },
                        ),
                        const SizedBox(height: 8),
                        _ListTileThemeItem(
                          title: "Тёмная",
                          trailing: AppTheme.defaultThemeType ==
                                  AppThemeType.dark
                              ? Icon(Icons.check, color: AppTheme.colors.active)
                              : null,
                          onTap: () {
                            context
                                .read<AppNotifier>()
                                .updateTheme(AppThemeType.dark);

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
                leading:
                    Icon(Icons.notifications, color: AppTheme.colors.active),
                onTap: () {
                  context.go("/profile/settings/notifications");
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTileThemeItem extends StatelessWidget {
  const _ListTileThemeItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyle.body.copyWith(
          color: AppTheme.colors.active,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      dense: true,
      onTap: () {
        onTap();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      trailing: trailing,
    );
  }
}
