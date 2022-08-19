import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetAnnounces extends UseCase<List<Announce>, GetAnnouncesParams> {
  final UserRepository userRepository;

  GetAnnounces(this.userRepository);

  @override
  Future<Either<Failure, List<Announce>>> call(
      GetAnnouncesParams params) async {
    return await userRepository.getAnnounces(params.token);
  }
}

class GetAnnouncesParams extends Equatable {
  final String token;
  const GetAnnouncesParams(this.token);

  @override
  List<Object?> get props => [token];
}
