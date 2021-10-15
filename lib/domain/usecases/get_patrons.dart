import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/forum_member.dart';
import 'package:rtu_mirea_app/domain/repositories/forum_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetForumPatrons extends UseCase<List<ForumMember>, void> {
  final ForumRepository forumRepository;

  GetForumPatrons(this.forumRepository);

  @override
  Future<Either<Failure, List<ForumMember>>> call([params]) async {
    return await forumRepository.getPatrons();
  }
}
