import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/communities/communities.dart';

class AllCommunitiesView extends StatefulWidget {
  const AllCommunitiesView({super.key});

  @override
  State<AllCommunitiesView> createState() => _AllCommunitiesViewState();
}

class _AllCommunitiesViewState extends State<AllCommunitiesView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() => context.read<CommunityCatalogCubit>().load(
    locale: Localizations.localeOf(context).toLanguageTag(),
  );

  void _resetFilters() {
    _searchController.clear();
    context.read<CommunityCatalogCubit>()
      ..queryChanged('')
      ..sectionSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: colors.ink,
              backgroundColor: colors.canvas,
              onRefresh: _refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const NinjaCommunityCatalogHeader(),
                  NinjaCommunityCatalogSearchHeader(
                    searchController: _searchController,
                    onChanged: context
                        .read<CommunityCatalogCubit>()
                        .queryChanged,
                  ),
                  BlocBuilder<CommunityCatalogCubit, CommunityCatalogState>(
                    builder: (context, state) => switch (state.status) {
                      .initial || .loading => const SliverFillRemaining(
                        child: NinjaCommunityCatalogSkeleton(
                          key: ValueKey('catalog-loading'),
                        ),
                      ),
                      .failure => SliverFillRemaining(
                        hasScrollBody: false,
                        child: NinjaCommunityCatalogError(
                          key: const ValueKey('catalog-failure'),
                          onRetry: () => unawaited(_refresh()),
                        ),
                      ),
                      .success => NinjaCommunityCatalogContent(
                        key: ValueKey(
                          'catalog-${state.selectedSectionKey ?? 'all'}',
                        ),
                        state: state,
                        onReset: _resetFilters,
                      ),
                    },
                  ),
                ],
              ),
            ),
            BlocSelector<CommunityCatalogCubit, CommunityCatalogState, bool>(
              selector: (state) => state.isRefreshing,
              builder: (context, isRefreshing) => isRefreshing
                  ? const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: NinjaProgressBar(value: 1, tone: .ink, height: 2),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
