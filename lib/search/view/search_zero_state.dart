import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/view/trending_row.dart';
import 'package:rtu_mirea_app/search/widgets/widgets.dart';

part 'search_discovery_intro.dart';

class SearchZeroState extends StatelessWidget {
  const SearchZeroState({
    required this.state,
    required this.onQuerySelected,
    super.key,
  });

  final SearchState state;
  final void Function(String) onQuerySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: AppSpacing.xxlg),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.md,
            AppSpacing.screen,
            28,
          ),
          child: _SearchDiscoveryIntro(
            title: l10n.searchCoachTitle,
            message: l10n.searchGlobalHint,
          ),
        ),
        if (state.searchHisoty.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SearchHeadlineText(headerText: l10n.searchRecent),
                ),
                NinjaButton.text(
                  label: l10n.clear,
                  size: NinjaButtonSize.small,
                  onPressed: () => context.read<SearchBloc>().add(
                    const SearchHistoryCleared(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: Column(
              spacing: AppSpacing.gap,
              children: [
                for (final query in state.searchHisoty)
                  SearchHistoryItem(
                    query: query,
                    onPressed: onQuerySelected,
                    onClear: () => context.read<SearchBloc>().add(
                      SearchHistoryQueryRemoved(query: query),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
        if (state.trending.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: SearchHeadlineText(headerText: l10n.searchTrendingNow),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: Column(
              spacing: AppSpacing.gap,
              children: [
                for (final item in state.trending)
                  TrendingRow(
                    item: item,
                    onTap: () => onQuerySelected(item.query),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
