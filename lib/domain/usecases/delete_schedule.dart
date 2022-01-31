import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class DeleteSchedule extends UseCase<void, DeleteScheduleParams> {
  final ScheduleRepository scheduleRepository;

  DeleteSchedule(this.scheduleRepository);

  @override
  Future<Either<Failure, void>> call(DeleteScheduleParams params) async {
    return Right(await scheduleRepository.deleteSchedule(params.group));
  }
}

class DeleteScheduleParams extends Equatable {
  final String group;

  const DeleteScheduleParams({required this.group});

  @override
  List<Object?> get props => [group];
}
