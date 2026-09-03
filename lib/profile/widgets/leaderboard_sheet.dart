import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ninja_path_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/utils/profile_format.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_activity_card.dart';

Future<void> showLeaderboardSheet(BuildContext context) {
  final repository = context.read<GamificationRepository>();
  final organizationId = context.read<UniversityConfig>().organizationId;
  final profile = context.read<ProfileCubit>().state;
  return showAppSheet<void>(
    context,
    title: context.l10n.ninjaPathTabRating,
    child: BlocProvider(
      create: (_) {
        final cubit = NinjaPathCubit(
          gamificationRepository: repository,
          organizationId: organizationId,
        );
        unawaited(cubit.loadLeaderboard(LeaderboardScope.group));
        return cubit;
      },
      child: LeaderboardSheet(
        activity: ProfileActivityCard(
          streakDays: profile.gamificationProfile.streakDays,
          longestStreak: profile.gamificationProfile.longestStreak,
          days: profile.activityCalendar,
          onShare: () => unawaited(shareProfileLink(context)),
        ),
      ),
    ),
  );
}

class LeaderboardSheet extends StatelessWidget {
  const LeaderboardSheet({this.activity, super.key});

  final Widget? activity;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<NinjaPathCubit, NinjaPathState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSegmentedControl<LeaderboardScope>(
              onCanvas: true,
              value: state.leaderboardScope,
              onChanged: (scope) => unawaited(
                context.read<NinjaPathCubit>().loadLeaderboard(scope),
              ),
              options: [
                AppSegmentedOption(
                  value: LeaderboardScope.group,
                  label: l10n.ninjaPathScopeGroup,
                ),
                AppSegmentedOption(
                  value: LeaderboardScope.faculty,
                  label: l10n.leaderboardScopeInstitute,
                ),
                AppSegmentedOption(
                  value: LeaderboardScope.all,
                  label: l10n.leaderboardScopeUniversity,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            NinjaStateSwitcher(
              child: switch (state.leaderboardStatus) {
                .initial || .loading => const _LeaderboardSkeleton(
                  key: ValueKey('leaderboard-loading'),
                ),
                .error => AppErrorState(
                  key: const ValueKey('leaderboard-error'),
                  title: l10n.leaderboardError,
                  message: null,
                  footnote: null,
                  primaryLabel: l10n.retry,
                  onPrimary: () => context
                      .read<NinjaPathCubit>()
                      .loadLeaderboard(state.leaderboardScope),
                ),
                .loaded when state.leaderboard.isEmpty => AppEmptyState.compact(
                  key: const ValueKey('leaderboard-empty'),
                  title: l10n.leaderboardEmpty,
                ),
                .loaded => _LeaderboardList(
                  key: const ValueKey('leaderboard-list'),
                  entries: state.leaderboard,
                ),
              },
            ),
            if (activity != null) ...[
              const SizedBox(height: AppSpacing.sectionGap),
              activity!,
            ],
          ],
        );
      },
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({required this.entries, super.key});

  final List<LeaderboardEntry> entries;

  String? _hint(AppLocalizations l10n) {
    final me = entries.indexWhere((entry) => entry.isCurrentUser);
    if (me < 0) return null;
    if (me < 3) return l10n.leaderboardHintTop;
    final target = entries[2];
    final gap = target.xp - entries[me].xp;
    return l10n.leaderboardHintGap(3, profileNumber(gap < 0 ? 0 : gap));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final hint = _hint(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppListGroup(
          children: [
            for (final (index, entry) in entries.indexed)
              ColoredBox(
                color: entry.isCurrentUser ? colors.tint : colors.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        child: Text(
                          '${index + 1}',
                          style: AppText.sans(
                            14,
                            FontWeight.w800,
                            tabular: true,
                          ).copyWith(color: colors.muted),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      AppAvatar(name: entry.displayName, size: 40),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          entry.displayName,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.cell.copyWith(color: colors.ink),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        l10n.leaderboardXp(profileNumber(entry.xp)),
                        style: AppText.sans(
                          13.5,
                          FontWeight.w800,
                          tabular: true,
                        ).copyWith(color: colors.ink),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if (hint != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
        ],
      ],
    );
  }
}

class _LeaderboardSkeleton extends StatelessWidget {
  const _LeaderboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: Column(
        children: [
          for (var i = 0; i < 5; i++) ...[
            if (i != 0) const SizedBox(height: AppSpacing.xsm),
            const AppSkeletonRow(),
          ],
        ],
      ),
    );
  }
}
