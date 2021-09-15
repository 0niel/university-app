import 'package:rtu_mirea_app/data/datasources/lessons_app_info_local.dart';
import 'package:rtu_mirea_app/domain/entities/lesson_app_info.dart';
import 'package:rtu_mirea_app/domain/repositories/lesson_app_info_repository.dart';

class LessonAppInfoRepositoryImpl extends LessonAppInfoRepository {

  final LessonsAppInfoLocalData localDataSource;

  LessonAppInfoRepositoryImpl({
    required this.localDataSource
  });

  @override
  Future<List<LessonAppInfo>> getLessonsAppInfo() async {
    return await localDataSource.getLessonsAppInfoFromStorage();
  }

  @override
  Future setLessonsAppInfo(LessonAppInfo lessonInfo) async {
    await localDataSource.writeAppInfoToStorage(lessonInfo);
  }
}