import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/auth/auth_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/badged_container.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/settings_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/container_label.dart';

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
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileAuthenticated) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 68,
                      backgroundImage: Image.network(
                              'https://lk.mirea.ru' + state.user.photoUrl)
                          .image,
                    ),
                    Padding(
                      child: Text(
                        state.user.name + ' ' + state.user.lastName,
                        style: DarkTextTheme.h5,
                      ),
                      padding: const EdgeInsets.only(top: 13, bottom: 4),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          DarkThemeColors.gradient07.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: Text(
                        state.user.login,
                        style: DarkTextTheme.titleS,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xff246bfd),
                          width: 2,
                        ),
                        boxShadow: const [
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
                        children: const [
                          Text(
                            "Просмотр профиля",
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
                    const SizedBox(height: 40),
                    const ContainerLabel(label: "Информация"),
                    const SizedBox(height: 20),
                    SettingsButton(
                        text: 'Уведомления',
                        icon: Icons.message_rounded,
                        onClick: () {}),
                    const SizedBox(height: 8),
                    SettingsButton(
                        text: 'Подразделения',
                        icon: Icons.live_help_rounded,
                        onClick: () {}),
                    const SizedBox(height: 8),
                    SettingsButton(
                        text: 'Преподаватели',
                        icon: Icons.people_alt_rounded,
                        onClick: () {}),
                    const SizedBox(height: 8),
                    SettingsButton(
                        text: 'Посещения',
                        icon: Icons.access_time_rounded,
                        onClick: () {}),
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
                      },
                    ),
                    const SizedBox(height: 8),
                    ColorfulButton(
                        text: 'Выйти',
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()),
                          );
                        },
                        backgroundColor: DarkThemeColors.colorful07),
                  ],
                );
              } else if (state is ProfileUnauthenticated) {
                return Column(
                  children: [
                    ColorfulButton(
                        text: 'Войти',
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()),
                          );
                        },
                        backgroundColor: DarkThemeColors.colorful03),
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
                      },
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
