import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class SendNfcNotExistFeedback
    extends UseCase<void, SendNfcNotExistFeedbackParams> {
  final UserRepository userRepository;

  SendNfcNotExistFeedback(this.userRepository);

  @override
  Future<Either<Failure, void>> call(SendNfcNotExistFeedbackParams params) {
    return userRepository.sendNfcNotExistFeedback(
        params.fullName, params.group, params.personalNumber, params.studentId);
  }
}

class SendNfcNotExistFeedbackParams extends Equatable {
  const SendNfcNotExistFeedbackParams(
      this.fullName, this.group, this.personalNumber, this.studentId);

  final String fullName;
  final String group;
  final String personalNumber;
  final String studentId;

  @override
  List<Object?> get props => [fullName, group, personalNumber, studentId];
}
