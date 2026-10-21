import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ninja_path_cubit.dart';
import 'package:rtu_mirea_app/profile/profile_layout.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/badge_tile.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_skeleton.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_tab_empty.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_tab_error.dart';

part 'badges_content.dart';
part 'category_header.dart';
part 'recently_unlocked_card.dart';

({int columns, double aspectRatio}) badgeGridSpec(BuildContext context) {
  if (MediaQuery.textScalerOf(context).scale(1) >=
      ProfileLayout.largeTextScale) {
    return (
      columns: ProfileLayout.largeTextBadgeColumns,
      aspectRatio: ProfileLayout.largeTextBadgeAspectRatio,
    );
  }
  return (
    columns: ProfileLayout.badgeColumns,
    aspectRatio: ProfileLayout.badgeAspectRatio,
  );
}

class BadgesTab extends StatelessWidget {
  const BadgesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NinjaPathCubit, NinjaPathState>(
      buildWhen: (previous, current) =>
          previous.badgesStatus != current.badgesStatus ||
          !listEquals(previous.badges, current.badges) ||
          previous.recentlyUnlocked != current.recentlyUnlocked,
      builder: (context, state) {
        return TweenAnimationBuilder<double>(
          key: ValueKey(state.badgesStatus),
          tween: Tween(begin: 0, end: 1),
          duration: NinjaMotion.of(context),
          curve: Curves.easeOutCubic,
          builder: (context, opacity, child) =>
              SliverOpacity(opacity: opacity, sliver: child),
          child: switch (state.badgesStatus) {
            .initial || .loading => const SliverToBoxAdapter(
              child: NinjaPathSkeleton.badges(key: ValueKey('badges-loading')),
            ),
            .error => SliverToBoxAdapter(
              child: NinjaPathTabError(
                key: const ValueKey('badges-error'),
                onRetry: () =>
                    unawaited(context.read<NinjaPathCubit>().loadBadges()),
              ),
            ),
            .loaded when state.badges.isEmpty => const SliverToBoxAdapter(
              child: NinjaPathTabEmpty(
                key: ValueKey('badges-empty'),
                icon: AppLineIcon.trophy,
              ),
            ),
            .loaded => _BadgesContent(
              key: const ValueKey('badges-content'),
              badges: state.badges,
              recentlyUnlocked: state.recentlyUnlocked,
            ),
          },
        );
      },
    );
  }
}
