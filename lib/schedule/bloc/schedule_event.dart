part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class SetLessonComment extends ScheduleEvent with AnalyticsEventMixin {
  const SetLessonComment({
    required this.comment,
  });

  final LessonComment comment;

  @override
  AnalyticsEvent get event => const AnalyticsEvent('SetLessonComment');

  @override
  List<Object> get props => [comment];
}

class ScheduleRequested extends ScheduleEvent with AnalyticsEventMixin {
  const ScheduleRequested({
    required this.group,
  });

  final Group group;

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        'ScheduleRequested',
        properties: {
          'group': group.name,
        },
      );

  @override
  List<Object> get props => [group];
}

class ClassroomScheduleRequested extends ScheduleEvent with AnalyticsEventMixin {
  const ClassroomScheduleRequested({
    required this.classroom,
  });

  final Classroom classroom;

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        'ClassroomScheduleRequested',
        properties: {
          'classroom': classroom.name,
          'campus': classroom.campus?.name,
        },
      );

  @override
  List<Object> get props => [classroom];
}

class TeacherScheduleRequested extends ScheduleEvent with AnalyticsEventMixin {
  const TeacherScheduleRequested({
    required this.teacher,
  });

  final Teacher teacher;

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        'TeacherScheduleRequested',
        properties: {
          'teacher': teacher.name,
        },
      );

  @override
  List<Object> get props => [teacher];
}

class RefreshSelectedScheduleData extends ScheduleEvent {
  const RefreshSelectedScheduleData();

  @override
  List<Object> get props => [];
}

class ScheduleSetDisplayMode extends ScheduleEvent {
  const ScheduleSetDisplayMode({
    required this.isMiniature,
  });

  final bool isMiniature;

  @override
  List<Object> get props => [isMiniature];
}

class ScheduleSetEmptyLessonsDisplaying extends ScheduleEvent {
  const ScheduleSetEmptyLessonsDisplaying({
    required this.showEmptyLessons,
  });

  final bool showEmptyLessons;

  @override
  List<Object> get props => [showEmptyLessons];
}

class SetShowCommentsIndicator extends ScheduleEvent {
  const SetShowCommentsIndicator({
    required this.showCommentsIndicators,
  });

  final bool showCommentsIndicators;

  @override
  List<Object> get props => [showCommentsIndicators];
}

class SetSelectedSchedule extends ScheduleEvent with AnalyticsEventMixin {
  const SetSelectedSchedule({
    required this.selectedSchedule,
  });

  final SelectedSchedule selectedSchedule;

  @override
  List<Object> get props => [selectedSchedule];

  @override
  AnalyticsEvent get event {
    if (selectedSchedule is SelectedGroupSchedule) {
      final group = (selectedSchedule as SelectedGroupSchedule).group;
      return AnalyticsEvent('SetSelectedGroupSchedule', properties: {
        'group': group.name,
      });
    } else if (selectedSchedule is SelectedClassroomSchedule) {
      final classroom = (selectedSchedule as SelectedClassroomSchedule).classroom;
      return AnalyticsEvent('SetSelectedClassroomSchedule', properties: {
        'classroom': classroom.name,
        'campus': classroom.campus?.name,
      });
    } else if (selectedSchedule is SelectedTeacherSchedule) {
      final teacher = (selectedSchedule as SelectedTeacherSchedule).teacher;
      return AnalyticsEvent('SetSelectedTeacherSchedule', properties: {
        'teacher': teacher.name,
      });
    }

    return const AnalyticsEvent('SetSelectedSchedule');
  }
}

class DeleteSchedule extends ScheduleEvent {
  const DeleteSchedule({
    required this.identifier,
    required this.target,
  });

  final UID identifier;
  final ScheduleTarget target;

  @override
  List<Object> get props => [identifier, target];
}

class ToggleListMode extends ScheduleEvent {
  const ToggleListMode();

  @override
  List<Object> get props => [];
}

class AddScheduleComment extends ScheduleEvent {
  final ScheduleComment comment;

  const AddScheduleComment(this.comment);

  @override
  List<Object?> get props => [comment];
}

class DeleteScheduleComment extends ScheduleEvent {
  final String scheduleName;

  const DeleteScheduleComment(this.scheduleName);

  @override
  List<Object?> get props => [scheduleName];
}

class ImportScheduleFromJson extends ScheduleEvent {
  final String jsonString;

  const ImportScheduleFromJson(this.jsonString);

  @override
  List<Object> get props => [jsonString];
}
