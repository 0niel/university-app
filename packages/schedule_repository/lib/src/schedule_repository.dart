import 'package:schedule/schedule.dart' as domain;
import 'package:schedule_repository/src/data/deadlines_data_source.dart';
import 'package:schedule_repository/src/data/exam_readiness_data_source.dart';
import 'package:schedule_repository/src/data/lesson_materials_data_source.dart';
import 'package:schedule_repository/src/data/lesson_reactions_data_source.dart';
import 'package:schedule_repository/src/data/schedule_changes_data_source.dart';
import 'package:schedule_repository/src/data/schedule_remote_data_source.dart';
import 'package:schedule_repository/src/data/user_activities_data_source.dart';
import 'package:schedule_repository/src/deadline.dart';
import 'package:schedule_repository/src/deadline_priority.dart';
import 'package:schedule_repository/src/deadline_source.dart';
import 'package:schedule_repository/src/exam_readiness.dart';
import 'package:schedule_repository/src/lesson_details.dart';
import 'package:schedule_repository/src/schedule_change.dart';
import 'package:schedule_repository/src/schedule_failure.dart';
import 'package:schedule_repository/src/schedule_responses.dart';
import 'package:schedule_repository/src/schedule_target_type.dart';
import 'package:schedule_repository/src/user_activity.dart';
import 'package:supabase/supabase.dart';

/// {@template schedule_repository}
/// Orchestrates schedule data through Supabase.
///
/// The repository is a thin facade over focused data sources
/// ([ScheduleRemoteDataSource], [LessonReactionsDataSource] and
/// [LessonMaterialsDataSource]). Its only added responsibility is translating
/// low-level errors into typed [ScheduleFailure]s.
/// {@endtemplate}
class ScheduleRepository {
  /// {@macro schedule_repository}
  ScheduleRepository({
    required SupabaseClient supabaseClient,
    required String organizationId,
  }) : _auth = supabaseClient.auth,
       _schedule = ScheduleRemoteDataSource(
         supabaseClient: supabaseClient,
         organizationId: organizationId,
       ),
       _reactions = LessonReactionsDataSource(supabaseClient: supabaseClient),
       _materials = LessonMaterialsDataSource(
         supabaseClient: supabaseClient,
         organizationId: organizationId,
       ),
       _activities = UserActivitiesDataSource(
         supabaseClient: supabaseClient,
         organizationId: organizationId,
       ),
       _changes = ScheduleChangesDataSource(
         supabaseClient: supabaseClient,
         organizationId: organizationId,
       ),
       _examReadiness = ExamReadinessDataSource(supabaseClient, organizationId),
       _deadlines = DeadlinesDataSource(
         supabaseClient: supabaseClient,
         organizationId: organizationId,
       );

  /// {@template schedule_repository.test}
  /// Test seam that lets unit tests inject fake data sources.
  /// {@endtemplate}
  const ScheduleRepository.fromDataSources({
    required this._auth,
    required this._schedule,
    required this._reactions,
    required this._materials,
    required this._activities,
    this._changes,
    this._examReadiness,
    this._deadlines,
  });

  final GoTrueClient _auth;
  final ScheduleRemoteDataSource _schedule;
  final LessonReactionsDataSource _reactions;
  final LessonMaterialsDataSource _materials;
  final UserActivitiesDataSource _activities;
  final ScheduleChangesDataSource? _changes;
  final ExamReadinessDataSource? _examReadiness;
  final DeadlinesDataSource? _deadlines;

  Future<List<Deadline>> getDeadlines() {
    return _guard(
      () => _requireSource(_deadlines).getDeadlines(),
      GetDeadlinesFailure.new,
    );
  }

  Future<void> createDeadline({
    required String title,
    required String subjectName,
    required DateTime dueAt,
    DeadlineSource source = DeadlineSource.me,
    DeadlinePriority priority = DeadlinePriority.medium,
    bool remind = true,
  }) {
    return _guard(
      () => _requireSource(_deadlines).createDeadline(
        title: title,
        subjectName: subjectName,
        dueAt: dueAt,
        source: source,
        priority: priority,
        remind: remind,
      ),
      CreateDeadlineFailure.new,
    );
  }

  /// Schedules a server-side push reminder (delivered by pg_cron via FCM).
  Future<void> createReminder({
    required DateTime fireAt,
    required String title,
    String body = '',
    String route = '',
  }) {
    return _guard(
      () => _requireSource(
        _deadlines,
      ).createReminder(fireAt: fireAt, title: title, body: body, route: route),
      CreateReminderFailure.new,
    );
  }

  Future<void> setDeadlineState({
    required String id,
    int? progress,
    bool? done,
  }) {
    return _guard(
      () => _requireSource(
        _deadlines,
      ).setDeadlineState(id: id, progress: progress, done: done),
      SetDeadlineStateFailure.new,
    );
  }

  Future<void> deleteDeadline(String id) {
    return _guard(
      () => _requireSource(_deadlines).deleteDeadline(id),
      DeleteDeadlineFailure.new,
    );
  }

  bool get hasAuthenticatedUser => _auth.currentUser != null;

  /// Requests the schedule for the provided [group].
  Future<ScheduleResponse> getSchedule({
    required String group,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return _guard(
      () => _getScheduleFor(
        ScheduleTargetType.group,
        group,
        dateFrom: dateFrom,
        dateTo: dateTo,
      ),
      GetScheduleFailure.new,
    );
  }

  Future<ScheduleResponse> getTeacherSchedule({
    required String teacher,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return _guard(
      () => _getScheduleFor(
        ScheduleTargetType.teacher,
        teacher,
        dateFrom: dateFrom,
        dateTo: dateTo,
      ),
      GetTeacherScheduleFailure.new,
    );
  }

  Future<ScheduleResponse> getClassroomSchedule({
    required String classroom,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return _guard(
      () => _getScheduleFor(
        ScheduleTargetType.classroom,
        classroom,
        dateFrom: dateFrom,
        dateTo: dateTo,
      ),
      GetClassroomScheduleFailure.new,
    );
  }

  Future<SearchGroupsResponse> searchGroups({String query = ''}) {
    return _guard(() async {
      final rows = await _schedule.searchTargets(
        targetType: ScheduleTargetType.group,
        query: query,
      );
      return SearchGroupsResponse(
        results: [
          for (final row in rows)
            domain.Group(name: row.title, uid: row.externalId),
        ],
      );
    }, SearchGroupsFailure.new);
  }

  Future<SearchClassroomsResponse> searchClassrooms({String query = ''}) {
    return _guard(() async {
      final rows = await _schedule.searchTargets(
        targetType: ScheduleTargetType.classroom,
        query: query,
      );
      return SearchClassroomsResponse(
        results: [
          for (final row in rows)
            domain.Classroom(name: row.title, uid: row.externalId),
        ],
      );
    }, SearchClassroomsFailure.new);
  }

  Future<SearchTeachersResponse> searchTeachers({String query = ''}) {
    return _guard(() async {
      final rows = await _schedule.searchTargets(
        targetType: ScheduleTargetType.teacher,
        query: query,
      );
      return SearchTeachersResponse(
        results: [
          for (final row in rows)
            domain.Teacher(name: row.fullTitle, uid: row.externalId),
        ],
      );
    }, SearchTeachersFailure.new);
  }

  Future<void> postLessonReaction({
    required String subjectName,
    required DateTime lessonDate,
    required int lessonBellsNumber,
    required String reactionType,
  }) {
    return _guard(
      () => _reactions.postReaction(
        key: LessonReactionKey(
          subjectName: subjectName,
          lessonDate: lessonDate,
          lessonBellsNumber: lessonBellsNumber,
        ),
        reactionType: reactionType,
      ),
      PostLessonReactionFailure.new,
    );
  }

  Future<void> deleteLessonReaction({
    required String subjectName,
    required DateTime lessonDate,
    required int lessonBellsNumber,
  }) {
    return _guard(
      () => _reactions.deleteReaction(
        LessonReactionKey(
          subjectName: subjectName,
          lessonDate: lessonDate,
          lessonBellsNumber: lessonBellsNumber,
        ),
      ),
      DeleteLessonReactionFailure.new,
    );
  }

  Future<LessonReactionResponse> getLessonReactionSummary({
    required String subjectName,
    required DateTime lessonDate,
    required int lessonBellsNumber,
  }) {
    return _guard(
      () => _reactions.getReactionSummary(
        LessonReactionKey(
          subjectName: subjectName,
          lessonDate: lessonDate,
          lessonBellsNumber: lessonBellsNumber,
        ),
      ),
      GetLessonReactionSummaryFailure.new,
    );
  }

  Future<LessonDetailsResponse> getLessonDetails({
    required String subjectName,
    required DateTime lessonDate,
    required int lessonBellsNumber,
  }) {
    return _guard(
      () => _materials.getLessonDetails(
        LessonReactionKey(
          subjectName: subjectName,
          lessonDate: lessonDate,
          lessonBellsNumber: lessonBellsNumber,
        ),
      ),
      GetLessonDetailsFailure.new,
    );
  }

  Future<List<LessonReview>> upsertLessonReview(
    UpsertLessonReviewRequest request,
  ) {
    return _guard(
      () => _materials.upsertLessonReview(request),
      UpsertLessonReviewFailure.new,
    );
  }

  Future<LessonMaterial> uploadLessonMaterial(
    CreateLessonMaterialRequest request,
  ) {
    return _guard(
      () => _materials.uploadLessonMaterial(request),
      UploadLessonMaterialFailure.new,
    );
  }

  Future<String> createLessonMaterialUrl(LessonMaterial material) {
    return _materials.createSignedUrl(material);
  }

  /// Loads the current user's activities between [from] and [to] (inclusive).
  Future<List<UserActivity>> getUserActivities({
    required DateTime from,
    required DateTime to,
  }) {
    return _guard(
      () => _activities.getUserActivities(from: from, to: to),
      GetUserActivitiesFailure.new,
    );
  }

  Future<UserActivity> upsertUserActivity(UpsertUserActivityRequest request) {
    return _guard(
      () => _activities.upsertUserActivity(request),
      UpsertUserActivityFailure.new,
    );
  }

  Future<void> deleteUserActivity(String id) {
    return _guard(
      () => _activities.deleteUserActivity(id),
      DeleteUserActivityFailure.new,
    );
  }

  /// Recent schedule changes (переносы, отмены, замены) for one target.
  Future<List<ScheduleChange>> getScheduleChanges({
    required ScheduleTargetType targetType,
    required String target,
    int limit = 60,
  }) {
    return _guard(
      () => _requireSource(_changes).getScheduleChanges(
        targetType: targetType,
        target: target,
        limit: limit,
      ),
      GetScheduleChangesFailure.new,
    );
  }

  /// The current user's per-subject exam readiness.
  Future<List<ExamReadiness>> getExamReadiness() {
    return _guard(
      () => _requireSource(_examReadiness).getExamReadiness(),
      GetExamReadinessFailure.new,
    );
  }

  Future<void> setExamReadiness({
    required String subjectName,
    required int readiness,
  }) {
    return _guard(
      () => _requireSource(
        _examReadiness,
      ).setExamReadiness(subjectName: subjectName, readiness: readiness),
      SetExamReadinessFailure.new,
    );
  }

  T _requireSource<T>(T? source) {
    if (source == null) {
      throw StateError('Data source is not configured for this repository');
    }
    return source;
  }

  Future<ScheduleResponse> _getScheduleFor(
    ScheduleTargetType targetType,
    String target, {
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final data = await _schedule.getSchedule(
      targetType: targetType,
      target: target,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
    return ScheduleResponse(data: data);
  }

  /// Runs [action], rethrowing any error wrapped by [wrapError] while keeping
  /// the original stack trace.
  Future<T> _guard<T>(
    Future<T> Function() action,
    ScheduleFailure Function(Object error) wrapError,
  ) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(wrapError(error), stackTrace);
    }
  }
}
