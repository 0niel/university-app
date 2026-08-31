import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tools/view/widgets/app_community_grid.dart';
import 'package:rtu_mirea_app/tools/view/widgets/contributors_card.dart';
import 'package:url_launcher/url_launcher.dart';

part 'tools_header.dart';

class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: .externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocBuilder<ContributorsBloc, ContributorsState>(
        builder: (context, state) {
          void reload() => context.read<ContributorsBloc>().add(
            const ContributorsRequested(),
          );
          return RefreshIndicator(
            color: colors.brand,
            backgroundColor: colors.surface,
            onRefresh: () async => reload(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _ToolsHeader(
                    busy: state.status == .loading,
                    onRefresh: reload,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    NinjaMetrics.screenPadding,
                    0,
                    NinjaMetrics.screenPadding,
                    40,
                  ),
                  sliver: SliverList.list(
                    children: [
                      Text(
                        l10n.toolsCommunitySection,
                        style: NinjaText.title.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.toolsCommunitySectionSubtitle,
                        style: NinjaText.subtext.copyWith(color: colors.muted),
                      ),
                      const SizedBox(height: 16),
                      AppCommunityGrid(
                        chatUrl: context
                            .read<UniversityConfig>()
                            .communityChatUrl,
                        onOpen: (url) => unawaited(_open(url)),
                      ),
                      const SizedBox(height: 28),
                      ContributorsCard(
                        onBecomeContributor: (url) => unawaited(_open(url)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
