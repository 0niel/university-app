import 'package:equatable/equatable.dart';

abstract class ScheduleFailure with EquatableMixin implements Exception {
  const ScheduleFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}

class GetScheduleFailure extends ScheduleFailure {
  const GetScheduleFailure(super.error);
}

class GetTeacherScheduleFailure extends ScheduleFailure {
  const GetTeacherScheduleFailure(super.error);
}

class GetClassroomScheduleFailure extends ScheduleFailure {
  const GetClassroomScheduleFailure(super.error);
}

class SearchGroupsFailure extends ScheduleFailure {
  const SearchGroupsFailure(super.error);
}

class SearchClassroomsFailure extends ScheduleFailure {
  const SearchClassroomsFailure(super.error);
}

class SearchTeachersFailure extends ScheduleFailure {
  const SearchTeachersFailure(super.error);
}

class PostLessonReactionFailure extends ScheduleFailure {
  const PostLessonReactionFailure(super.error);
}

class DeleteLessonReactionFailure extends ScheduleFailure {
  const DeleteLessonReactionFailure(super.error);
}

class GetLessonReactionSummaryFailure extends ScheduleFailure {
  const GetLessonReactionSummaryFailure(super.error);
}

class GetLessonDetailsFailure extends ScheduleFailure {
  const GetLessonDetailsFailure(super.error);
}

class UploadLessonMaterialFailure extends ScheduleFailure {
  const UploadLessonMaterialFailure(super.error);
}

class UpsertLessonReviewFailure extends ScheduleFailure {
  const UpsertLessonReviewFailure(super.error);
}

class GetUserActivitiesFailure extends ScheduleFailure {
  const GetUserActivitiesFailure(super.error);
}

class UpsertUserActivityFailure extends ScheduleFailure {
  const UpsertUserActivityFailure(super.error);
}

class DeleteUserActivityFailure extends ScheduleFailure {
  const DeleteUserActivityFailure(super.error);
}

class GetScheduleChangesFailure extends ScheduleFailure {
  const GetScheduleChangesFailure(super.error);
}

class GetExamReadinessFailure extends ScheduleFailure {
  const GetExamReadinessFailure(super.error);
}

class SetExamReadinessFailure extends ScheduleFailure {
  const SetExamReadinessFailure(super.error);
}

class GetDeadlinesFailure extends ScheduleFailure {
  const GetDeadlinesFailure(super.error);
}

class CreateDeadlineFailure extends ScheduleFailure {
  const CreateDeadlineFailure(super.error);
}

class CreateReminderFailure extends ScheduleFailure {
  const CreateReminderFailure(super.error);
}

class SetDeadlineStateFailure extends ScheduleFailure {
  const SetDeadlineStateFailure(super.error);
}

class DeleteDeadlineFailure extends ScheduleFailure {
  const DeleteDeadlineFailure(super.error);
}

class UpdateDeadlineFailure extends ScheduleFailure {
  const UpdateDeadlineFailure(super.error);
}

class PostponeDeadlinesFailure extends ScheduleFailure {
  const PostponeDeadlinesFailure(super.error);
}
