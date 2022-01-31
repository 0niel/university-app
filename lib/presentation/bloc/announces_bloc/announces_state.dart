part of 'announces_bloc.dart';

abstract class AnnouncesState extends Equatable {
  const AnnouncesState();

  @override
  List<Object> get props => [];
}

class AnnouncesInitial extends AnnouncesState {}

class AnnouncesLoading extends AnnouncesState {}

class AnnouncesLoadError extends AnnouncesState {}

class AnnouncesLoaded extends AnnouncesState {
  final List<Announce> announces;

  const AnnouncesLoaded({required this.announces});

  @override
  List<Object> get props => [announces];
}
