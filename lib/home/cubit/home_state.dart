part of 'home_cubit.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(AppSettings(onboardingShown: false)) AppSettings settings,
    @JsonKey(name: 'search_coach_shown') @Default(false) bool searchCoachShown,
  }) = _HomeState;

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);
}
