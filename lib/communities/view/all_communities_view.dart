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
        child: Column(
          crossAxisAlignment: .start,
          children: [
            NinjaCommunityCatalogHeader(
              searchController: _searchController,
              onChanged: context.read<CommunityCatalogCubit>().queryChanged,
            ),
            const NinjaCommunitySectionFilters(),
            Expanded(
              child: BlocBuilder<CommunityCatalogCubit, CommunityCatalogState>(
                builder: (context, state) => NinjaStateSwitcher(
                  child: switch (state.status) {
                    .initial || .loading => const NinjaCommunityCatalogSkeleton(
                      key: ValueKey('catalog-loading'),
                    ),
                    .failure => NinjaCommunityCatalogError(
                      key: const ValueKey('catalog-failure'),
                      onRetry: () => unawaited(_refresh()),
                    ),
                    .success => NinjaCommunityCatalogContent(
                      key: ValueKey(
                        'catalog-${state.selectedSectionKey ?? 'all'}',
                      ),
                      state: state,
                      onRefresh: _refresh,
                      onReset: _resetFilters,
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
