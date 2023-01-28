import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/icon_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/settings_button.dart';
import 'package:rtu_mirea_app/presentation/core/routes/routes.gr.dart';

import '../../bloc/announces_bloc/announces_bloc.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../widgets/buttons/text_outlined_button.dart';
import '../../widgets/container_label.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
      ),
      backgroundColor: AppTheme.colors.background01,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    // return const _InitialProfileStatePage();

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
                                backgroundImage: Image.network(
                                        'https://lk.mirea.ru${profileState.user.photoUrl}')
                                    .image,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 13, bottom: 4),
                                child: Text(
                                  '${profileState.user.name} ${profileState.user.lastName}',
                                  style: AppTextStyle.h5,
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    AppTheme.colors.gradient07.createShader(
                                  Rect.fromLTWH(
                                      0, 0, bounds.width, bounds.height),
                                ),
                                child: Text(
                                  profileState.user.login,
                                  style: AppTextStyle.titleS,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextOutlinedButton(
                                      width: 160,
                                      content: "Профиль",
                                      onPressed: () => context.router.push(
                                        ProfileDetailRoute(
                                            user: profileState.user),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 146,
                                      height: 45,
                                      child: SocialIconButton(
                                        assetImage: const AssetImage(
                                            'assets/icons/gerb.ico'),
                                        onClick: () {
                                          launchUrl(Uri.parse(
                                            profileState.user.authShortlink !=
                                                    null
                                                ? "https://lk.mirea.ru/auth/link/?url=${profileState.user.authShortlink!}"
                                                : "https://lk.mirea.ru/auth",
                                          ));
                                        },
                                        text: "Вход в ЛКС",
                                      ),
                                    ),
                                  ]),

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
                                    context.router.push(
                                      const ProfileAnnouncesRoute(),
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
                                onClick: () => context.router
                                    .push(const ProfileLectrosRoute()),
                              ),
                              const SizedBox(height: 8),
                              SettingsButton(
                                text: 'Посещения',
                                icon: Icons.access_time_rounded,
                                onClick: () => context.router
                                    .push(const ProfileAttendanceRoute()),
                              ),
                              const SizedBox(height: 8),
                              SettingsButton(
                                  text: 'Зачетная книжка',
                                  icon: Icons.menu_book_rounded,
                                  onClick: () => context.router
                                      .push(const ProfileScoresRoute())),
                              const SizedBox(height: 8),
                              SettingsButton(
                                text: 'О приложении',
                                icon: Icons.apps_rounded,
                                onClick: () =>
                                    context.router.push(const AboutAppRoute()),
                              ),
                              const SizedBox(height: 8),
                              SettingsButton(
                                  text: 'Настройки',
                                  icon: Icons.settings_rounded,
                                  onClick: () => {
                                        context.router
                                            .push(const ProfileSettingsRoute()),
                                      }),
                              const SizedBox(height: 8),
                              ColorfulButton(
                                  text: 'Выйти',
                                  onClick: () => context
                                      .read<AuthBloc>()
                                      .add(AuthLogOut()),
                                  backgroundColor: AppTheme.colors.colorful07),
                            ],
                          );
                        } else if (profileState is ProfileLoading) {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: const Center(
                                  child: CircularProgressIndicator()));
                        }
                        return Container();
                      });
                    } else if (state is LogInError ||
                        state is AuthUnauthorized) {
                      return const _InitialProfileStatePage();
                    } else if (state is AuthUnknown) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InitialProfileStatePage extends StatelessWidget {
  const _InitialProfileStatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColorfulButton(
            text: 'Войти',
            onClick: () {
              // Мы используем oauth2 для авторизации, поэтому
              // вместо того, чтобы открывать страницу с логином и паролем,
              // мы просто вызываем событие авторизации, которое откроет
              // страницу авторизации в браузере.
              context.read<AuthBloc>().add(
                  const AuthLogInEvent(login: 'login', password: 'password'));

              // Страница с вводом логина и пароля:
              // context.router.push(const LoginRoute());

              // Страница с ошибкой:
              // showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   backgroundColor: Colors.transparent,
              //   builder: (context) => const BottomErrorInfo(),
              // );
            },
            backgroundColor: AppTheme.colors.colorful03),
        const SizedBox(height: 8),
        SettingsButton(
          text: 'О приложении',
          icon: Icons.apps_rounded,
          onClick: () => context.router.push(const AboutAppRoute()),
        ),
        const SizedBox(height: 8),
        SettingsButton(
          text: 'Настройки',
          icon: Icons.settings_rounded,
          onClick: () => context.router.push(const ProfileSettingsRoute()),
        ),
      ],
    );
  }
}
