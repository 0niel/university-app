import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:study_groups_repository/study_groups_repository.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

void main() {
  StudyGroupsRepository repositoryReturning(Object body) => .new(
    supabase: SupabaseClient(
      'https://project.supabase.co',
      'key',
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode(body),
          200,
          headers: {'content-type': 'application/json'},
        ),
      ),
    ),
    organizationId: 'university',
  );

  test('getMyGroup rejects a non-object RPC response', () {
    final repository = repositoryReturning(const []);

    expect(repository.getMyGroup, throwsA(isA<GetMyStudyGroupFailure>()));
  });

  test('searchGroups rejects malformed rows', () {
    final repository = repositoryReturning(const [null]);

    expect(
      () => repository.searchGroups('group'),
      throwsA(isA<SearchGroupsFailure>()),
    );
  });
}
