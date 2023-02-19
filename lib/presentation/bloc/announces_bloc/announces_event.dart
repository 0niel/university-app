part of 'announces_bloc.dart';

abstract class AnnouncesEvent extends Equatable {
  const AnnouncesEvent();

  @override
  List<Object> get props => [];
}

class LoadAnnounces extends AnnouncesEvent {
  const LoadAnnounces();

  @override
  List<Object> get props => [];
}
