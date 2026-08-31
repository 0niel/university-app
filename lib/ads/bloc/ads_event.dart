part of 'ads_bloc.dart';

abstract class AdsEvent extends Equatable {
  const AdsEvent();

  @override
  List<Object?> get props => [];
}

class AdsVisibilityChanged extends AdsEvent {
  const AdsVisibilityChanged({required this.showAds});

  final bool showAds;

  @override
  List<Object?> get props => [showAds];
}
