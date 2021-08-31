import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/delete_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_active_group.dart';
import 'package:rtu_mirea_app/domain/usecases/get_downloaded_schedules.dart';
import 'package:rtu_mirea_app/domain/usecases/get_groups.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/set_active_group.dart';
import 'package:rtu_mirea_app/domain/usecases/set_schedule_settings.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({
    required this.getSchedule,
    required this.getGroups,
    required this.getActiveGroup,
    required this.setActiveGroup,
    required this.getDownloadedSchedules,
    required this.deleteSchedule,
    required this.getScheduleSettings,
    required this.setScheduleSettings,
  }) : super(ScheduleInitial());

  final GetActiveGroup getActiveGroup;
  final GetSchedule getSchedule;
  final GetGroups getGroups;
  final SetActiveGroup setActiveGroup;
  final GetDownloadedSchedules getDownloadedSchedules;
  final DeleteSchedule deleteSchedule;
  final GetScheduleSettings getScheduleSettings;
  final SetScheduleSettings setScheduleSettings;

  late List<String> groupsList;
  late List<String> downloadedGroups;

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
        final downloadedScheduleGroups = await _getDownloadedScheduleGroups();
        final scheduleSettings = await getScheduleSettings();
        yield schedule.fold(
          (failure) =>
              ScheduleLoadError(errorMessage: _mapFailureToMessage(failure)),
          (schedule) => ScheduleLoaded(
            schedule: schedule,
            activeGroup: activeGroupName!,
            downloadedScheduleGroups: downloadedScheduleGroups,
            groups: groupsList,
            scheduleSettings: scheduleSettings,
          ),
        );
      }
    } else if (event is ScheduleUpdateGroupSuggestionEvent) {
      groupSuggestion = event.suggestion;
    } else if (event is ScheduleSetActiveGroupEvent) {
      if (groupsList.contains(groupSuggestion) || event.group != null) {
        // on update active group from drawer group list
        if (event.group != null) groupSuggestion = event.group!;

        yield ScheduleLoading();

        await setActiveGroup(SetActiveGroupParams(groupSuggestion));

        final schedule =
            await getSchedule(GetScheduleParams(group: groupSuggestion));

        downloadedGroups = await _getDownloadedScheduleGroups();
        final scheduleSettings = await getScheduleSettings();
        yield schedule.fold(
            (failure) =>
                ScheduleLoadError(errorMessage: _mapFailureToMessage(failure)),
            (schedule) => ScheduleLoaded(
                  schedule: schedule,
                  activeGroup: groupSuggestion,
                  downloadedScheduleGroups: downloadedGroups,
                  groups: groupsList,
                  scheduleSettings: scheduleSettings,
                ));
      } else {
        yield ScheduleGroupNotFound();
      }
    } else if (event is ScheduleUpdateEvent) {
      // To not cause schedule updates, but simply update
      // the schedule in the cache

      if (event.group == event.activeGroup) yield ScheduleLoading();

      final schedule = await getSchedule(GetScheduleParams(group: event.group));

      if (event.group == event.activeGroup) {
        downloadedGroups = await _getDownloadedScheduleGroups();
        final scheduleSettings = await getScheduleSettings();
        yield schedule.fold(
          (failure) =>
              ScheduleLoadError(errorMessage: _mapFailureToMessage(failure)),
          (schedule) => ScheduleLoaded(
            schedule: schedule,
            activeGroup: event.activeGroup,
            downloadedScheduleGroups: downloadedGroups,
            groups: groupsList,
            scheduleSettings: scheduleSettings,
          ),
        );
      }
    } else if (event is ScheduleDeleteEvent) {
      await deleteSchedule(DeleteScheduleParams(group: event.group));
      downloadedGroups = await _getDownloadedScheduleGroups();
      final scheduleSettings = await getScheduleSettings();
      yield ScheduleLoaded(
        schedule: event.schedule,
        activeGroup: event.schedule.group,
        downloadedScheduleGroups: downloadedGroups,
        groups: groupsList,
        scheduleSettings: scheduleSettings,
      );
    } else if (event is ScheduleUpdateSettingsEvent) {
      final oldSettings = await getScheduleSettings();
      final newSettings = ScheduleSettings(
        showEmptyLessons:
            event.showEmptyLessons ?? oldSettings.showEmptyLessons,
        showLessonsNumbers:
            event.showEmptyLessons ?? oldSettings.showLessonsNumbers,
      );

      await setScheduleSettings(SetScheduleSettingsParams(newSettings));

      if (state is ScheduleLoaded) {
        final currentState = state as ScheduleLoaded;
        yield ScheduleLoaded(
          schedule: currentState.schedule,
          activeGroup: currentState.schedule.group,
          downloadedScheduleGroups: currentState.downloadedScheduleGroups,
          groups: groupsList,
          scheduleSettings: newSettings,
        );
      }
    }
  }

  /// Returns list of cached schedules or empty list
  Future<List<String>> _getDownloadedScheduleGroups() async {
    late List<String> downloadedScheduleGroups;
    final downloadedSchedules = await getDownloadedSchedules();
    downloadedSchedules.fold((failure) {
      downloadedScheduleGroups = [];
    }, (schedules) {
      downloadedScheduleGroups =
          schedules.map((schedule) => schedule.group).toList();
    });
    return downloadedScheduleGroups;
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

  static Map<String, int> get collegeTimesStart => const {
        "08:45": 1,
        "10:30": 2,
        "12:40": 3,
        "14:20": 4,
      };

  static Map<String, int> get collegeTimesEnd => const {
        "10:15": 1,
        "12:00": 2,
        "14:10": 3,
        "15:50": 4,
      };

  static Map<String, int> get universityTimesStart => const {
        "9:00": 1,
        "10:40": 2,
        "12:40": 3,
        "14:20": 4,
        "16:20": 5,
        "18:00": 6,
        "18:30": 7,
        "20:10": 8
      };

  static Map<String, int> get universityTimesEnd => const {
        "10:30": 1,
        "12:10": 2,
        "14:10": 3,
        "15:50": 4,
        "17:50": 5,
        "19:30": 6,
        "20:00": 7,
        "21:40": 8
      };

  static bool isCollegeGroup(String group) {
    return group[0] == 'Щ';
  }
}
