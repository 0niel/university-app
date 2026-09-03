import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tools/view/widgets/app_community_grid.dart';
import 'package:rtu_mirea_app/tools/view/widgets/contributors_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !{'https', 'http'}.contains(uri.scheme)) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ColoredBox(
      color: context.colors.canvas,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
        children: [
          AppInnerHeader(
            title: l10n.toolsCommunitySection,
            subtitle: l10n.toolsCommunitySectionSubtitle,
            padding: EdgeInsets.only(
              top: math.max(
                AppSpacing.screenTop,
                MediaQuery.paddingOf(context).top + AppSpacing.md,
              ),
            ),
            backSemanticsLabel: l10n.back,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppCommunityGrid(
            chatUrl: context.read<UniversityConfig>().communityChatUrl,
            onOpen: (url) => unawaited(_open(url)),
          ),
          const SizedBox(height: AppSpacing.lg),
          ContributorsCard(onBecomeContributor: (url) => unawaited(_open(url))),
          const SizedBox(height: AppSpacing.md),
          AppButton.secondary(
            label: l10n.refreshData,
            icon: const AppLineIconWidget(AppLineIcon.refresh),
            onPressed: () => context.read<ContributorsBloc>().add(
              const ContributorsRequested(),
            ),
          ),
        ],
      ),
    );
  }
}
