import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetGroups extends UseCase<List<String>, void> {
  final ScheduleRepository scheduleRepository;

  GetGroups(this.scheduleRepository);

  @override
  Future<List<String>> call([_]) async {
    return await scheduleRepository.getAllGroups();
  }
}
