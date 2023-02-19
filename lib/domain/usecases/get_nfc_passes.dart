import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetNfcPasses extends UseCase<List<NfcPass>, GetNfcPassesParams> {
  final UserRepository userRepository;

  GetNfcPasses(this.userRepository);

  @override
  Future<Either<Failure, List<NfcPass>>> call(GetNfcPassesParams params) {
    return userRepository.getNfcPasses(
        params.code, params.studentId, params.deviceId);
  }
}

class GetNfcPassesParams extends Equatable {
  const GetNfcPassesParams(this.code, this.studentId, this.deviceId);

  final String code;
  final String studentId;
  final String deviceId;

  @override
  List<Object?> get props => [code, studentId, deviceId];
}
