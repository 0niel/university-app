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
