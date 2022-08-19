import 'package:rtu_mirea_app/domain/entities/app_settings.dart';
import 'package:rtu_mirea_app/domain/repositories/app_settings_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetAppSettings extends UseCaseRight<AppSettings, void> {
  final AppSettingsRepository appSettingsRepository;

  GetAppSettings(this.appSettingsRepository);

  @override
  Future<AppSettings> call([params]) async {
    return await appSettingsRepository.getSettings();
  }
}
