import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/lesson_app_info.dart';
import 'package:rtu_mirea_app/domain/repositories/lesson_app_info_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class SetLessonsAppInfo extends UseCase<void, LessonAppInfo> {
  final LessonAppInfoRepository lessonsAppInfoRepository;

  SetLessonsAppInfo(this.lessonsAppInfoRepository);

  @override
  Future<Either<Failure, void>> call(LessonAppInfo lessonInfo) async {
    return Right(await lessonsAppInfoRepository.setLessonsAppInfo(lessonInfo));
  }
}
