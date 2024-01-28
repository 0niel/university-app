import 'package:flutter/material.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:neon_framework/src/widgets/linear_progress_indicator.dart';

/// A custom Neon list view similar to [ListView].
///
/// A Neon list view handles fixed header items, refreshing and displaying
/// loading and error information.
class NeonListView extends StatelessWidget {
  /// Creates a new Neon list view.
  NeonListView({
    required this.isLoading,
    required this.error,
    required this.onRefresh,
    required NullableIndexedWidgetBuilder itemBuilder,
    required this.scrollKey,
    int? itemCount,
    this.topFixedChildren,
    this.topScrollingChildren,
    super.key,
  }) : sliver = SliverList.builder(
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );

  /// Creates a Neon list view with a custom child model.
  const NeonListView.custom({
    required this.isLoading,
    required this.error,
    required this.onRefresh,
    required this.sliver,
    required this.scrollKey,
    this.topFixedChildren,
    this.topScrollingChildren,
    super.key,
  });

  /// Whether a [NeonLinearProgressIndicator] should be shown indicating that
  /// the data for this list is still loading or refreshing.
  final bool isLoading;

  /// The error to show in a persistent [NeonError] at the top of the list.
  final Object? error;

  /// The callback invoked when the user refreshes the list.
  final RefreshCallback onRefresh;

  /// The scroll key attached to this list view.
  final String scrollKey;

  /// A list of widgets that are displayed at the top of the but do not scroll with it.
  final List<Widget>? topFixedChildren;

  /// A list of widgets that are displayed at the top of the list and scroll with it.
  final List<Widget>? topScrollingChildren;

  /// The sliver controlling the main scrollable area.
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    final hasFloatingActionButton = Scaffold.maybeOf(context)?.hasFloatingActionButton ?? false;

    return RefreshIndicator.adaptive(
      key: refreshIndicatorKey,
      onRefresh: onRefresh,
      child: CustomScrollView(
        key: PageStorageKey<String>(scrollKey),
        primary: true,
        slivers: [
          if (topFixedChildren != null)
            SliverList.builder(
              itemCount: topFixedChildren!.length,
              itemBuilder: (context, index) => topFixedChildren![index],
            ),
          SliverToBoxAdapter(
            child: NeonLinearProgressIndicator(
              visible: isLoading,
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: NeonError(
              error,
              onRetry: () async => refreshIndicatorKey.currentState!.show(),
            ),
          ),
          if (topScrollingChildren != null)
            SliverList.builder(
              itemCount: topScrollingChildren!.length,
              itemBuilder: (context, index) => topScrollingChildren![index],
            ),
          SliverPadding(
            padding: hasFloatingActionButton ? const EdgeInsets.only(bottom: 88) : EdgeInsets.zero,
            sliver: sliver,
          ),
        ],
      ),
    );
  }
}
