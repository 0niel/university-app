import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/contributors/view/view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/view/profile_settings_page.dart'
    show kGithubUrl;
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            AppInnerHeader(
              title: l10n.aboutApp,
              backSemanticsLabel: l10n.back,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: AppSpacing.screen),
                      _buildHeader(context),
                      _buildContributorsSection(context),
                      SizedBox(
                        key: const ValueKey('about-bottom-inset'),
                        height: ninjaBottomInset(context) + AppSpacing.lg,
                      ),
                    ]),
                  ),
                ],
              ).animatePageEntrance(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .symmetric(horizontal: AppSpacing.screen),
      child: Container(
        padding: const .all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Open Source',
              style: AppText.title.copyWith(color: colors.ink),
            ),
            const SizedBox(height: AppSpacing.xsm),
            Text(
              context.l10n.aboutAppDescription,
              style: AppText.subtext.copyWith(
                height: 1.5,
                color: colors.muted,
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            _buildSocialIcons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcons(BuildContext context) {
    return Row(
      children: [
        AppHeaderCircleButton(
          background: context.colors.surface2,
          action: AppHeaderAction(
            child: const Icon(UniconsLine.github, size: 20),
            semanticsLabel: 'GitHub',
            onTap: () => unawaited(_openLink(context, kGithubUrl)),
          ),
        ),
        if (context.read<UniversityConfig>().communityChatUrl
            case final url?) ...[
          const SizedBox(width: AppSpacing.md),
          AppHeaderCircleButton(
            background: context.colors.surface2,
            action: AppHeaderAction(
              child: const Icon(UniconsLine.telegram, size: 20),
              semanticsLabel: 'Telegram',
              onTap: () => unawaited(_openLink(context, url)),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    try {
      final launched = await launchUrlString(url, mode: .externalApplication);
      if (!launched && context.mounted) {
        ToastManager.showError(context, message: context.l10n.error);
      }
    } on Exception {
      if (context.mounted) {
        ToastManager.showError(context, message: context.l10n.error);
      }
    }
  }

  Widget _buildContributorsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .fromLTRB(
            AppSpacing.screen,
            28,
            AppSpacing.screen,
            8,
          ),
          child: AppSectionTitle(title: context.l10n.aboutAppContributors),
        ),
        const ContributorsView(),
      ],
    );
  }
}
