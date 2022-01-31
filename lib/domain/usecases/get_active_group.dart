import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetActiveGroup extends UseCase<String, void> {
  final ScheduleRepository scheduleRepository;

  GetActiveGroup(this.scheduleRepository);

  @override
  Future<Either<Failure, String>> call([params]) async {
    return await scheduleRepository.getActiveGroup();
  }
}
