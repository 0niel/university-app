import 'package:rtu_mirea_app/contributors/view/view.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:rtu_mirea_app/sponsors/view/sponsors_view.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("О приложении"),
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildSponsorsSection(),
                const SizedBox(height: 24),
                _buildContributorsSection(),
                const SizedBox(height: 24),
                _buildFeedbackButton(context),
                const SizedBox(height: 96),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppInfoRow(context),
          const SizedBox(height: 8),
          Text(
            'Это приложение и все относящиеся к нему сервисы являются '
            '100% бесплатными и Open Source продуктами. Мы с огромным '
            'удовольствием примем любые ваши предложения и сообщения, а '
            'также мы рады любому вашему участию в проекте!',
            style: AppTextStyle.bodyRegular,
          ),
          const SizedBox(height: 16),
          _buildSocialIcons(context),
        ],
      ),
    );
  }

  Widget _buildAppInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Open Source', style: AppTextStyle.h4),
        PopupMenuButton<String>(
          color: Theme.of(context).extension<AppColors>()!.background03,
          onSelected: (value) {},
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Версия приложения:', style: AppTextStyle.body),
                    const SizedBox(height: 4),
                    Text(getIt<PackageInfo>().version, style: AppTextStyle.bodyRegular),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Номер сборки:', style: AppTextStyle.body),
                    const SizedBox(height: 4),
                    Text(getIt<PackageInfo>().buildNumber, style: AppTextStyle.bodyRegular),
                  ],
                ),
              ),
            ];
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: Theme.of(context).extension<AppColors>()!.primary,
            ),
            child: Text(
              getIt<PackageInfo>().version,
              style: AppTextStyle.buttonS,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          width: 90,
          child: SocialIconButton(
            icon: Icon(UniconsLine.github, color: Theme.of(context).colorScheme.onSurface),
            onClick: () {
              launchUrlString('https://github.com/0niel/rtu-mirea-mobile', mode: LaunchMode.externalApplication);
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 40,
          width: 90,
          child: SocialIconButton(
            icon: Icon(UniconsLine.telegram, color: Theme.of(context).colorScheme.onSurface),
            onClick: () {
              launchUrlString('https://t.me/mirea_ninja_chat/1', mode: LaunchMode.externalApplication);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSponsorsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Поддержавшие 💜', style: AppTextStyle.h6),
          const SizedBox(height: 16),
          const SponsorsView(),
        ],
      ),
    );
  }

  // Method to build the contributors section
  Widget _buildContributorsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Участники проекта', style: AppTextStyle.h6),
          const SizedBox(height: 16),
          const ContributorsView(),
        ],
      ),
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: ColorfulButton(
          text: 'Сообщить об ошибке',
          backgroundColor: Theme.of(context).extension<AppColors>()!.colorful07.withBlue(180),
          onClick: () {
            final userBloc = context.read<UserBloc>();
            if (userBloc.state.status == UserStatus.authorized) {
              FeedbackBottomModalSheet.show(context, defaultEmail: userBloc.state.user!.email);
            } else {
              FeedbackBottomModalSheet.show(context);
            }
          },
        ),
      ),
    );
  }
}
