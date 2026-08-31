import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';

class SearchFailureState extends StatelessWidget {
  const SearchFailureState({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        24,
        NinjaMetrics.screenPadding,
        24,
      ),
      children: [
        NinjaErrorState(
          icon: const AppLineIconWidget(AppLineIcon.search),
          title: l10n.searchFailed,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () => context.read<SearchBloc>().add(
            SearchQueryChanged(searchQuery: query),
          ),
        ).animateEmptyState(),
      ],
    );
  }
}
