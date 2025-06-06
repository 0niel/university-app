part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class SetLessonComment extends ScheduleEvent with AnalyticsEventMixin {
  const SetLessonComment({required this.comment});

  final LessonComment comment;

  @override
  AnalyticsEvent get event => const AnalyticsEvent('SetLessonComment');

  @override
  List<Object> get props => [comment];
}

class ScheduleRequested extends ScheduleEvent with AnalyticsEventMixin {
  const ScheduleRequested({required this.group});

  final Group group;

  @override
  AnalyticsEvent get event => AnalyticsEvent('ScheduleRequested', properties: {'group': group.name});

  @override
  List<Object> get props => [group];
}

class ClassroomScheduleRequested extends ScheduleEvent with AnalyticsEventMixin {
  const ClassroomScheduleRequested({required this.classroom});

  final Classroom classroom;

  @override
  AnalyticsEvent get event => AnalyticsEvent(
    'ClassroomScheduleRequested',
    properties: {'classroom': classroom.name, 'campus': classroom.campus?.name},
  );

  @override
  List<Object> get props => [classroom];
}

class TeacherScheduleRequested extends ScheduleEvent with AnalyticsEventMixin {
  const TeacherScheduleRequested({required this.teacher});

  final Teacher teacher;

  @override
  AnalyticsEvent get event => AnalyticsEvent('TeacherScheduleRequested', properties: {'teacher': teacher.name});

  @override
  List<Object> get props => [teacher];
}

class RefreshSelectedScheduleData extends ScheduleEvent {
  const RefreshSelectedScheduleData();

  @override
  List<Object> get props => [];
}

class ScheduleSetDisplayMode extends ScheduleEvent {
  const ScheduleSetDisplayMode({required this.isMiniature});

  final bool isMiniature;

  @override
  List<Object> get props => [isMiniature];
}

class ScheduleSetEmptyLessonsDisplaying extends ScheduleEvent {
  const ScheduleSetEmptyLessonsDisplaying({required this.showEmptyLessons});

  final bool showEmptyLessons;

  @override
  List<Object> get props => [showEmptyLessons];
}

class SetShowCommentsIndicator extends ScheduleEvent {
  const SetShowCommentsIndicator({required this.showCommentsIndicators});

  final bool showCommentsIndicators;

  @override
  List<Object> get props => [showCommentsIndicators];
}

class SetSelectedSchedule extends ScheduleEvent with AnalyticsEventMixin {
  const SetSelectedSchedule({required this.selectedSchedule});

  final SelectedSchedule selectedSchedule;

  @override
  List<Object> get props => [selectedSchedule];

  @override
  AnalyticsEvent get event {
    if (selectedSchedule is SelectedGroupSchedule) {
      final group = (selectedSchedule as SelectedGroupSchedule).group;
      return AnalyticsEvent('SetSelectedGroupSchedule', properties: {'group': group.name});
    } else if (selectedSchedule is SelectedClassroomSchedule) {
      final classroom = (selectedSchedule as SelectedClassroomSchedule).classroom;
      return AnalyticsEvent(
        'SetSelectedClassroomSchedule',
        properties: {'classroom': classroom.name, 'campus': classroom.campus?.name},
      );
    } else if (selectedSchedule is SelectedTeacherSchedule) {
      final teacher = (selectedSchedule as SelectedTeacherSchedule).teacher;
      return AnalyticsEvent('SetSelectedTeacherSchedule', properties: {'teacher': teacher.name});
    }

    return const AnalyticsEvent('SetSelectedSchedule');
  }
}

class DeleteSchedule extends ScheduleEvent {
  const DeleteSchedule({required this.identifier, required this.target});

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

class SetScheduleComment extends ScheduleEvent {
  final ScheduleComment comment;

  const SetScheduleComment(this.comment);

  @override
  List<Object> get props => [comment];
}

class RemoveScheduleComment extends ScheduleEvent {
  final String scheduleName;

  const RemoveScheduleComment(this.scheduleName);

  @override
  List<Object> get props => [scheduleName];
}

class DeleteScheduleComment extends ScheduleEvent {
  final String scheduleName;

  const DeleteScheduleComment(this.scheduleName);

  @override
  List<Object> get props => [scheduleName];
}

class ImportScheduleFromJson extends ScheduleEvent {
  final String jsonString;

  const ImportScheduleFromJson(this.jsonString);

  @override
  List<Object> get props => [jsonString];
}

class AddScheduleToComparison extends ScheduleEvent with AnalyticsEventMixin {
  const AddScheduleToComparison(this.schedule);

  final SelectedSchedule schedule;

  @override
  AnalyticsEvent get event => const AnalyticsEvent('AddScheduleToComparison');

  @override
  List<Object> get props => [schedule];
}

class RemoveScheduleFromComparison extends ScheduleEvent with AnalyticsEventMixin {
  const RemoveScheduleFromComparison(this.schedule);

  final SelectedSchedule schedule;

  @override
  AnalyticsEvent get event => const AnalyticsEvent('RemoveScheduleFromComparison');

  @override
  List<Object> get props => [schedule];
}

class ToggleComparisonMode extends ScheduleEvent {
  const ToggleComparisonMode();

  @override
  List<Object> get props => [];
}

class HideScheduleDiffDialog extends ScheduleEvent {
  const HideScheduleDiffDialog();

  @override
  List<Object> get props => [];
}

class ToggleSplitView extends ScheduleEvent {
  const ToggleSplitView();
}

class SetAnalyticsVisibility extends ScheduleEvent {
  final bool showAnalytics;

  const SetAnalyticsVisibility({required this.showAnalytics});

  @override
  List<Object> get props => [showAnalytics];
}

// Custom schedule events
class CreateCustomSchedule extends ScheduleEvent with AnalyticsEventMixin {
  final String name;
  final String? description;

  const CreateCustomSchedule({required this.name, this.description});

  @override
  AnalyticsEvent get event => const AnalyticsEvent('CreateCustomSchedule');

  @override
  List<Object> get props => [name, if (description != null) description!];
}

class DeleteCustomSchedule extends ScheduleEvent with AnalyticsEventMixin {
  final String scheduleId;

  const DeleteCustomSchedule({required this.scheduleId});

  @override
  AnalyticsEvent get event => const AnalyticsEvent('DeleteCustomSchedule');

  @override
  List<Object> get props => [scheduleId];
}

class UpdateCustomSchedule extends ScheduleEvent with AnalyticsEventMixin {
  final CustomSchedule schedule;

  const UpdateCustomSchedule({required this.schedule});

  @override
  AnalyticsEvent get event => const AnalyticsEvent('UpdateCustomSchedule');

  @override
  List<Object> get props => [schedule];
}

class AddLessonToCustomSchedule extends ScheduleEvent with AnalyticsEventMixin {
  final String scheduleId;
  final LessonSchedulePart lesson;

  const AddLessonToCustomSchedule({required this.scheduleId, required this.lesson});

  @override
  AnalyticsEvent get event => const AnalyticsEvent('AddLessonToCustomSchedule');

  @override
  List<Object> get props => [scheduleId, lesson];
}

class RemoveLessonFromCustomSchedule extends ScheduleEvent with AnalyticsEventMixin {
  final String scheduleId;
  final LessonSchedulePart lesson;

  const RemoveLessonFromCustomSchedule({required this.scheduleId, required this.lesson});

  @override
  AnalyticsEvent get event => const AnalyticsEvent('RemoveLessonFromCustomSchedule');

  @override
  List<Object> get props => [scheduleId, lesson];
}

class SelectCustomSchedule extends ScheduleEvent with AnalyticsEventMixin {
  final String scheduleId;

  const SelectCustomSchedule({required this.scheduleId});

  @override
  AnalyticsEvent get event => const AnalyticsEvent('SelectCustomSchedule');

  @override
  List<Object> get props => [scheduleId];
}

class ToggleCustomScheduleMode extends ScheduleEvent {
  const ToggleCustomScheduleMode();

  @override
  List<Object> get props => [];
}
