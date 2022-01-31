part of 'announces_bloc.dart';

abstract class AnnouncesEvent extends Equatable {
  const AnnouncesEvent();

  @override
  List<Object> get props => [];
}

class LoadAnnounces extends AnnouncesEvent {
  final String token;

  const LoadAnnounces({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}
