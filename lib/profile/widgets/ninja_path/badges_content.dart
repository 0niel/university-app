part of 'badges_tab.dart';

class _BadgesContent extends StatelessWidget {
  const _BadgesContent({
    required this.badges,
    required this.recentlyUnlocked,
    super.key,
  });

  final List<GamificationBadge> badges;
  final GamificationBadge? recentlyUnlocked;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<GamificationBadge>>{};
    for (final badge in badges) {
      (grouped[badge.category] ??= []).add(badge);
    }
    final categories = grouped.keys.toList()..sort();
    final recentlyUnlocked = this.recentlyUnlocked;
    final spec = badgeGridSpec(context);
    return SliverMainAxisGroup(
      slivers: [
        if (recentlyUnlocked != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.screen),
              child: _RecentlyUnlockedCard(badge: recentlyUnlocked),
            ),
          ),
        for (final category in categories)
          ..._category(category, grouped[category]!, spec),
      ],
    );
  }

  List<Widget> _category(
    String category,
    List<GamificationBadge> categoryEntries,
    ({int columns, double aspectRatio}) spec,
  ) {
    final categoryBadges = _sorted(categoryEntries);
    final earned = categoryBadges.where((badge) => badge.isEarned).length;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _CategoryHeader(
            title: category,
            done: earned,
            total: categoryBadges.length,
          ),
        ),
      ),
      SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: spec.columns,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: spec.aspectRatio,
        ),
        itemCount: categoryBadges.length,
        itemBuilder: (context, index) => BadgeTile(
          key: ValueKey(categoryBadges[index].id),
          badge: categoryBadges[index],
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.screen)),
    ];
  }

  List<GamificationBadge> _sorted(Iterable<GamificationBadge> source) =>
      source.toList()..sort((a, b) {
        if (a.isEarned != b.isEarned) return a.isEarned ? -1 : 1;
        if (a.isEarned) return a.name.compareTo(b.name);
        return b.progress.compareTo(a.progress);
      });
}
