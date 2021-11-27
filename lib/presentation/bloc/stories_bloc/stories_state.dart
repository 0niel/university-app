part of 'stories_bloc.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesLoadError extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<Story> stories;

  const StoriesLoaded({required this.stories});

  @override
  List<Object> get props => [stories];
}
