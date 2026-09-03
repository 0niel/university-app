part of 'leaderboard_tab.dart';

class _ScopeChips extends StatelessWidget {
  const _ScopeChips({required this.scope});

  final LeaderboardScope scope;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scopes = [
      (LeaderboardScope.group, l10n.ninjaPathScopeGroup),
      (LeaderboardScope.course, l10n.ninjaPathScopeCourse),
      (LeaderboardScope.faculty, l10n.ninjaPathScopeFaculty),
      (LeaderboardScope.all, l10n.ninjaPathScopeAll),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (value, label) in scopes)
          AppFilterChip(
            label: label,
            isSelected: scope == value,
            onTap: () => unawaited(
              context.read<NinjaPathCubit>().loadLeaderboard(value),
            ),
          ),
      ],
    );
  }
}
