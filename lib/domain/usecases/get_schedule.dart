import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetSchedule extends UseCase<Schedule, GetScheduleParams> {
  final ScheduleRepository scheduleRepository;

  GetSchedule(this.scheduleRepository);

  @override
  Future<Either<Failure, Schedule>> call(GetScheduleParams params) async {
    return await scheduleRepository.getSchedule(params.group);
  }
}

class GetScheduleParams extends Equatable {
  final String group;

  GetScheduleParams(this.group);

  @override
  List<Object?> get props => [group];
}
