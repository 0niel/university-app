import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetGroups extends UseCase<List<String>, void> {
  final ScheduleRepository scheduleRepository;

  GetGroups(this.scheduleRepository);

  @override
  Future<Either<Failure, List<String>>> call([params]) async {
    return await scheduleRepository.getAllGroups();
  }
}
