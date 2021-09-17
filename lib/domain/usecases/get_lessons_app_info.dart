import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/lesson_app_info.dart';
import 'package:rtu_mirea_app/domain/repositories/lesson_app_info_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetLessonsAppInfo extends UseCaseRight<List<LessonAppInfo>, void> {
  final LessonAppInfoRepository lessonsAppInfoRepository;

  GetLessonsAppInfo(this.lessonsAppInfoRepository);

  @override
  Future<List<LessonAppInfo>> call([_]) async {
    return await lessonsAppInfoRepository.getLessonsAppInfo();
  }
}
