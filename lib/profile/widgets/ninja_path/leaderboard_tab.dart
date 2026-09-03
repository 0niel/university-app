import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ninja_path_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_skeleton.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_tab_empty.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_tab_error.dart';

part 'leaderboard_list.dart';
part 'leaderboard_row.dart';
part 'scope_chips.dart';

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NinjaPathCubit, NinjaPathState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: .stretch,
          children: [
            _ScopeChips(scope: state.leaderboardScope),
            const SizedBox(height: AppSpacing.screen),
            NinjaStateSwitcher(
              child: switch (state.leaderboardStatus) {
                .initial || .loading => const NinjaPathSkeleton.leaderboard(
                  key: ValueKey('leaderboard-loading'),
                ),
                .error => NinjaPathTabError(
                  key: const ValueKey('leaderboard-error'),
                  onRetry: () => unawaited(
                    context.read<NinjaPathCubit>().loadLeaderboard(
                      state.leaderboardScope,
                    ),
                  ),
                ),
                .loaded when state.leaderboard.isEmpty =>
                  const NinjaPathTabEmpty(
                    key: ValueKey('leaderboard-empty'),
                    icon: AppLineIcon.trophy,
                  ),
                .loaded => _LeaderboardList(
                  key: const ValueKey('leaderboard-content'),
                  entries: state.leaderboard,
                ),
              },
            ),
          ],
        );
      },
    );
  }
}
