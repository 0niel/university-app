import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';
import 'package:schedule/schedule.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';

import 'package:university_app_server_api/src/data/schedule/static_holidays_data.dart';

class RtuMireaScheduleDataSource implements ScheduleDataSource {
  /// {@macro in_memory_news_data_store}
  RtuMireaScheduleDataSource() : _apiClient = RtuMireaScheduleApiClient();

  final RtuMireaScheduleApiClient _apiClient;

  static const groupScheduleTargetIdentifier = 1;
  static const teacherScheduleTargetIdentifier = 2;
  static const classroomScheduleTargetIdentifier = 3;

  @override
  Future<List<SchedulePart>> getSchedule({required String group}) async {
    final icalData = await _apiClient.getIcalContent(
      itemId: int.parse(group),
      scheduleTargetId: groupScheduleTargetIdentifier,
    );

    final parser = ICalParser.fromString(icalData);

    final data = parser.parse();

    return [
      ...data,
      ...holidays,
    ];
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
          (element) => element.scheduleTarget == classroomScheduleTargetIdentifier,
        )
        .toList()
        .map(
          (searchItem) => parseClassroomsFromLocation(searchItem.fullTitle).map(
            (classroom) => classroom.copyWith(
              uid: searchItem.id.toString(),
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
          (element) => element.scheduleTarget == teacherScheduleTargetIdentifier,
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
