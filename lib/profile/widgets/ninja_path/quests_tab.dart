import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ninja_path_cubit.dart';
import 'package:rtu_mirea_app/profile/utils/supported_quest.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_skeleton.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_tab_empty.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_tab_error.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_progress_bar.dart';

part 'ninja_quest_card.dart';
part 'quests_content.dart';
part 'quests_heading.dart';

class QuestsTab extends StatelessWidget {
  const QuestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NinjaPathCubit, NinjaPathState>(
      builder: (context, state) {
        final supported = state.quests.where(isSupportedProfileQuest);
        final daily = supported.where((quest) => quest.isDaily).toList();
        final weekly = supported.where((quest) => quest.isWeekly).toList();
        return NinjaStateSwitcher(
          child: switch (state.questsStatus) {
            .initial || .loading => const NinjaPathSkeleton.quests(
              key: ValueKey('quests-loading'),
            ),
            .error => NinjaPathTabError(
              key: const ValueKey('quests-error'),
              onRetry: () =>
                  unawaited(context.read<NinjaPathCubit>().loadQuests()),
            ),
            .loaded when daily.isEmpty && weekly.isEmpty =>
              const NinjaPathTabEmpty(
                key: ValueKey('quests-empty'),
                icon: AppLineIcon.spark,
              ),
            .loaded => _QuestsContent(
              key: const ValueKey('quests-content'),
              daily: daily,
              weekly: weekly,
            ),
          },
        );
      },
    );
  }
}
