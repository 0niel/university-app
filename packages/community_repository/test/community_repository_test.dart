import 'package:community_repository/community_repository.dart';
import 'package:test/test.dart';

void main() {
  test('requires a forum URL when no Discourse client is injected', () {
    expect(
      CommunityRepository.new,
      throwsA(isA<ArgumentError>()),
    );
  });
}
