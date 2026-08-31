import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ninja_path_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/badge_tile.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_skeleton.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_tab_empty.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_tab_error.dart';

part 'badges_content.dart';
part 'category_header.dart';
part 'recently_unlocked_card.dart';

({int columns, double aspectRatio}) badgeGridSpec(BuildContext context) {
  if (MediaQuery.textScalerOf(context).scale(1) >= 1.5) {
    return (columns: 2, aspectRatio: 0.62);
  }
  return (columns: 3, aspectRatio: 0.66);
}

class BadgesTab extends StatelessWidget {
  const BadgesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NinjaPathCubit, NinjaPathState>(
      builder: (context, state) {
        return NinjaStateSwitcher(
          child: switch (state.badgesStatus) {
            .initial || .loading => const NinjaPathSkeleton.badges(
              key: ValueKey('badges-loading'),
            ),
            .error => NinjaPathTabError(
              key: const ValueKey('badges-error'),
              onRetry: () =>
                  unawaited(context.read<NinjaPathCubit>().loadBadges()),
            ),
            .loaded when state.badges.isEmpty => const NinjaPathTabEmpty(
              key: ValueKey('badges-empty'),
              icon: AppLineIcon.trophy,
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
