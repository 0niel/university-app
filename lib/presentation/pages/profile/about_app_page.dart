import 'package:unicons/unicons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/icon_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/feedback_modal.dart';
import 'package:rtu_mirea_app/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'widgets/member_info.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("О приложении"),
        backgroundColor: AppTheme.colors.background01,
      ),
      backgroundColor: AppTheme.colors.background01,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Open Source', style: AppTextStyle.h4),
                    PopupMenuButton<String>(
                      color: AppTheme.colors.background03,
                      onSelected: (value) {},
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Версия приложения:',
                                  style: AppTextStyle.body,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  getIt<PackageInfo>().version,
                                  style: AppTextStyle.bodyRegular,
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Номер сборки:',
                                  style: AppTextStyle.body,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  getIt<PackageInfo>().buildNumber,
                                  style: AppTextStyle.bodyRegular,
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: AppTheme.colors.primary,
                        ),
                        child: Text(
                          getIt<PackageInfo>().version,
                          style: AppTextStyle.buttonS,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Это приложение и все относящиеся к нему сервисы являются '
                  '100% бесплатными и Open Source продуктами. Мы с огромным '
                  'удовольствием примем любые ваши предложения и сообщения, а '
                  'также мы рады любому вашему участию в проекте!',
                  style: AppTextStyle.bodyRegular,
                ),
                const SizedBox(height: 8),
                const Text(
                    "Спасибо Анне Степушкиной, заместителю председателя по "
                    "работе со студентами ИПТИП, за её невероятную помощь в "
                    "разработке карт зданий для нашего приложения."),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Есть предложения по улучшению приложения? Напишите'
                            ' нам на ',
                        style: AppTextStyle.bodyRegular.copyWith(
                          color: AppTheme.colors.active,
                        ),
                      ),
                      TextSpan(
                        text: 'почту ',
                        style: AppTextStyle.bodyRegular
                            .copyWith(color: AppTheme.colors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString('mailto:contact@mirea.ninja');
                          },
                      ),
                      TextSpan(
                        text: 'или в Телеграм ',
                        style: AppTextStyle.bodyRegular
                            .copyWith(color: AppTheme.colors.active),
                      ),
                      TextSpan(
                        text: 't.me/mirea_ninja_chat',
                        style: AppTextStyle.bodyRegular
                            .copyWith(color: AppTheme.colors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                              'https://t.me/mirea_ninja_chat',
                              mode: LaunchMode.externalApplication,
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Приложение разработано командой ',
                        style: AppTextStyle.bodyRegular.copyWith(
                          color: AppTheme.colors.active,
                        ),
                      ),
                      TextSpan(
                        text: 'Mirea Ninja',
                        style: AppTextStyle.bodyRegular
                            .copyWith(color: AppTheme.colors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString("https://mirea.ninja/");
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 90,
                      child: SocialIconButton(
                          icon: Icon(UniconsLine.github,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          onClick: () {
                            launchUrlString(
                              'https://github.com/mirea-ninja/rtu-mirea-mobile',
                              mode: LaunchMode.externalApplication,
                            );
                          }),
                    ),
                    // const SizedBox(width: 12),
                    // SizedBox(
                    //   height: 40,
                    //   width: 90,
                    //   child: SocialIconButton(
                    //       assetImage:
                    //           const AssetImage('assets/icons/patreon.png'),
                    //       onClick: () {
                    //         launchUrlString(
                    //             'https://www.patreon.com/mireaninja');
                    //       }),
                    // ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 40,
                      width: 90,
                      child: SocialIconButton(
                          icon: Icon(UniconsLine.telegram,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          onClick: () {
                            launchUrlString(
                              'https://t.me/mirea_ninja_chat/1',
                              mode: LaunchMode.externalApplication,
                            );
                          }),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Text('Участники проекта', style: AppTextStyle.h4),
                const SizedBox(height: 16),
                BlocBuilder<AboutAppBloc, AboutAppState>(
                  buildWhen: (prevState, currentState) {
                    if (prevState is AboutAppMembersLoadError) {
                      if (prevState.contributorsLoadError) return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is AboutAppMembersLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: AppTheme.colors.primary,
                          strokeWidth: 5,
                        ),
                      );
                    } else if (state is AboutAppMembersLoaded) {
                      return Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: [
                          for (var contributor in state.contributors)
                            MemberInfo(
                              username: contributor.login,
                              avatarUrl: contributor.avatarUrl,
                              profileUrl: contributor.htmlUrl,
                            ),
                        ],
                      );
                    } else if (state is AboutAppMembersLoadError) {
                      return Center(
                        child: Text(
                          'Произошла ошибка при загрузке разработчиков. Проверьте ваше интернет-соединение.',
                          style: AppTextStyle.bodyRegular,
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ColorfulButton(
                    text: 'Сообщить об ошибке',
                    backgroundColor: AppTheme.colors.colorful07.withBlue(180),
                    onClick: () {
                      final userBloc = context.read<UserBloc>();

                      userBloc.state.maybeMap(
                        logInSuccess: (value) => FeedbackBottomModalSheet.show(
                          context,
                          defaultEmail: value.user.email,
                        ),
                        orElse: () => FeedbackBottomModalSheet.show(context),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Text('Патроны', style: AppTextStyle.h4),
                // const SizedBox(height: 16),
                // BlocBuilder<AboutAppBloc, AboutAppState>(
                //   buildWhen: (prevState, currentState) {
                //     if (prevState is AboutAppMembersLoadError) {
                //       if (prevState.patronsLoadError) return false;
                //     }
                //     return true;
                //   },
                //   builder: (context, state) {
                //     if (state is AboutAppMembersLoading) {
                //       return Center(
                //         child: CircularProgressIndicator(
                //           backgroundColor: AppTheme.colors.primary,
                //           strokeWidth: 5,
                //         ),
                //       );
                //     } else if (state is AboutAppMembersLoaded) {
                //       return Wrap(
                //         spacing: 16.0,
                //         runSpacing: 16.0,
                //         children: List.generate(state.patrons.length, (index) {
                //           return MemberInfo(
                //             username: state.patrons[index].username,
                //             avatarUrl:
                //                 'https://mirea.ninja/${state.patrons[index].avatarTemplate.replaceAll('{size}', '120')}',
                //             profileUrl:
                //                 'https://mirea.ninja/u/${state.patrons[index].username}',
                //           );
                //         }),
                //       );
                //     } else if (state is AboutAppMembersLoadError) {
                //       return Center(
                //         child: Text(
                //           'Произошла ошибка при загрузке патронов.',
                //           style: AppTextStyle.title,
                //         ),
                //       );
                //     }
                //     return Container();
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
