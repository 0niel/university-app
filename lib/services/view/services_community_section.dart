import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/view/services_section_label.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ServicesCommunitySection extends StatelessWidget {
  const ServicesCommunitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final showTrending = context.select<DiscourseBloc, bool>(
      (bloc) => bloc.state.showTrendingSection,
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom + 32,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (showTrending) ...[
            ServicesSectionLabel(
              title: context.l10n.homeTrending,
              trailing: AppPressable(
                onTap: () => unawaited(_openForum(context)),
                semanticsLabel: context.l10n.communitiesAll,
                semanticsButton: true,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: NinjaMetrics.minTouchTarget,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: context.ninja.surfaceAlt,
                    borderRadius: BorderRadius.circular(NinjaRadius.pill),
                  ),
                  child: Text(
                    context.l10n.communitiesAll,
                    style: NinjaText.buttonSmall.copyWith(
                      color: context.ninja.brandInk,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const TopTopicsContent(),
          ],
        ],
      ),
    );
  }

  Future<void> _openForum(BuildContext context) {
    final forumUrl = context.read<UniversityConfig>().communityForumUrl;
    return launchUrlString(
      Uri.parse(forumUrl).resolve('top').toString(),
      mode: .externalApplication,
    );
  }
}
