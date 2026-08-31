import 'package:equatable/equatable.dart';

class AnalyticsEvent extends Equatable {
  const AnalyticsEvent(this.name, {this.properties});

  final String name;

  final Map<String, dynamic>? properties;

  @override
  List<Object?> get props => [name, properties];
}

mixin AnalyticsEventMixin on Equatable {
  AnalyticsEvent get event;

  @override
  List<Object> get props => [event];
}
