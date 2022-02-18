import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/common/widget_data_init.dart';
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
  }) : super(ScheduleInitial()) {
    on<ScheduleOpenEvent>(_onScheduleOpenEvent);
    on<ScheduleUpdateGroupSuggestionEvent>(
        _onScheduleUpdateGroupSuggestionEvent);
    on<ScheduleSetActiveGroupEvent>(_onScheduleSetActiveGroupEvent);
    on<ScheduleUpdateEvent>(_onScheduleUpdateEvent);
    on<ScheduleDeleteEvent>(_onScheduleDeleteEvent);
    on<ScheduleUpdateSettingsEvent>(_onScheduleUpdateSettingsEvent);
  }

  final GetActiveGroup getActiveGroup;
  final GetSchedule getSchedule;
  final GetGroups getGroups;
  final SetActiveGroup setActiveGroup;
  final GetDownloadedSchedules getDownloadedSchedules;
  final DeleteSchedule deleteSchedule;
  final GetScheduleSettings getScheduleSettings;
  final SetScheduleSettings setScheduleSettings;

  /// List of all groups (1028+)
  static List<String> groupsList = [];

  late List<String> _downloadedGroups;

  /// [_groupSuggestion] is used when selecting a group in [AutocompleteGroupSelector]
  String _groupSuggestion = '';

  void _onScheduleOpenEvent(
    ScheduleOpenEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    // Getting a list of all groups from a remote API
    _downloadGroups();

    // The group for which the schedule is selected
    final activeGroup = await getActiveGroup();

    await activeGroup.fold((failure) {
      emit(ScheduleActiveGroupEmpty(groups: groupsList));
    }, (activeGroupName) async {
      final schedule = await getSchedule(
          GetScheduleParams(group: activeGroupName, fromRemote: false));
      final downloadedScheduleGroups = await _getAllDownloadedScheduleGroups();
      final scheduleSettings = await getScheduleSettings();

      // If we have a schedule in the cache then we display it
      // to avoid a long download from the Internet.
      // Otherwise, download the schedule.
      await schedule.fold((failure) async {
        emit(ScheduleLoading());
        final remoteSchedule = await getSchedule(
            GetScheduleParams(group: activeGroupName, fromRemote: true));
        emit(remoteSchedule.fold(
            (failureRemote) => ScheduleLoadError(
                errorMessage: _mapFailureToMessage(failureRemote)),
            (scheduleFromRemote) => ScheduleLoaded(
                  schedule: scheduleFromRemote,
                  activeGroup: activeGroupName,
                  downloadedScheduleGroups: downloadedScheduleGroups,
                  scheduleSettings: scheduleSettings,
                )));
      }, (localSchedule) async {
        // display cached schedule
        emit(ScheduleLoaded(
          schedule: localSchedule,
          activeGroup: activeGroupName,
          downloadedScheduleGroups: downloadedScheduleGroups,
          scheduleSettings: scheduleSettings,
        ));

        // We will update the schedule, but without the loading indicator
        final remoteSchedule = await getSchedule(
            GetScheduleParams(group: activeGroupName, fromRemote: true));
        if (remoteSchedule.isRight()) {
          emit(remoteSchedule.foldRight(
            ScheduleInitial(),
            (actualSchedule, previous) => ScheduleLoaded(
              schedule: actualSchedule,
              activeGroup: activeGroupName,
              downloadedScheduleGroups: downloadedScheduleGroups,
              scheduleSettings: scheduleSettings,
            ),
          ));
        }
      });
    });
  }

  void _onScheduleUpdateGroupSuggestionEvent(
    ScheduleUpdateGroupSuggestionEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    _groupSuggestion = event.suggestion;
  }

  void _onScheduleSetActiveGroupEvent(
    ScheduleSetActiveGroupEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    if (groupsList.contains(_groupSuggestion) || event.group != null) {
      // on update active group from drawer group list
      if (event.group != null) _groupSuggestion = event.group!;

      emit(ScheduleLoading());

      await setActiveGroup(SetActiveGroupParams(_groupSuggestion));

      final schedule = await getSchedule(
          GetScheduleParams(group: _groupSuggestion, fromRemote: true));

      _downloadedGroups = await _getAllDownloadedScheduleGroups();
      final scheduleSettings = await getScheduleSettings();
      emit(schedule.fold(
          (failure) =>
              ScheduleLoadError(errorMessage: _mapFailureToMessage(failure)),
          (schedule) {
        // Set home widget info
        WidgetDataProvider.setSchedule(schedule);

        // Set app info
        return ScheduleLoaded(
          schedule: schedule,
          activeGroup: _groupSuggestion,
          downloadedScheduleGroups: _downloadedGroups,
          scheduleSettings: scheduleSettings,
        );
      }));
    } else {
      emit(ScheduleGroupNotFound());
    }
  }

  void _onScheduleUpdateEvent(
    ScheduleUpdateEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    // To not cause schedule updates, but simply update
    // the schedule in the cache

    if (event.group == event.activeGroup) emit(ScheduleLoading());

    final schedule = await getSchedule(
        GetScheduleParams(group: event.group, fromRemote: true));

    if (event.group == event.activeGroup) {
      _downloadedGroups = await _getAllDownloadedScheduleGroups();
      final scheduleSettings = await getScheduleSettings();
      emit(schedule.fold(
        (failure) =>
            ScheduleLoadError(errorMessage: _mapFailureToMessage(failure)),
        (schedule) => ScheduleLoaded(
          schedule: schedule,
          activeGroup: event.activeGroup,
          downloadedScheduleGroups: _downloadedGroups,
          scheduleSettings: scheduleSettings,
        ),
      ));
    }
  }

  void _onScheduleDeleteEvent(
    ScheduleDeleteEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    await deleteSchedule(DeleteScheduleParams(group: event.group));
    _downloadedGroups = await _getAllDownloadedScheduleGroups();
    final scheduleSettings = await getScheduleSettings();
    emit(ScheduleLoaded(
      schedule: event.schedule,
      activeGroup: event.schedule.group,
      downloadedScheduleGroups: _downloadedGroups,
      scheduleSettings: scheduleSettings,
    ));
  }

  void _onScheduleUpdateSettingsEvent(
    ScheduleUpdateSettingsEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    final oldSettings = await getScheduleSettings();
    final newSettings = ScheduleSettings(
      showEmptyLessons: event.showEmptyLessons ?? oldSettings.showEmptyLessons,
      showLessonsNumbers:
          event.showEmptyLessons ?? oldSettings.showLessonsNumbers,
      calendarFormat: event.calendarFormat ?? oldSettings.calendarFormat,
    );

    await setScheduleSettings(SetScheduleSettingsParams(newSettings));

    if (state is ScheduleLoaded) {
      final currentState = state as ScheduleLoaded;
      emit(ScheduleLoaded(
        schedule: currentState.schedule,
        activeGroup: currentState.schedule.group,
        downloadedScheduleGroups: currentState.downloadedScheduleGroups,
        scheduleSettings: newSettings,
      ));
    }
  }

  Future<void> _downloadGroups() async {
    if (groupsList.isEmpty) {
      final groups = await getGroups();
      groups.fold(
          (failure) => groupsList = [], (groups) => groupsList = groups);
    }
  }

  /// Returns list of cached schedules or empty list
  Future<List<String>> _getAllDownloadedScheduleGroups() async {
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
}
