import 'dart:convert';
import 'dart:io';

import 'package:schedule_repository/src/data/schedule_remote_data_source.dart';
import 'package:schedule_repository/src/schedule_target_type.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

void main() {
  test('search RPC receives one normalized query and tenant scope', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    Map<String, Object?>? parameters;
    server.listen((request) async {
      expect(request.uri.path, '/rest/v1/rpc/search_schedule_targets');
      parameters = (jsonDecode(await utf8.decoder.bind(request).join()) as Map)
          .cast<String, Object?>();
      request.response.headers.contentType = ContentType.json;
      request.response.write('[]');
      await request.response.close();
    });
    final client = SupabaseClient(
      'http://127.0.0.1:${server.port}',
      'test-key',
    );
    addTearDown(client.dispose);
    final source = ScheduleRemoteDataSource(
      supabaseClient: client,
      organizationId: 'university',
    );
    expect(
      await source.searchTargets(
        targetType: ScheduleTargetType.group,
        query: ' ХЕБО-06-24 ',
      ),
      isEmpty,
    );
    expect(parameters, {
      'p_target_type': 'group',
      'p_query': 'хебо0624',
      'p_organization_id': 'university',
      'p_limit': 20,
    });
  });
}
