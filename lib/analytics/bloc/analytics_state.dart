part of 'analytics_bloc.dart';

@freezed
sealed class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState.initial() = AnalyticsInitial;
}
