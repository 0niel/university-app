import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
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

  /// It is used to display the list of groups. It is downloaded from the
  /// Internet once when the schedule page is opened. While downloading,
  /// state [ScheduleLoading] is displayed.
  List<String> _groupsList = [];

  // It is used to display the list of groups by institute in the group
  // selection page. It is stored in the assets folder and is opened once when
  // the schedule page is opened. While downloading, state [ScheduleLoading] is
  // displayed. Format: {institute: [group1, group2, ...]}, where institute is
  // the short name of the institute, for example, "ИИТ" or "ИИИ", and group1,
  // group2, ... are the names only of the groups of this institute, for  example,
  // "ИКБО", "ИВБО", etc. Groups names are unique.
  late final Map<String, List<String>> _groupsByInstitute;

  late List<String> _downloadedGroups;

  void _onScheduleOpenEvent(
    ScheduleOpenEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    if (_groupsList.isEmpty) {
      emit(ScheduleLoading());
      // Getting a list of all groups from a remote API
      await _downloadGroups();

      final rawJson =
          await rootBundle.loadString('assets/json/groups_by_institute.json');
      _groupsByInstitute = {
        for (final entry in json.decode(rawJson).entries)
          entry.key: List<String>.from(entry.value)
      };
    }

    // The group for which the schedule is selected
    final activeGroup = await getActiveGroup();

    await activeGroup.fold((failure) {
      emit(ScheduleActiveGroupEmpty(
          groups: _groupsList, groupsByInstitute: _groupsByInstitute));
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
        emit(
          remoteSchedule.fold(
            (failureRemote) => ScheduleLoadError(
                errorMessage: _mapFailureToMessage(failureRemote)),
            (scheduleFromRemote) => ScheduleLoaded(
              schedule: scheduleFromRemote,
              activeGroup: activeGroupName,
              downloadedScheduleGroups: downloadedScheduleGroups,
              scheduleSettings: scheduleSettings,
              groups: _groupsList,
              groupsByInstitute: _groupsByInstitute,
            ),
          ),
        );
      }, (localSchedule) async {
        // display cached schedule
        emit(ScheduleLoaded(
          schedule: localSchedule,
          activeGroup: activeGroupName,
          downloadedScheduleGroups: downloadedScheduleGroups,
          scheduleSettings: scheduleSettings,
          groups: _groupsList,
          groupsByInstitute: _groupsByInstitute,
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
              groups: _groupsList,
              groupsByInstitute: _groupsByInstitute,
            ),
          ));
        }
      });
    });
  }

  void _onScheduleSetActiveGroupEvent(
    ScheduleSetActiveGroupEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    if (_groupsList.contains(event.group)) {
      emit(ScheduleLoading());

      await setActiveGroup(SetActiveGroupParams(event.group));

      final schedule = await getSchedule(
          GetScheduleParams(group: event.group, fromRemote: true));

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
          activeGroup: event.group,
          downloadedScheduleGroups: _downloadedGroups,
          scheduleSettings: scheduleSettings,
          groups: _groupsList,
          groupsByInstitute: _groupsByInstitute,
        );
      }));
    } else {
      emit(ScheduleActiveGroupEmpty(
          groups: _groupsList, groupsByInstitute: _groupsByInstitute));
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
          groups: _groupsList,
          groupsByInstitute: _groupsByInstitute,
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
      groups: _groupsList,
      groupsByInstitute: _groupsByInstitute,
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
        groups: currentState.groups,
        groupsByInstitute: _groupsByInstitute,
      ));
    }
  }

  Future<void> _downloadGroups() async {
    final groups = await getGroups();
    groups.fold(
        (failure) => _groupsList = [], (groups) => _groupsList = groups);
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
