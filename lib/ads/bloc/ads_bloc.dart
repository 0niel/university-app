import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class AdsEvent extends Equatable {
  const AdsEvent();
  @override
  List<Object?> get props => [];
}

class SetAdsVisibility extends AdsEvent {
  final bool showAds;
  const SetAdsVisibility({required this.showAds});
  @override
  List<Object?> get props => [showAds];
}

class AdsState extends Equatable {
  final bool showAds;
  const AdsState({required this.showAds});
  @override
  List<Object?> get props => [showAds];

  AdsState copyWith({bool? showAds}) => AdsState(
        showAds: showAds ?? this.showAds,
      );

  Map<String, dynamic> toMap() => {'showAds': showAds};

  factory AdsState.fromMap(Map<String, dynamic> map) => AdsState(
        showAds: map['showAds'] as bool? ?? true,
      );
}

class AdsBloc extends HydratedBloc<AdsEvent, AdsState> {
  AdsBloc() : super(const AdsState(showAds: true)) {
    on<SetAdsVisibility>((event, emit) {
      emit(state.copyWith(showAds: event.showAds));
    });
  }

  @override
  AdsState? fromJson(Map<String, dynamic> json) {
    try {
      return AdsState.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AdsState state) {
    return state.toMap();
  }
}
