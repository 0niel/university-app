import 'package:rtu_mirea_app/contributors/view/view.dart';
import 'package:rtu_mirea_app/sponsors/view/sponsors_view.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/icon_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/feedback_modal.dart';
import 'package:rtu_mirea_app/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("О приложении"),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
                          color: AppTheme.colorsOf(context).background03,
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
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              color: AppTheme.colorsOf(context).primary,
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
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Приложение разработано командой ',
                            style: AppTextStyle.bodyRegular.copyWith(
                              color: AppTheme.colorsOf(context).active,
                            ),
                          ),
                          TextSpan(
                            text: 'Mirea Ninja.',
                            style: AppTextStyle.bodyRegular.copyWith(color: AppTheme.colorsOf(context).primary),
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
                            icon: Icon(
                              UniconsLine.github,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            onClick: () {
                              launchUrlString(
                                'https://github.com/0niel/rtu-mirea-mobile',
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 40,
                          width: 90,
                          child: SocialIconButton(
                              icon: Icon(UniconsLine.telegram, color: Theme.of(context).colorScheme.onBackground),
                              onClick: () {
                                launchUrlString(
                                  'https://t.me/mirea_ninja_chat/1',
                                  mode: LaunchMode.externalApplication,
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Спонсоры 💜', style: AppTextStyle.h6),
                    TextButton(
                      onPressed: () {
                        launchUrlString(
                          'https://boosty.to/oniel',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(
                        'Стать спонсором',
                        style: AppTextStyle.buttonS.copyWith(
                          color: AppTheme.colorsOf(context).primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SponsorsView(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Участники проекта', style: AppTextStyle.h6),
              ),
              const SizedBox(height: 16),
              const ContributorsView(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ColorfulButton(
                    text: 'Сообщить об ошибке',
                    backgroundColor: AppTheme.colorsOf(context).colorful07.withBlue(180),
                    onClick: () {
                      final userBloc = context.read<UserBloc>();

                      if (userBloc.state.status == UserStatus.authorized) {
                        FeedbackBottomModalSheet.show(
                          context,
                          defaultEmail: userBloc.state.user!.email,
                        );
                      } else {
                        FeedbackBottomModalSheet.show(context);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
