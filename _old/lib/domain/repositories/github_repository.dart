import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/contributor.dart';

abstract class GithubRepository {
  Future<Either<Failure, List<Contributor>>> getContributors();
}
