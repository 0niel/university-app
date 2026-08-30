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
    final categories = badges.map((badge) => badge.category).toSet().toList()
      ..sort();
    final recentlyUnlocked = this.recentlyUnlocked;
    final spec = badgeGridSpec(context);
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (recentlyUnlocked != null) ...[
          _RecentlyUnlockedCard(badge: recentlyUnlocked),
          const SizedBox(height: 20),
        ],
        for (final category in categories) ..._category(category, spec),
      ],
    );
  }

  List<Widget> _category(
    String category,
    ({int columns, double aspectRatio}) spec,
  ) {
    final categoryBadges = _sorted(
      badges.where((badge) => badge.category == category),
    );
    final earned = categoryBadges.where((badge) => badge.isEarned).length;
    return [
      _CategoryHeader(
        title: category,
        done: earned,
        total: categoryBadges.length,
      ),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: spec.columns,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: spec.aspectRatio,
        children: [
          for (final badge in categoryBadges) BadgeTile(badge: badge),
        ],
      ),
      const SizedBox(height: 20),
    ];
  }

  List<GamificationBadge> _sorted(Iterable<GamificationBadge> source) =>
      source.toList()..sort((a, b) {
        if (a.isEarned != b.isEarned) return a.isEarned ? -1 : 1;
        if (a.isEarned) return a.name.compareTo(b.name);
        return b.progress.compareTo(a.progress);
      });
}
