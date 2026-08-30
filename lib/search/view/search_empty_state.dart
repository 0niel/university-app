import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/widgets/widgets.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
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
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            24,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: NinjaEmptyState.screen(
            icon: const AppLineIconWidget(AppLineIcon.search, size: 24),
            title: l10n.searchNoResults,
            message: l10n.searchNoResultsHint,
            actionLabel: l10n.clear,
            onAction: () => onQuerySelected(''),
          ).animateEmptyState(),
        ),
        if (state.searchHisoty.isNotEmpty) ...[
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: SearchHeadlineText(headerText: l10n.searchRecent),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: Column(
              spacing: AppSpacing.gap,
              children: [
                for (final recent in state.searchHisoty)
                  SearchHistoryItem(
                    query: recent,
                    onPressed: onQuerySelected,
                    onClear: () => context.read<SearchBloc>().add(
                      SearchHistoryQueryRemoved(query: recent),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
