import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/view/home_section_header.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';

class HomeTrendingSection extends StatelessWidget {
  const HomeTrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscourseBloc, DiscourseState>(
      buildWhen: (previous, current) =>
          previous.showTrendingSection != current.showTrendingSection,
      builder: (context, state) {
        if (!state.showTrendingSection) return const SizedBox.shrink();
        final l10n = context.l10n;
        final forumUrl = context.read<UniversityConfig>().communityForumUrl;
        return Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            HomeSectionHeader(
              title: l10n.homeTrending,
              action: l10n.all.toLowerCase(),
              onAction: () => openDiscourseTop(forumUrl),
            ),
            const TopTopicsContent(),
          ],
        );
      },
    );
  }
}
