import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetScheduleSettings extends UseCaseRight<ScheduleSettings, void> {
  final ScheduleRepository scheduleRepository;

  GetScheduleSettings(this.scheduleRepository);

  @override
  Future<ScheduleSettings> call([params]) async {
    return await scheduleRepository.getSettings();
  }
}
