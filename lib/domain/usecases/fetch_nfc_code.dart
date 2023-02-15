import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

/// Get NFC code from server if device is connected. If device is not connected,
/// then clear all local NFC codes.
///
/// If device is connected, then update local data with new NFC code.
class FetchNfcCode extends UseCase<void, FetchNfcCodeParams> {
  final UserRepository userRepository;

  FetchNfcCode(this.userRepository);

  @override
  Future<Either<Failure, void>> call(FetchNfcCodeParams params) {
    return userRepository.fetchNfcCode(
        params.code, params.studentId, params.deviceId, params.deviceName);
  }
}

class FetchNfcCodeParams extends Equatable {
  const FetchNfcCodeParams(
      this.code, this.studentId, this.deviceId, this.deviceName);

  final String code;
  final String studentId;
  final String deviceId;
  final String deviceName;

  @override
  List<Object?> get props => [code, studentId, deviceId, deviceName];
}
