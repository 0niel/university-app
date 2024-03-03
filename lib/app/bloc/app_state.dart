part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class InteractedMessageRecieved extends AppState {
  final int? discoursePostIdToOpen;

  const InteractedMessageRecieved({this.discoursePostIdToOpen});

  @override
  List<Object?> get props => [discoursePostIdToOpen];
}
