import 'dart:convert';
import 'dart:io';

import 'package:schedule_repository/schedule_repository.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

Map<String, Object?> _lesson(List<String> dates) => {
  'type': '__lesson_schedule__',
  'subject': 'Математика',
  'lesson_type': 'lecture',
  'teachers': <Object?>[],
  'classrooms': <Object?>[],
  'groups': ['ЭСМО-01-26'],
  'lesson_bells': {'start_time': '09:00', 'end_time': '10:30', 'number': 1},
  'dates': dates,
};

void main() {
  test('repeated reads request fresh dates for the same group', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final requests = <Map<String, Object?>>[];
    server.listen((request) async {
      expect(request.method, 'POST');
      expect(request.uri.path, '/rest/v1/rpc/get_schedule_for_entity');
      requests.add(
        (jsonDecode(await utf8.decoder.bind(request).join()) as Map)
            .cast<String, Object?>(),
      );
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode([
          _lesson([
            '07-09-2026',
            if (requests.length > 1) ...['08-09-2026', '09-09-2026'],
          ]),
        ]),
      );
      await request.response.close();
    });
    final client = SupabaseClient(
      'http://127.0.0.1:${server.port}',
      'test-key',
    );
    addTearDown(client.dispose);
    final repository = ScheduleRepository(
      supabaseClient: client,
      organizationId: 'university',
    );

    final first = await repository.getSchedule(group: 'ЭСМО-01-26');
    final refreshed = await repository.getSchedule(group: 'ЭСМО-01-26');
    expect(first.data.single.dates, [DateTime(2026, 9, 7)]);
    expect(refreshed.data.single.dates, [
      DateTime(2026, 9, 7),
      DateTime(2026, 9, 8),
      DateTime(2026, 9, 9),
    ]);
    expect(requests, hasLength(2));
    for (final parameters in requests) {
      expect(parameters, {
        'p_entity_type': 'group',
        'p_entity': 'ЭСМО-01-26',
        'p_date_from': null,
        'p_date_to': null,
        'p_organization_id': 'university',
      });
    }
  });

  test(
    'refresh failure is surfaced after a previously successful read',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      var requestCount = 0;
      server.listen((request) async {
        await request.drain<void>();
        requestCount++;
        request.response.headers.contentType = ContentType.json;
        if (requestCount == 1) {
          request.response.write(
            jsonEncode([
              _lesson(['07-09-2026']),
            ]),
          );
        } else {
          request.response.statusCode = HttpStatus.forbidden;
          request.response.write(
            jsonEncode({'code': '42501', 'message': 'Schedule unavailable'}),
          );
        }
        await request.response.close();
      });
      final client = SupabaseClient(
        'http://127.0.0.1:${server.port}',
        'test-key',
      );
      addTearDown(client.dispose);
      final repository = ScheduleRepository(
        supabaseClient: client,
        organizationId: 'university',
      );
      final first = await repository.getSchedule(group: 'ЭСМО-01-26');
      expect(first.data, hasLength(1));
      await expectLater(
        repository.getSchedule(group: 'ЭСМО-01-26'),
        throwsA(isA<GetScheduleFailure>()),
      );
      expect(requestCount, 2);
    },
  );
}
