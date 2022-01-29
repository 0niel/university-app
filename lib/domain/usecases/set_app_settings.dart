import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/app_settings.dart';
import 'package:rtu_mirea_app/domain/repositories/app_settings_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class SetAppSettings extends UseCase<void, SetAppSettingsParams> {
  final AppSettingsRepository appSettingsRepository;

  SetAppSettings(this.appSettingsRepository);

  @override
  Future<Either<Failure, void>> call(SetAppSettingsParams params) async {
    return Right(appSettingsRepository.setSettings(params.settings));
  }
}

class SetAppSettingsParams extends Equatable {
  final AppSettings settings;

  const SetAppSettingsParams(this.settings);

  @override
  List<Object?> get props => [settings];
}
