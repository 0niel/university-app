import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class SetScheduleSettings extends UseCase<void, SetScheduleSettingsParams> {
  final ScheduleRepository scheduleRepository;

  SetScheduleSettings(this.scheduleRepository);

  @override
  Future<Either<Failure, void>> call(SetScheduleSettingsParams params) async {
    return Right(scheduleRepository.setSettings(params.settings));
  }
}

class SetScheduleSettingsParams extends Equatable {
  final ScheduleSettings settings;

  const SetScheduleSettingsParams(this.settings);

  @override
  List<Object?> get props => [settings];
}
