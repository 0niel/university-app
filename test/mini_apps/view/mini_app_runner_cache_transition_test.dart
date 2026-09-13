import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_page.dart';
import 'package:stac_bridge/stac_bridge.dart';

import '../../helpers/pump_app.dart';

class _Repository extends Mock implements MiniAppsRepository {}

Map<String, dynamic> _reviewCard(int index) => {
  'type': 'appCard',
  'padding': 14,
  'child': {
    'type': 'column',
    'crossAxisAlignment': 'stretch',
    'children': [
      {
        'type': 'row',
        'children': [
          {'type': 'appAvatar', 'name': 'Студент $index', 'size': 36},
          {'type': 'sizedBox', 'width': 10},
          {
            'type': 'expanded',
            'child': {
              'type': 'column',
              'children': [
                {
                  'type': 'appText',
                  'data': 'Студент $index',
                  'variant': 'labelStrong',
                },
                {'type': 'appText', 'data': '12 сент', 'variant': 'caption'},
              ],
            },
          },
          {'type': 'appTag', 'label': '★ 4,${index % 10}', 'tone': 'live'},
        ],
      },
      {
        'type': 'appExpandableText',
        'text': 'Объясняет сложные темы простыми словами. ' * 12,
        'maxLines': 4,
      },
      {
        'type': 'appIf',
        'condition': 'state.v$index',
        'child': {
          'type': 'appButton',
          'label': "{{'Полезно · ' + str(state.h$index)}}",
          'variant': 'ghost',
          'onPressed': {
            'actionType': 'setState',
            'key': 'v$index',
            'toggle': true,
          },
        },
        'else': {
          'type': 'appButton',
          'label': 'Полезно',
          'variant': 'ghost',
          'onPressed': {
            'actionType': 'setState',
            'key': 'v$index',
            'toggle': true,
          },
        },
      },
    ],
  },
};

Map<String, dynamic> _largeScreen() => {
  'type': 'scaffold',
  'body': {
    'type': 'appStateScope',
    'initial': {
      'q': '',
      'searching': false,
      'listing': {'items': <Object?>[], 'count': 0, 'offset': 0},
      for (var i = 0; i < 40; i++) 'v$i': false,
      for (var i = 0; i < 40; i++) 'h$i': i,
    },
    'child': {
      'type': 'singleChildScrollView',
      'child': {
        'type': 'column',
        'crossAxisAlignment': 'stretch',
        'children': [
          {'type': 'appSearchField', 'stateKey': 'q', 'placeholder': 'Поиск'},
          {
            'type': 'appIf',
            'condition': 'state.searching',
            'child': {
              'type': 'appForEach',
              'items': 'state.listing.items',
              'template': {'type': 'appText', 'data': '{{item.name}}'},
            },
            'else': {
              'type': 'column',
              'crossAxisAlignment': 'stretch',
              'children': [for (var i = 0; i < 40; i++) _reviewCard(i)],
            },
          },
        ],
      },
    },
  },
};

void main() {
  const app = MiniApp(
    id: 'app-1',
    slug: 'reviews',
    name: 'Отзывы',
    status: MiniAppStatus.published,
    sourceKind: MiniAppSourceKind.service,
  );

  Future<MiniAppsRepository> pumpRunner(
    WidgetTester tester, {
    required Map<String, dynamic>? cached,
    required Map<String, dynamic> fresh,
  }) async {
    final repository = _Repository();
    when(() => repository.getApp('reviews')).thenAnswer((_) async => app);
    when(() => repository.getStorage('app-1')).thenAnswer((_) async => {});
    when(
      () => repository.readCachedStorage('app-1'),
    ).thenAnswer((_) async => {});
    when(() => repository.trackLaunch(any())).thenAnswer((_) async {});
    when(
      () => repository.readCachedScreen(slug: 'reviews'),
    ).thenAnswer((_) async => cached);
    when(() => repository.fetchScreen(slug: 'reviews')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return fresh;
    });
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      RepositoryProvider<MiniAppsRepository>.value(
        value: repository,
        child: MiniAppRunnerPage(
          slug: 'reviews',
          runtimeInitializerBuilder: () => StacBridge.ensureInitialized(
            StacBridgeConfig(
              proxyUrl: 'https://example.test/proxy',
              organizationId: 'mirea',
              onAccessTokenRequested: () async => null,
            ),
          ),
        ),
      ),
    );
    return repository;
  }

  testWidgets(
    'identical cached and fresh screens settle without a rebuild storm',
    (tester) async {
      final cached = _largeScreen();
      final fresh = _largeScreen();
      final repository = await pumpRunner(tester, cached: cached, fresh: fresh);
      final stopwatch = Stopwatch()..start();
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 30),
      );
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 20)));
      expect(find.text('Студент 0'), findsOneWidget);
      verify(() => repository.fetchScreen(slug: 'reviews')).called(1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('runner state compares screens structurally', (tester) async {
    final a = MiniAppRunnerState(status: .ready, screen: _largeScreen());
    final b = MiniAppRunnerState(status: .ready, screen: _largeScreen());
    final stopwatch = Stopwatch()..start();
    expect(a == b, isTrue);
    expect(a.hashCode, b.hashCode);
    expect(
      a == b.copyWith(screen: {..._largeScreen(), 'type': 'safeArea'}),
      isFalse,
    );
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 2)));
  });
}
