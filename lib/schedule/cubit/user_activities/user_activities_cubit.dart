import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'user_activities_cubit.freezed.dart';
part 'user_activities_status.dart';
part 'user_activities_state.dart';

class UserActivitiesCubit extends Cubit<UserActivitiesState> {
  UserActivitiesCubit({required ScheduleRepository scheduleRepository})
    : _repository = scheduleRepository,
      super(const UserActivitiesState());

  final ScheduleRepository _repository;
  int _loadRevision = 0;

  Future<void> load({required DateTime from, required DateTime to}) async {
    if (!_repository.hasAuthenticatedUser) return;
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final activities = await _repository.getUserActivities(
        from: from,
        to: to,
      );
      if (isClosed || revision != _loadRevision) return;
      emit(
        state.copyWith(
          activities: activities,
          status: .populated,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (isClosed || revision != _loadRevision) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }
}
