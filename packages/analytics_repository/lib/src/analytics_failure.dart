import 'package:equatable/equatable.dart';

abstract class AnalyticsFailure with EquatableMixin implements Exception {
  const AnalyticsFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

class TrackEventFailure extends AnalyticsFailure {
  const TrackEventFailure(super.error);
}

class SetUserIdFailure extends AnalyticsFailure {
  const SetUserIdFailure(super.error);
}
