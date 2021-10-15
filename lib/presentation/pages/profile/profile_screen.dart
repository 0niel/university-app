import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/settings_button.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: create forum login
              // CircleAvatar(
              //   radius: 68,
              //   backgroundImage: Image.network(
              //           'https://avatars.githubusercontent.com/u/51058739?s=300&v=4')
              //       .image,
              // ),
              // Padding(
              //   child: Text(
              //     "Oniel",
              //     style: DarkTextTheme.h4,
              //   ),
              //   padding: EdgeInsets.only(top: 13, bottom: 4),
              // ),
              // ShaderMask(
              //   shaderCallback: (bounds) =>
              //       DarkThemeColors.gradient07.createShader(
              //     Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              //   ),
              //   child: Text(
              //     "Уровень доверия 1",
              //     style: DarkTextTheme.titleS,
              //   ),
              // ),
              // SizedBox(height: 12),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(24),
              //     border: Border.all(
              //       color: Color(0xff246bfd),
              //       width: 2,
              //     ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color(0x7f000000),
              //         blurRadius: 16,
              //         offset: Offset(0, 8),
              //       ),
              //     ],
              //   ),
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 20,
              //     vertical: 8,
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text(
              //         "Редактировать",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 14,
              //           fontFamily: "Inter",
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 40),
              // SettingsButton('Мой профиль', Icons.manage_accounts, () {}),
              // SettingsButton('Создать учебную группу', Icons.group_add, () {}),
              // SettingsButton('Поделиться профилем', Icons.ios_share, () {}),
              Text('Тут скоро будет ваш профиль',
                  style: DarkTextTheme.bodyBold),
              const SizedBox(height: 8),
              SettingsButton(
                  text: 'О приложении',
                  icon: Icons.apps_rounded,
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutAppPage()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
