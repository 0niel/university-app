import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/settings_button.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Профиль',
          style: DarkTextTheme.title,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 68,
                backgroundImage: Image.network(
                        'https://mirea.ninja/user_avatar/mirea.ninja/admin/120/13_2.png')
                    .image,
              ),
              Padding(
                child: Text(
                  "Oniel",
                  style: DarkTextTheme.h4,
                ),
                padding: EdgeInsets.only(top: 13, bottom: 4),
              ),
              ShaderMask(
                shaderCallback: (bounds) =>
                    DarkThemeColors.gradient07.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  "Уровень доверия 4",
                  style: DarkTextTheme.titleS,
                ),
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Color(0xff246bfd),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x7f000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Редактировать",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              SettingsButton('Мой профиль', Icons.manage_accounts, () {}),
              SettingsButton('Создать учебную группу', Icons.group_add, () {}),
              SettingsButton('Поделиться профилем', Icons.ios_share, () {}),
            ],
          ),
        ),
      ),
    );
  }
}
