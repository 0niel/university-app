part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged({this.searchQuery = ''});

  final String searchQuery;

  @override
  List<Object?> get props => [searchQuery];
}

class AddQueryToSearchHistory extends SearchEvent {
  const AddQueryToSearchHistory({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class ClearSearchHistory extends SearchEvent {
  const ClearSearchHistory();

  @override
  List<Object?> get props => [];
}

class RemoveQueryFromSearchHistory extends SearchEvent {
  const RemoveQueryFromSearchHistory({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}
