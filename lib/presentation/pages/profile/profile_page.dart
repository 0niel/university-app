import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/presentation/bloc/notification_preferences/notification_preferences_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/icon_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/settings_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/page_with_theme_consumer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../bloc/announces_bloc/announces_bloc.dart';
import '../../widgets/buttons/text_outlined_button.dart';
import '../../widgets/container_label.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ProfilePage extends PageWithThemeConsumer {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
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
                child: BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    state.maybeMap(
                      unauthorized: (st) {
                        BlocProvider.of<UserBloc>(context)
                            .add(const UserEvent.logIn());
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    return state.map(
                      unauthorized: (_) => const _InitialProfileStatePage(),
                      loading: (_) => ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      logInError: (st) => const _InitialProfileStatePage(),
                      logInSuccess: (st) {
                        BlocProvider.of<NotificationPreferencesBloc>(context)
                            .add(
                          InitialCategoriesPreferencesRequested(
                              group: UserBloc.getActiveStudent(st.user)
                                  .academicGroup),
                        );
                        return _UserLoggedInView(user: st.user);
                      },
                    );
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

class _UserLoggedInView extends StatelessWidget {
  const _UserLoggedInView({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 68,
          backgroundImage:
              Image.network('https://lk.mirea.ru${user.photoUrl}').image,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 13, bottom: 4),
          child: Text(
            '${user.name} ${user.lastName}',
            style: AppTextStyle.h5,
          ),
        ),
        Text(
          user.login,
          style:
              AppTextStyle.titleS.copyWith(color: AppTheme.colors.colorful04),
        ),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextOutlinedButton(
            width: 160,
            content: "Профиль",
            onPressed: () => context.go('/profile/details', extra: user),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 146,
            height: 45,
            child: SocialIconButton.asset(
              assetPath: 'assets/icons/gerb.ico',
              onClick: () {
                launchUrlString("https://lk.mirea.ru/auth",
                    mode: LaunchMode.externalApplication);
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
              context.read<AnnouncesBloc>().add(const LoadAnnounces());
              context.go('/profile/announces');
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
          onClick: () => context.go('/profile/lectors'),
        ),
        const SizedBox(height: 8),
        SettingsButton(
          text: 'Посещения',
          icon: Icons.access_time_rounded,
          onClick: () => context.go('/profile/attendance'),
        ),
        const SizedBox(height: 8),
        SettingsButton(
            text: 'Зачетная книжка',
            icon: Icons.menu_book_rounded,
            onClick: () => context.go('/profile/scores')),
        const SizedBox(height: 8),
        SettingsButton(
          text: 'О приложении',
          icon: Icons.apps_rounded,
          onClick: () => context.go('/profile/about'),
        ),

        // Display only for android devices because of
        // NFC support only for android
        if (Platform.isAndroid) ...[
          const SizedBox(height: 8),
          SettingsButton(
            text: 'NFC пропуск',
            icon: Icons.nfc_rounded,
            onClick: () => context.go('/profile/nfc-pass'),
          ),
        ],

        const SizedBox(height: 8),
        SettingsButton(
            text: 'Настройки',
            icon: Icons.settings_rounded,
            onClick: () => context.go('/profile/settings')),
        const SizedBox(height: 8),
        ColorfulButton(
            text: 'Выйти',
            onClick: () =>
                context.read<UserBloc>().add(const UserEvent.logOut()),
            backgroundColor: AppTheme.colors.colorful07),
      ],
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
              context.read<UserBloc>().add(const UserEvent.logIn());

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
          onClick: () => context.go('/profile/about'),
        ),
        const SizedBox(height: 8),
        SettingsButton(
          text: 'Настройки',
          icon: Icons.settings_rounded,
          onClick: () => context.go('/profile/settings'),
        ),
      ],
    );
  }
}
