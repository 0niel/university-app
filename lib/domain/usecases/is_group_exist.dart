import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class IsGroupExist extends UseCase<bool, IsGroupExistParams> {
  final ScheduleRepository scheduleRepository;

  IsGroupExist(this.scheduleRepository);

  @override
  Future<bool> call(IsGroupExistParams params) async {
    List<String> groups = await scheduleRepository.getAllGroups();
    return groups.contains(params.group);
  }
}

class IsGroupExistParams extends Equatable {
  final String group;

  IsGroupExistParams(this.group);

  @override
  List<Object?> get props => [group];
}
