part of 'analytics_bloc.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
}

class AnalyticsEventTracked extends AnalyticsEvent {
  late final analytics.AnalyticsEvent event;

  @override
  List<Object> get props => [event];
}
