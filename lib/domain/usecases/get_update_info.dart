import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/update_info.dart';
import 'package:rtu_mirea_app/domain/repositories/strapi_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

/// Returns [UpdateInfo] if there is a newer version of the application.
/// Otherwise it will return null
///
class GetUpdateInfo extends UseCase<UpdateInfo?, void> {
  final StrapiRepository strapiRepository;

  GetUpdateInfo(this.strapiRepository);

  @override
  Future<Either<Failure, UpdateInfo?>> call([params]) {
    return strapiRepository.getLastUpdateInfo();
  }
}
