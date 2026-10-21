import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_page.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('catalog entry recovers from invalid metadata on retry', (
    tester,
  ) async {
    var catalogRequests = 0;
    final httpClient = MockClient((request) async {
      final Object response;
      switch (request.url.path.split('/').last) {
        case 'get_mini_apps':
          catalogRequests++;
          response = [
            {
              'id': 'app-1',
              'slug': 'notes',
              'name': 'Notes',
              'tags': catalogRequests == 1 ? [42] : ['study'],
            },
          ];
        case 'get_my_mini_apps':
        case 'get_recent_mini_apps':
          response = const [];
        case 'is_mini_app_moderator':
          response = false;
        default:
          throw StateError('Unexpected request: ${request.url.path}');
      }
      return http.Response(
        jsonEncode(response),
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    });
    final supabase = (await tester.runAsync(
      () async => SupabaseClient(
        'https://example.test',
        'test-publishable-key',
        httpClient: httpClient,
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      ),
    ))!;
    addTearDown(() async {
      await tester.runAsync(supabase.dispose);
      httpClient.close();
    });
    await tester.pumpApp(
      RepositoryProvider<MiniAppsRepository>(
        create: (_) => MiniAppsRepository(
          supabase: supabase,
          organizationId: 'mirea',
        ),
        child: const MiniAppsPage(),
      ),
      size: const Size(390, 844),
    );
    await tester.pumpAndSettle();

    final l10n = tester.element(find.byType(MiniAppsPage)).l10n;
    expect(find.text(l10n.loadingError), findsOneWidget);
    expect(find.byType(MiniAppCard), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text(l10n.retry));
    await tester.pumpAndSettle();

    expect(catalogRequests, 2);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.byType(MiniAppCard), findsOneWidget);
    expect(find.text(l10n.loadingError), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
