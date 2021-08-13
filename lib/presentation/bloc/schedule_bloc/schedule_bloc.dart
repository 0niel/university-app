import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_active_group.dart';
import 'package:rtu_mirea_app/domain/usecases/get_groups.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/set_active_group.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({
    required this.getSchedule,
    required this.getGroups,
    required this.getActiveGroup,
    required this.setActiveGroup,
  }) : super(ScheduleInitial());

  final GetActiveGroup getActiveGroup;
  final GetSchedule getSchedule;
  final GetGroups getGroups;
  final SetActiveGroup setActiveGroup;

  late final List<String> groupsList;

  /// [groupSuggestion] is used when selecting a group in [AutocompleteGroupSelector]
  String groupSuggestion = '';

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    if (event is ScheduleOpenEvent) {
      final activeGroup = await getActiveGroup();
      final groups = await getGroups();

      groups.fold((failure) {
        groupsList = [];
      }, (groups) {
        groupsList = groups;
      });

      String? activeGroupName;
      yield activeGroup.fold(
        (failure) => ScheduleActiveGroupEmpty(groups: groupsList),
        (group) {
          activeGroupName = group;
          return ScheduleLoading();
        },
      );

      if (activeGroupName != null) {
        final schedule =
            await getSchedule(GetScheduleParams(group: activeGroupName!));

        schedule.fold(
          (failure) => ScheduleLoadError(
              errorMessage:
                  'Произошла ошибка при попытке получить расписание. Проверьте ваше интернет-соединение.'),
          (schedule) => ScheduleLoaded(schedule: schedule),
        );
      }
    } else if (event is ScheduleUpdateGroupSuggestionEvent) {
      groupSuggestion = event.suggestion;
    } else if (event is ScheduleSetActiveGroupEvent) {
      if (groupsList.contains(groupSuggestion)) {
        yield ScheduleLoading();

        await setActiveGroup(SetActiveGroupParams(groupSuggestion));
        final schedule =
            await getSchedule(GetScheduleParams(group: groupSuggestion));

        yield schedule.fold(
            (failure) =>
                ScheduleLoadError(errorMessage: _mapFailureToMessage(failure)),
            (schedule) => ScheduleLoaded(schedule: schedule));
      } else {
        yield ScheduleGroupNotFound();
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Произошла ошибка при загрузке данных. Пожалуйста, проверьте ваше интернет-соединение';
      case CacheFailure:
        return 'Произошла ошибка при загрузке данных';
      default:
        return 'Unexpected Error';
    }
  }
}
