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
    final colors = context.ninja;
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
          SliverAppBar(
            pinned: true,
            backgroundColor: colors.canvas,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 60,
            leading: Center(
              child: NinjaIconButton(
                icon: const AppLineIconWidget(.chevronL, size: 20),
                tooltip: l10n.back,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            title: Text(
              l10n.ninjaPathTitle,
              style: NinjaText.appBarTitle.copyWith(color: colors.ink),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              NinjaMetrics.screenPadding,
              8,
              NinjaMetrics.screenPadding,
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
                const SizedBox(height: 18),
                NinjaTabs<int>(
                  value: _tab,
                  padding: EdgeInsets.zero,
                  tabs: [
                    NinjaTab(value: 0, label: l10n.ninjaPathTabBadges),
                    NinjaTab(value: 1, label: l10n.ninjaPathTabQuests),
                    NinjaTab(value: 2, label: l10n.ninjaPathTabRating),
                  ],
                  onChanged: (value) => setState(() => _tab = value),
                ),
                const SizedBox(height: 16),
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
