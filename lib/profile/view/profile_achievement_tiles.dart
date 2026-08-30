part of 'profile_page.dart';

const _kProfileTiles = 3;

class _ProfileAchievementTiles extends StatefulWidget {
  const _ProfileAchievementTiles({required this.badges, required this.onTap});

  final List<GamificationBadge> badges;
  final VoidCallback onTap;

  @override
  State<_ProfileAchievementTiles> createState() =>
      _ProfileAchievementTilesState();
}

class _ProfileAchievementTilesState extends State<_ProfileAchievementTiles> {
  late final PageController _controller;

  int _visibleCount(List<GamificationBadge> badges) =>
      badges.length.clamp(0, _kProfileTiles);

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.79);
  }

  @override
  void didUpdateWidget(covariant _ProfileAchievementTiles oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldCount = _visibleCount(oldWidget.badges);
    final newCount = _visibleCount(widget.badges);
    if (newCount >= oldCount || newCount == 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !_controller.hasClients ||
          _controller.positions.length != 1 ||
          !_controller.position.hasContentDimensions) {
        return;
      }
      final current = (_controller.page ?? _controller.initialPage).round();
      final target = current.clamp(0, newCount - 1);
      if (current != target) _controller.jumpToPage(target);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = widget.badges.take(_kProfileTiles).toList();
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final height = (140 + (scale - 1).clamp(0, 1) * 92).toDouble();
    return Padding(
      padding: const .only(left: NinjaMetrics.screenPadding),
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: context.l10n.profileBadgesSection,
        child: SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            padEnds: false,
            allowImplicitScrolling: true,
            physics: const BouncingScrollPhysics(),
            itemCount: tiles.length,
            itemBuilder: (context, index) => Padding(
              padding: const .only(right: 10),
              child: _ProfileAchievementTile(
                badge: tiles[index],
                onTap: widget.onTap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
