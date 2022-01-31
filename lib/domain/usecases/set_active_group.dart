import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class SetActiveGroup extends UseCase<void, SetActiveGroupParams> {
  final ScheduleRepository scheduleRepository;

  SetActiveGroup(this.scheduleRepository);

  @override
  Future<Either<Failure, void>> call(SetActiveGroupParams params) async {
    return Right(scheduleRepository.setActiveGroup(params.group));
  }
}

class SetActiveGroupParams extends Equatable {
  final String group;

  const SetActiveGroupParams(this.group);

  @override
  List<Object?> get props => [group];
}
