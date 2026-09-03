import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/storage_actions.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_bridge/stac_bridge.dart';

class StorageAndUtilsTest extends MiniAppHost {
  final stored = <String, Object?>{};

  @override
  FutureOr<void> openLocation(String location) => Future.value();

  @override
  FutureOr<void> openExternalUrl(Uri url) => Future.value();

  @override
  FutureOr<void> openPage({required String path, String? title}) =>
      Future.value();

  @override
  FutureOr<void> openMiniApp({required String slug, String? path}) =>
      Future.value();

  @override
  FutureOr<void> reload() => Future.value();

  @override
  FutureOr<void> setStorage(String key, Object? value) {
    stored[key] = value;
  }

  @override
  FutureOr<Map<String, double>?> getLocation() => null;

  @override
  FutureOr<String?> pickImage({required bool fromCamera}) => null;

  @override
  FutureOr<String?> scanCode() => null;

  @override
  void closeMiniApp() => ();
}

void main() {
  group('parseHexColor', () {
    test('parses #RRGGBB and #AARRGGBB', () {
      expect(parseHexColor('#7C5CFF'), const Color(0xFF7C5CFF));
      expect(parseHexColor('#807C5CFF'), const Color(0x807C5CFF));
    });

    test('returns null for malformed values', () {
      expect(parseHexColor(null), isNull);
      expect(parseHexColor('#XYZ'), isNull);
      expect(parseHexColor('7C5CFF7'), isNull);
    });
  });

  group('appLineIconByName', () {
    test('resolves icons by enum name and null for unknown', () {
      expect(appLineIconByName('search'), isNotNull);
      expect(appLineIconByName('definitely-not-an-icon'), isNull);
    });
  });

  group('scalar readers', () {
    test('coerce malformed values to safe defaults', () {
      final json = <String, Object?>{
        'label': 1,
        'expanded': 'true',
        'size': 'large',
        'count': '12',
        'names': ['Ada', 1, 'Linus'],
        'padding': {'horizontal': 4, 'top': 2},
      };
      expect(stringOf(json, 'label'), '');
      expect(boolOf(json, 'expanded'), isTrue);
      expect(doubleOf(json, 'size'), isNull);
      expect(intOf(json, 'count'), 12);
      expect(stringListOf(json, 'names'), ['Ada', '1', 'Linus']);
      expect(
        insetsOf(json, 'padding', 0),
        const EdgeInsets.only(left: 4, right: 4, top: 2),
      );
      expect(insetsOf(json, 'missing', 6), const EdgeInsets.all(6));
    });
  });

  group('labelOf', () {
    test('digs the first human readable string out of a widget tree', () {
      expect(labelOf('Plain'), 'Plain');
      expect(labelOf({'type': 'text', 'data': 'Hello'}), 'Hello');
      expect(
        labelOf({
          'type': 'row',
          'children': [
            {'type': 'icon', 'icon': 'add'},
            {'type': 'text', 'data': 'Add'},
          ],
        }),
        'Add',
      );
      expect(labelOf({'type': 'sizedBox'}), '');
    });
  });

  group('digJson', () {
    final root = {
      'data': {
        'items': [
          {'title': 'Math'},
          {'title': 'Physics'},
        ],
      },
    };

    test('an empty path returns the root unchanged', () {
      expect(digJson(root, ''), same(root));
    });

    test('walks map keys and numeric list indices', () {
      expect(digJson(root, 'data.items.1.title'), 'Physics');
      expect(digJson(root, 'data.items'), hasLength(2));
    });

    test('returns null for missing keys or out-of-range indices', () {
      expect(digJson(root, 'data.missing'), isNull);
      expect(digJson(root, 'data.items.9'), isNull);
      expect(digJson(root, 'data.items.title'), isNull);
    });
  });

  group('primeMiniAppStorage', () {
    tearDown(clearMiniAppStorage);

    test('exposes values under the storage.* registry prefix', () {
      primeMiniAppStorage(
        const {'score': 42, 'name': 'ninja'},
        owner: Object(),
      );
      expect(StacRegistry.instance.getValue('storage.score'), 42);
      expect(StacRegistry.instance.getValue('storage.name'), 'ninja');
    });

    test('removes values left by the previously active app', () {
      primeMiniAppStorage(
        const {'secret': 'first', 'shared': 1},
        owner: Object(),
      );
      primeMiniAppStorage(const {'shared': 2}, owner: Object());

      expect(StacRegistry.instance.getValue('storage.secret'), isNull);
      expect(StacRegistry.instance.getValue('storage.shared'), 2);
    });

    test('an outgoing runner cannot clear the active runner values', () {
      final outgoing = Object();
      final active = Object();
      primeMiniAppStorage(const {'secret': 'first'}, owner: outgoing);
      primeMiniAppStorage(const {'secret': 'second'}, owner: active);

      clearMiniAppStorage(owner: outgoing);

      expect(StacRegistry.instance.getValue('storage.secret'), 'second');
    });
  });

  group('StacSetStorageActionParser', () {
    testWidgets('updates the registry and persists through the host', (
      tester,
    ) async {
      final host = StorageAndUtilsTest();
      final session = MiniAppSession(slug: 'poll', host: host);
      MiniAppSessionStack.push(session);
      addTearDown(() => MiniAppSessionStack.pop(session));

      late BuildContext context;
      await tester.pumpWidget(
        Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      );

      const parser = StacSetStorageActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {'key': 'done', 'value': true}),
      );

      expect(StacRegistry.instance.getValue('storage.done'), isTrue);
      expect(host.stored, {'done': true});
    });

    testWidgets('ignores calls without a key', (tester) async {
      final host = StorageAndUtilsTest();
      final session = MiniAppSession(slug: 'poll', host: host);
      MiniAppSessionStack.push(session);
      addTearDown(() => MiniAppSessionStack.pop(session));

      late BuildContext context;
      await tester.pumpWidget(
        Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      );

      const parser = StacSetStorageActionParser();
      await parser.onCall(context, parser.getModel(const {'value': 1}));

      expect(host.stored, isEmpty);
    });
  });
}
