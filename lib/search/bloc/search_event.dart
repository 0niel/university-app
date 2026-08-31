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

class SearchHistoryQueryAdded extends SearchEvent {
  const SearchHistoryQueryAdded({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class SearchHistoryCleared extends SearchEvent {
  const SearchHistoryCleared();

  @override
  List<Object?> get props => [];
}

class SearchHistoryQueryRemoved extends SearchEvent {
  const SearchHistoryQueryRemoved({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class SearchTrendingRequested extends SearchEvent {
  const SearchTrendingRequested();

  @override
  List<Object?> get props => [];
}

class SearchModeChanged extends SearchEvent {
  const SearchModeChanged({required this.searchMode});

  final SearchMode searchMode;

  @override
  List<Object?> get props => [searchMode];
}
