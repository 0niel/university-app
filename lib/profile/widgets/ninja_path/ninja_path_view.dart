import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/badges_tab.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/leaderboard_tab.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_hero.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/quests_tab.dart';

class NinjaPathView extends StatefulWidget {
  const NinjaPathView({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<NinjaPathView> createState() => _NinjaPathViewState();
}

class _NinjaPathViewState extends State<NinjaPathView> {
  late int _tab = widget.initialTab.clamp(0, 2);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final profileState = context.watch<ProfileCubit>().state;
    final profile = profileState.gamificationProfile;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: AppInnerHeader(
              title: l10n.ninjaPathTitle,
              backSemanticsLabel: l10n.back,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              24,
              AppSpacing.screen,
              MediaQuery.paddingOf(context).bottom + 32,
            ),
            sliver: SliverList.list(
              children: [
                NinjaPathHero(
                  xp: profile.xp,
                  badgeCount: profileState.overview.earnedBadges,
                  streakDays: profile.streakDays,
                  shurikens: profile.shurikens,
                ),
                const SizedBox(height: AppSpacing.fieldGap),
                AppSegmentedControl<int>(
                  value: _tab,
                  onCanvas: true,
                  options: [
                    AppSegmentedOption(
                      value: 0,
                      label: l10n.ninjaPathTabBadges,
                    ),
                    AppSegmentedOption(
                      value: 1,
                      label: l10n.ninjaPathTabQuests,
                    ),
                    AppSegmentedOption(
                      value: 2,
                      label: l10n.ninjaPathTabRating,
                    ),
                  ],
                  onChanged: (value) => setState(() => _tab = value),
                ),
                const SizedBox(height: AppSpacing.lg),
                NinjaStateSwitcher(
                  child: switch (_tab) {
                    0 => const BadgesTab(key: ValueKey('badges')),
                    1 => const QuestsTab(key: ValueKey('quests')),
                    _ => const LeaderboardTab(key: ValueKey('leaderboard')),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
