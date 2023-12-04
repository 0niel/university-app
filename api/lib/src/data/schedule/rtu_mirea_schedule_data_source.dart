import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';
import 'package:schedule/schedule.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';

class RtuMireaScheduleDataSource implements ScheduleDataSource {
  /// {@macro in_memory_news_data_store}
  RtuMireaScheduleDataSource() : _apiClient = RtuMireaScheduleApiClient();

  final RtuMireaScheduleApiClient _apiClient;

  @override
  Future<List<SchedulePart>> getSchedule({required String group}) async {
    final icalData = await _apiClient.getIcalContent(
      itemId: int.parse(group),
      scheduleTargetId: groupScheduleTargetIdentifier,
    );

    final parser = ICalParser.fromString(icalData);

    return parser.parse();
  }

  @override
  Future<List<SchedulePart>> getClassroomSchedule({
    required String classroom,
  }) async {
    final id = int.parse(classroom);

    final icalData = await _apiClient.getIcalContent(
      itemId: id,
      scheduleTargetId: classroomScheduleTargetIdentifier,
    );

    final parser = ICalParser.fromString(icalData);

    return parser.parse();
  }

  @override
  Future<List<SchedulePart>> getTeacherSchedule({
    required String teacher,
  }) async {
    final id = int.parse(teacher);

    final icalData = await _apiClient.getIcalContent(
      itemId: id,
      scheduleTargetId: teacherScheduleTargetIdentifier,
    );

    final parser = ICalParser.fromString(icalData);

    return parser.parse();
  }

  @override
  Future<List<Classroom>> searchClassrooms({required String query}) async {
    final searchData = await _apiClient.search(query: query);

    final onlyClassrooms = searchData.data
        .where(
          (element) =>
              element.scheduleTarget == classroomScheduleTargetIdentifier,
        )
        .toList()
        .map(
          (e) => parseClassroomsFromLocation(e.fullTitle).map(
            (e) => e.copyWith(
              uid: e.uid.toString(),
            ),
          ),
        )
        .expand((element) => element);

    return onlyClassrooms.toList();
  }

  @override
  Future<List<Group>> searchGroups({required String query}) async {
    final searchData = await _apiClient.search(query: query);

    final onlyGroups = searchData.data
        .where(
          (element) => element.scheduleTarget == groupScheduleTargetIdentifier,
        )
        .toList()
        .map(
          (e) => Group(
            name: e.fullTitle,
            uid: e.id.toString(),
          ),
        );

    return onlyGroups.toList();
  }

  @override
  Future<List<Teacher>> searchTeachers({required String query}) async {
    final searchData = await _apiClient.search(query: query);

    final onlyTeachers = searchData.data
        .where(
          (element) =>
              element.scheduleTarget == teacherScheduleTargetIdentifier,
        )
        .toList()
        .map(
          (e) => Teacher(
            name: e.fullTitle,
            uid: e.id.toString(),
          ),
        );

    return onlyTeachers.toList();
  }
}
