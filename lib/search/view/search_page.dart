import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/view/search_view.dart';

export 'search_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, this.query});

  final String? query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBloc(
              scheduleRepository: context.read(),
              friendsRepository: context.read(),
              campusRepository: context.read(),
            )
            ..add(SearchQueryChanged(searchQuery: query ?? ''))
            ..add(const SearchTrendingRequested()),
      child: Scaffold(
        backgroundColor: context.ninja.canvas,
        body: SafeArea(child: SearchView(query: query)),
      ),
    );
  }
}
