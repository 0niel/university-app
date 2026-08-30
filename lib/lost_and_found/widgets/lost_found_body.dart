import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_cold_error.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_empty_state.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_item_card.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_list_skeleton.dart';

class LostFoundBody extends StatelessWidget {
  const LostFoundBody({
    required this.state,
    required this.header,
    required this.categoryFilter,
    required this.onItemTap,
    required this.onReport,
    super.key,
  });

  final LostFoundState state;
  final ValueChanged<LostFoundItem> onItemTap;
  final VoidCallback onReport;
  final Widget header;
  final Widget categoryFilter;

  @override
  Widget build(BuildContext context) {
    final coldLoading = state.status == .loading && state.items.isEmpty;
    final scrollView = CustomScrollView(
      key: const PageStorageKey('lost-found-scroll'),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(child: header),
        SliverToBoxAdapter(child: categoryFilter),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        ..._content(context),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
    return RefreshIndicator.adaptive(
      color: context.ninja.brand,
      backgroundColor: context.ninja.surface,
      onRefresh: () async => context.read<LostFoundCubit>().load(),
      child: coldLoading
          ? NinjaSkeletonGroup(
              excludeSemantics: false,
              semanticsLabel: context.l10n.loadingContent,
              child: scrollView,
            )
          : scrollView,
    );
  }

  List<Widget> _content(BuildContext context) {
    final items = state.filteredItems;
    if (items.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: NinjaStateSwitcher(child: _placeholder(context)),
        ),
      ];
    }
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final width = MediaQuery.widthOf(context);
    final singleColumn = width < 360 || textScale >= 1.3;
    if (singleColumn) {
      return [
        SliverPadding(
          key: const ValueKey('list'),
          padding: const EdgeInsets.symmetric(
            horizontal: NinjaMetrics.screenPadding,
          ),
          sliver: SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.gap),
            itemBuilder: (context, index) => SizedBox(
              height: textScale >= 1.8 ? 290 : 238,
              child: _tile(items[index], index),
            ),
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        key: const ValueKey('grid'),
        padding: const EdgeInsets.symmetric(
          horizontal: NinjaMetrics.screenPadding,
        ),
        sliver: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.gap,
            mainAxisSpacing: AppSpacing.gap,
            mainAxisExtent: 238,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _tile(items[index], index),
        ),
      ),
    ];
  }

  Widget _placeholder(BuildContext context) {
    if (state.status == .loading && state.items.isEmpty) {
      return const LostFoundListSkeleton(key: ValueKey('loading'));
    }
    if (state.status == .failure && state.items.isEmpty) {
      return LostFoundColdError(
        onRetry: context.read<LostFoundCubit>().load,
      ).animateEmptyState(key: const ValueKey('error'));
    }
    return LostFoundEmptyState(
      status: state.tab,
      onReport: onReport,
    ).animateEmptyState(key: const ValueKey('empty'));
  }

  Widget _tile(LostFoundItem item, int index) => LostFoundItemCard(
    item: item,
    onTap: () => onItemTap(item),
  ).animateListItem(index: index);
}
