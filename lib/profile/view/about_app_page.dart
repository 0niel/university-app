import 'package:rtu_mirea_app/contributors/view/view.dart';
import 'package:rtu_mirea_app/sponsors/view/sponsors_view.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("О приложении")),
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
            style: AppTextStyle.body,
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
      children: [Text('Open Source', style: AppTextStyle.h4)],
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
            icon: Icon(
              UniconsLine.github,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onClick: () {
              launchUrlString(
                'https://github.com/0niel/university-app',
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
            icon: Icon(
              UniconsLine.telegram,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onClick: () {
              launchUrlString(
                'https://t.me/mirea_ninja_chat/1',
                mode: LaunchMode.externalApplication,
              );
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

  Widget _buildContributorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Участники проекта', style: AppTextStyle.h6),
        ),
        const SizedBox(height: 16),
        const ContributorsView(),
      ],
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
          backgroundColor: Theme.of(
            context,
          ).extension<AppColors>()!.colorful07.withBlue(180),
          onClick: () {
            launchUrlString(
              'https://t.me/mirea_ninja_chat/473603',
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ),
    );
  }
}
