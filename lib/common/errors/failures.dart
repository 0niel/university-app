import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? cause;

  const Failure([this.cause]);

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure([super.cause]);
}

class NfcStaffnodeNotExistFailure extends ServerFailure {
  const NfcStaffnodeNotExistFailure();
}

class CacheFailure extends Failure {
  const CacheFailure([super.cause]);
}
