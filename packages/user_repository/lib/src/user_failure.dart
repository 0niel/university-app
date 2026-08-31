import 'package:equatable/equatable.dart';

abstract class UserFailure with EquatableMixin implements Exception {
  const UserFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

class FetchAppOpenedCountFailure extends UserFailure {
  const FetchAppOpenedCountFailure(super.error);
}

class IncrementAppOpenedCountFailure extends UserFailure {
  const IncrementAppOpenedCountFailure(super.error);
}
