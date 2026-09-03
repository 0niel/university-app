import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/badges_tab.dart';

part 'leaderboard_row_skeleton.dart';

class NinjaPathSkeleton extends StatelessWidget {
  const NinjaPathSkeleton.badges({super.key}) : kind = SkeletonKind.badges;

  const NinjaPathSkeleton.quests({super.key}) : kind = SkeletonKind.quests;

  const NinjaPathSkeleton.leaderboard({super.key})
    : kind = SkeletonKind.leaderboard;

  final SkeletonKind kind;

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: switch (kind) {
        .badges => _buildBadges(context),
        .quests => _buildQuests(context),
        .leaderboard => _buildLeaderboard(context),
      },
    );
  }

  Widget _buildBadges(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _badgeCategory(context),
        const SizedBox(height: AppSpacing.screen),
        _badgeCategory(context),
      ],
    );
  }

  Widget _badgeCategory(BuildContext context) {
    final spec = badgeGridSpec(context);
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        const Row(
          children: [
            Expanded(child: NinjaSkeleton.bar(height: 19, widthFactor: 0.5)),
            SizedBox(width: AppSpacing.gap),
            NinjaSkeleton(
              width: 42,
              height: 12,
              radius: AppRadius.focusOutline,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: spec.columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: spec.aspectRatio,
          children: [
            for (var index = 0; index < spec.columns * 2; index++)
              _badgeTile(context),
          ],
        ),
      ],
    );
  }

  Widget _badgeTile(BuildContext context) {
    return Container(
      padding: const .fromLTRB(10, 14, 10, 12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: const Column(
        crossAxisAlignment: .stretch,
        children: [
          Center(child: NinjaSkeleton.avatar(size: 40)),
          SizedBox(height: AppSpacing.sm),
          NinjaSkeleton.bar(height: 13, widthFactor: 0.8),
          SizedBox(height: 3),
          Flexible(child: NinjaSkeleton.bar(height: 11, widthFactor: 0.6)),
          SizedBox(height: AppSpacing.sm),
          NinjaSkeleton(height: 8, radius: AppRadius.full),
        ],
      ),
    );
  }

  Widget _buildQuests(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        const Row(
          children: [
            Expanded(child: NinjaSkeleton.bar(height: 19, widthFactor: 0.4)),
            SizedBox(width: AppSpacing.gap),
            NinjaSkeleton(
              width: 52,
              height: 12,
              radius: AppRadius.focusOutline,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < 4; index++) _questCard(context),
      ],
    );
  }

  Widget _questCard(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 8),
      child: Container(
        padding: const .all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: const Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                NinjaSkeleton(width: 34, height: 34, radius: AppRadius.badge),
                SizedBox(width: AppSpacing.md),
                Expanded(child: NinjaSkeleton.bar(height: 15)),
                SizedBox(width: AppSpacing.gap),
                NinjaSkeleton(
                  width: 44,
                  height: 12,
                  radius: AppRadius.focusOutline,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            NinjaSkeleton(height: 8, radius: AppRadius.full),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Padding(
        padding: const .symmetric(vertical: AppSpacing.xsm),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            for (var index = 0; index < 8; index++)
              const _LeaderboardRowSkeleton(),
          ],
        ),
      ),
    );
  }
}

enum SkeletonKind { badges, quests, leaderboard }
