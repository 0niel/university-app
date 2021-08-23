import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/forum_member.dart';

abstract class ForumRepository {
  Future<Either<Failure, List<ForumMember>>> getPatrons();
}
