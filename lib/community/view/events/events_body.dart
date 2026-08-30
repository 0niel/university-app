part of '../events_view.dart';

class _EventsBody extends StatelessWidget {
  const _EventsBody({required this.state});

  final EventsState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
    final pinFilters = textScale <= 1.3;
    return RefreshIndicator(
      backgroundColor: colors.canvas,
      color: colors.ink,
      onRefresh: context.read<EventsCubit>().load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: NinjaCommunityHeader(
              title: context.l10n.eventsTitle,
              subtitle: context.l10n.eventsSubtitle,
            ),
          ),
          if (pinFilters)
            SliverPersistentHeader(
              pinned: true,
              delegate: _NinjaEventsFilterDelegate(
                color: colors.canvas,
                child: _CategoryFilters(selected: state.category),
              ),
            )
          else
            SliverToBoxAdapter(
              child: ColoredBox(
                color: colors.canvas,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: _CategoryFilters(selected: state.category),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: NinjaStateSwitcher(child: _content(context)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (state.status == .loading) {
      return const EventsSkeleton(key: ValueKey('events-loading'));
    }
    if (state.status == .failure && state.events.isEmpty) {
      return _LoadFailure(
        key: const ValueKey('events-failure'),
        onRetry: context.read<EventsCubit>().load,
      );
    }
    if (state.filteredEvents.isEmpty) {
      return const _EmptyEvents(key: ValueKey('events-empty'));
    }
    return _EventsList(
      key: ValueKey('events-list-${state.category.wireName}'),
      state: state,
    );
  }
}

class _NinjaEventsFilterDelegate extends SliverPersistentHeaderDelegate {
  const _NinjaEventsFilterDelegate({
    required this.color,
    required this.child,
  });

  final Color color;
  final Widget child;

  @override
  double get minExtent => 62;

  @override
  double get maxExtent => 62;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_NinjaEventsFilterDelegate oldDelegate) =>
      oldDelegate.color != color || oldDelegate.child != child;
}
