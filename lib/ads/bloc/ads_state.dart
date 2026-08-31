part of 'ads_bloc.dart';

@freezed
abstract class AdsState with _$AdsState {
  const factory AdsState({@Default(true) bool showAds}) = _AdsState;

  factory AdsState.fromJson(Map<String, dynamic> json) =>
      _$AdsStateFromJson(json);
}
