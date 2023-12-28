part of 'sponsors_bloc.dart';

abstract class SponsorsEvent extends Equatable {
  const SponsorsEvent();
}

class SponsorsLoadRequest extends SponsorsEvent {
  const SponsorsLoadRequest();

  @override
  List<Object?> get props => [];
}
