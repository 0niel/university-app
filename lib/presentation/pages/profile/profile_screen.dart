import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces/announces_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/auth/auth_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_announces_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_detail_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_lectors_page.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/settings_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/text_outlined_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/container_label.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is LogInSuccess) {
                context
                    .read<ProfileBloc>()
                    .add(ProfileGetUserData(state.token));
                return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, profileState) {
                  if (profileState is ProfileLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 68,
                          backgroundImage: Image.network('https://lk.mirea.ru' +
                                  profileState.user.photoUrl)
                              .image,
                        ),
                        Padding(
                          child: Text(
                            profileState.user.name +
                                ' ' +
                                profileState.user.lastName,
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
                            profileState.user.login,
                            style: DarkTextTheme.titleS,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextOutlinedButton(
                            content: "Просмотр профиля",
                            width: 200,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileDetailPage(
                                        user: profileState.user)),
                              );
                            }),
                        const SizedBox(height: 40),
                        const ContainerLabel(label: "Информация"),
                        const SizedBox(height: 20),
                        SettingsButton(
                            text: 'Объявления',
                            icon: Icons.message_rounded,
                            onClick: () {
                              context
                                  .read<AnnouncesBloc>()
                                  .add(LoadAnnounces(token: state.token));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileAnnouncesPage()),
                              );
                            }),
                        // const SizedBox(height: 8),
                        // SettingsButton(
                        //     text: 'Адреса',
                        //     icon: Icons.map_rounded,
                        //     onClick: () {}),
                        const SizedBox(height: 8),
                        SettingsButton(
                            text: 'Преподаватели',
                            icon: Icons.people_alt_rounded,
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileLectrosPage()),
                              );
                            }),
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
                  } else if (profileState is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Container();
                });
              } else if (state is LogInError) {
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
              } else if (state is AuthUnknown) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
