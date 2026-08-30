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
    final colors = context.ninja;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            NinjaAppBar.inner(
              title: l10n.aboutApp,
              backSemanticLabel: l10n.back,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(context),
                      _buildContributorsSection(context),
                      const SizedBox(height: 24),
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
    final colors = context.ninja;
    return Padding(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Open Source',
              style: NinjaText.title.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.aboutAppDescription,
              style: NinjaText.subtext.copyWith(
                height: 1.5,
                color: colors.mutedDark,
              ),
            ),
            const SizedBox(height: 14),
            _buildSocialIcons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcons(BuildContext context) {
    return Row(
      children: [
        NinjaIconButton(
          icon: const Icon(UniconsLine.github),
          tooltip: 'GitHub',
          onPressed: () => unawaited(
            launchUrlString(kGithubUrl, mode: .externalApplication),
          ),
        ),
        if (context.read<UniversityConfig>().communityChatUrl
            case final url?) ...[
          const SizedBox(width: 12),
          NinjaIconButton(
            icon: const Icon(UniconsLine.telegram),
            tooltip: 'Telegram',
            onPressed: () => unawaited(
              launchUrlString(url, mode: .externalApplication),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContributorsSection(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            28,
            NinjaMetrics.screenPadding,
            8,
          ),
          child: Text(
            context.l10n.aboutAppContributors,
            style: NinjaText.title.copyWith(color: colors.ink),
          ),
        ),
        const ContributorsView(),
      ],
    );
  }
}
