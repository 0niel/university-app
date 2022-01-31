import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetDownloadedSchedules extends UseCase<List<Schedule>, void> {
  final ScheduleRepository scheduleRepository;

  GetDownloadedSchedules(this.scheduleRepository);

  @override
  Future<Either<Failure, List<Schedule>>> call([params]) async {
    return await scheduleRepository.getDownloadedSchedules();
  }
}
