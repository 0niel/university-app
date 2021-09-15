import 'package:rtu_mirea_app/domain/entities/lesson_app_info.dart';

abstract class LessonAppInfoRepository {
  Future<List<LessonAppInfo>> getLessonsAppInfo();
  Future setLessonsAppInfo(LessonAppInfo appInfo);
}