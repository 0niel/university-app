import 'dart:convert';

import 'package:gamification_repository/gamification_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

void main() {
  const selected = AccountPersona(
    role: .teacher,
    teacherId: 'teacher-42',
    teacherName: 'Иванов Иван Иванович',
    teacherAvailable: true,
    revision: 3,
  );

  GamificationRepository repositoryWith(
    Future<http.Response> Function(http.Request) handler,
  ) {
    final client = SupabaseClient(
      'https://project.supabase.co',
      'key',
      httpClient: MockClient(handler),
    );
    addTearDown(client.dispose);
    return GamificationRepository(supabase: client);
  }

  http.Response response(
    Object? body,
    http.Request request, {
    int status = 200,
  }) => http.Response(
    jsonEncode(body),
    status,
    headers: {'content-type': 'application/json'},
    request: request,
  );

  test('empty persona preserves the student default', () {
    expect(AccountPersona.fromJson(const {}), AccountPersona.empty);
    expect(AccountPersona.empty.toJson(), {
      'role': 'student',
      'teacherId': null,
      'teacherName': null,
      'teacherAvailable': false,
      'revision': 0,
    });
  });

  test('teacher selection and unavailable snapshot round-trip', () {
    expect(AccountPersona.fromJson(selected.toJson()), selected);
    final unavailable = selected.copyWith(teacherAvailable: false);
    expect(AccountPersona.fromJson(unavailable.toJson()), unavailable);
  });

  test('getter pins the organization and expected account', () async {
    final repository = repositoryWith((request) async {
      expect(request.url.path, '/rest/v1/rpc/get_account_persona');
      expect(jsonDecode(request.body), {
        'p_organization_id': 'university',
        'p_expected_user_id': 'expected-user',
      });
      return response(selected.toJson(), request);
    });
    expect(
      await repository.getAccountPersona(
        organizationId: 'university',
        expectedUserId: 'expected-user',
      ),
      selected,
    );
  });

  test('setter sends a versioned teacher selection', () async {
    final repository = repositoryWith((request) async {
      expect(request.url.path, '/rest/v1/rpc/set_account_persona');
      expect(jsonDecode(request.body), {
        'p_organization_id': 'university',
        'p_expected_user_id': 'expected-user',
        'p_role': 'teacher',
        'p_teacher_id': 'teacher-42',
        'p_expected_revision': 2,
      });
      return response(selected.toJson(), request);
    });
    expect(
      await repository.setAccountPersona(
        organizationId: 'university',
        expectedUserId: 'expected-user',
        role: .teacher,
        teacherId: 'teacher-42',
        expectedRevision: 2,
      ),
      selected,
    );
  });

  test('student mode can retain its dormant teacher selection', () async {
    final repository = repositoryWith((request) async {
      expect(jsonDecode(request.body), {
        'p_organization_id': 'university',
        'p_expected_user_id': 'expected-user',
        'p_role': 'student',
        'p_teacher_id': 'teacher-42',
        'p_expected_revision': 3,
      });
      return response(
        selected.copyWith(role: .student, revision: 4).toJson(),
        request,
      );
    });
    final result = await repository.setAccountPersona(
      organizationId: 'university',
      expectedUserId: 'expected-user',
      role: .student,
      teacherId: 'teacher-42',
      expectedRevision: 3,
    );
    expect(result.role, AccountRole.student);
    expect(result.teacherId, 'teacher-42');
    expect(result.revision, 4);
  });

  test('teacher setup explicitly clears a selection with null', () async {
    final repository = repositoryWith((request) async {
      expect((jsonDecode(request.body) as Map)['p_teacher_id'], isNull);
      return response(
        const AccountPersona(role: .teacher, revision: 1).toJson(),
        request,
      );
    });
    final result = await repository.setAccountPersona(
      organizationId: 'university',
      expectedUserId: 'expected-user',
      role: .teacher,
      expectedRevision: 0,
    );
    expect(result.teacherId, isNull);
    expect(result.role, AccountRole.teacher);
  });

  test('stale revision becomes a recoverable domain conflict', () {
    final repository = repositoryWith(
      (request) async => response(
        {'code': 'PT409', 'message': 'Account persona changed'},
        request,
        status: 409,
      ),
    );
    expect(
      () => repository.setAccountPersona(
        organizationId: 'university',
        expectedUserId: 'expected-user',
        role: .teacher,
        expectedRevision: 2,
      ),
      throwsA(isA<AccountPersonaConflictException>()),
    );
  });

  test('account mismatch remains an authorization failure', () {
    final repository = repositoryWith(
      (request) async => response(
        {'code': '42501', 'message': 'Account access denied'},
        request,
        status: 403,
      ),
    );
    expect(
      () => repository.setAccountPersona(
        organizationId: 'university',
        expectedUserId: 'previous-user',
        role: .teacher,
        expectedRevision: 0,
      ),
      throwsA(isA<PostgrestException>()),
    );
  });

  test('negative revisions fail before making a request', () {
    final repository = repositoryWith((request) async {
      fail('Invalid revision reached the server');
    });
    expect(
      () => repository.setAccountPersona(
        organizationId: 'university',
        expectedUserId: 'expected-user',
        role: .teacher,
        expectedRevision: -1,
      ),
      throwsArgumentError,
    );
  });

  for (final payload in <Object?>[
    null,
    const [],
    const {'role': 'admin'},
    const {'revision': 'one'},
  ]) {
    test('getter rejects malformed persona $payload', () {
      final repository = repositoryWith(
        (request) async => response(payload, request),
      );
      expect(
        () => repository.getAccountPersona(
          organizationId: 'university',
          expectedUserId: 'expected-user',
        ),
        throwsA(isA<GamificationResponseException>()),
      );
    });
  }
}
