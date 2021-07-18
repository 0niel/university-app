import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class IsGroupExist extends UseCase<bool, IsGroupExistParams> {
  final ScheduleRepository scheduleRepository;

  IsGroupExist(this.scheduleRepository);

  @override
  Future<Either<Failure, bool>> call(IsGroupExistParams params) async {
    final getGroups = await scheduleRepository.getAllGroups();
    return getGroups.fold(
        (l) => Left(l), (r) => Right(r.contains(params.group)));
  }
}

class IsGroupExistParams extends Equatable {
  final String group;

  IsGroupExistParams(this.group);

  @override
  List<Object?> get props => [group];
}
