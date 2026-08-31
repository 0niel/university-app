import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/search.dart';
import 'package:rtu_mirea_app/search/widgets/search_scope_chip.dart';

class SearchModeSelect extends StatelessWidget {
  const SearchModeSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (prev, curr) => prev.searchMode != curr.searchMode,
      builder: (context, state) {
        final l10n = context.l10n;
        final scopes = [
          (SearchMode.all, l10n.searchScopeAll),
          (SearchMode.schedule, l10n.searchScopeClasses),
          (SearchMode.people, l10n.peopleTitle),
          (SearchMode.community, l10n.searchScopeCommunity),
          (SearchMode.classrooms, l10n.searchScopeClassrooms),
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: NinjaMetrics.screenPadding,
          ),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              for (final scope in scopes)
                SearchScopeChip(
                  label: scope.$2,
                  selected: state.searchMode == scope.$1,
                  onTap: () => context.read<SearchBloc>().add(
                    SearchModeChanged(searchMode: scope.$1),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
