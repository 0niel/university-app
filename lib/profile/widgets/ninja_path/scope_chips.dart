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
    return NinjaChipRow(
      padding: .zero,
      children: [
        for (final (value, label) in scopes)
          NinjaChip(
            label: label,
            selected: scope == value,
            onTap: () => unawaited(
              context.read<NinjaPathCubit>().loadLeaderboard(value),
            ),
          ),
      ],
    );
  }
}
