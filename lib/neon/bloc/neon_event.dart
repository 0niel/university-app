part of 'neon_bloc.dart';

abstract class NeonEvent extends Equatable {
  const NeonEvent();
}

class VieweRegisterOffer extends NeonEvent {
  const VieweRegisterOffer();

  @override
  List<Object?> get props => [];
}
