import 'package:study_groups_repository/study_groups_repository.dart';
import 'package:test/test.dart';

void main() {
  group('StudyGroupsFailure', () {
    const error = 'boom';
    final failures = <StudyGroupsFailure>[
      const GetMyStudyGroupFailure(error),
      const CreateStudyGroupFailure(error),
      const UpdateStudyGroupFailure(error),
      const DeleteStudyGroupFailure(error),
      const LeaveStudyGroupFailure(error),
      const InviteMemberFailure(error),
      const RespondInviteFailure(error),
      const JoinGroupFailure(error),
      const RequestToJoinFailure(error),
      const RespondJoinRequestFailure(error),
      const RemoveMemberFailure(error),
      const TransferOwnershipFailure(error),
      const GetInvitesFailure(error),
      const SearchGroupsFailure(error),
    ];

    test('every failure exposes the error in props', () {
      for (final failure in failures) {
        expect(failure.props, [error]);
      }
    });

    test('same type with same error are equal', () {
      expect(
        const CreateStudyGroupFailure(error),
        equals(const CreateStudyGroupFailure(error)),
      );
      expect(
        const JoinGroupFailure(error),
        equals(const JoinGroupFailure(error)),
      );
    });

    test('different types are not equal', () {
      expect(
        const CreateStudyGroupFailure(error) == const JoinGroupFailure(error),
        isFalse,
      );
    });
  });
}
