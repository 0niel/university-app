import 'package:equatable/equatable.dart';

abstract class NetworkLocationFailure with EquatableMixin implements Exception {
  const NetworkLocationFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}
