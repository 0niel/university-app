import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/storage_actions.dart';
import 'package:stac_bridge/src/widgets/app_badge_parsers.dart';
import 'package:stac_bridge/src/widgets/app_button_parser.dart';
import 'package:stac_bridge/src/widgets/app_card_parser.dart';
import 'package:stac_bridge/src/widgets/app_chip_parser.dart';
import 'package:stac_bridge/src/widgets/app_control_parsers.dart';
import 'package:stac_bridge/src/widgets/app_data_parsers.dart';
import 'package:stac_bridge/src/widgets/app_empty_state_parser.dart';
import 'package:stac_bridge/src/widgets/app_icon_parsers.dart';
import 'package:stac_bridge/src/widgets/app_list_row_parser.dart';
import 'package:stac_bridge/src/widgets/app_meta_pill_parser.dart';
import 'package:stac_bridge/src/widgets/app_section_title_parser.dart';
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

  group('StacAppButton', () {
    test('preserves the appButton wire contract and safe defaults', () {
      final button = StacAppButton.fromJson({
        'label': 'Enroll',
        'variant': 'outline',
        'size': 'large',
        'expanded': true,
        'onPressed': {'actionType': 'openUrl'},
      });

      expect(button.label, 'Enroll');
      expect(button.variant, 'outline');
      expect(button.size, 'large');
      expect(button.expanded, isTrue);
      expect(button.toJson()['onPressed'], {'actionType': 'openUrl'});

      final malformed = StacAppButton.fromJson({
        'label': 1,
        'variant': false,
        'size': 2,
        'expanded': 'true',
      });
      expect(malformed, const StacAppButton(label: ''));
    });
  });

  group('StacAppCard', () {
    test('preserves the appCard wire contract and padding coercion', () {
      final card = StacAppCard.fromJson({
        'padding': 12,
        'color': '#123456',
        'onTap': {'actionType': 'openUrl'},
        'child': {'type': 'text', 'data': 'Hello'},
      });

      expect(card.padding, 12);
      expect(card.color, '#123456');
      expect(card.toJson()['onTap'], {'actionType': 'openUrl'});
      expect(card.child, {'type': 'text', 'data': 'Hello'});
      expect(StacAppCard.fromJson({'padding': 'invalid'}), const StacAppCard());
    });
  });

  group('StacAppChip', () {
    test('preserves the appChip wire contract and safe defaults', () {
      final chip = StacAppChip.fromJson({
        'label': 'All',
        'selected': true,
        'small': true,
        'color': '#123456',
        'onTap': {'actionType': 'setState'},
      });

      expect(chip.label, 'All');
      expect(chip.selected, isTrue);
      expect(chip.small, isTrue);
      expect(chip.toJson()['onTap'], {'actionType': 'setState'});
      expect(
        StacAppChip.fromJson({'label': 1, 'selected': 'yes'}),
        const StacAppChip(label: ''),
      );
    });
  });

  group('app control models', () {
    test('preserve their wire action keys and safe scalar defaults', () {
      final toggle = StacAppToggle.fromJson({
        'value': true,
        'onChange': {'actionType': 'setState'},
      });
      final serviceTile = StacAppServiceTile.fromJson({
        'emoji': '📚',
        'solid': true,
        'onTap': {'actionType': 'openUrl'},
      });

      expect(toggle.toJson()['onChange'], {'actionType': 'setState'});
      expect(serviceTile.emoji, '📚');
      expect(serviceTile.toJson()['onTap'], {'actionType': 'openUrl'});
      expect(StacAppToggle.fromJson({'value': 'true'}), const StacAppToggle());
      expect(
        StacAppSmartChip.fromJson({'emoji': 1, 'label': 2, 'value': 3}),
        const StacAppSmartChip(emoji: '', label: '', value: ''),
      );
    });
  });

  group('StacAppEmptyState', () {
    test('uses the established defaults for malformed scalar values', () {
      final state = StacAppEmptyState.fromJson({
        'emoji': '🗓️',
        'title': 'No classes',
        'child': {'type': 'text', 'data': 'Try another day'},
      });

      expect(state.emoji, '🗓️');
      expect(state.title, 'No classes');
      expect(state.child, {'type': 'text', 'data': 'Try another day'});
      expect(
        StacAppEmptyState.fromJson({'emoji': 1, 'title': 2}),
        const StacAppEmptyState(emoji: '✨', title: ''),
      );
    });
  });

  group('Freezed display models', () {
    test('preserve section title and pill JSON wire contracts', () {
      final title = StacAppSectionTitle.fromJson({
        'title': 'Today',
        'action': 'See all',
        'onActionTap': {'actionType': 'openPage'},
      });

      expect(title.toJson()['onActionTap'], {'actionType': 'openPage'});
      expect(
        StacAppMetaPill.fromJson({'text': 'New', 'strong': true}),
        const StacAppMetaPill(text: 'New', strong: true),
      );
    });
  });

  group('icon and row models', () {
    test('preserve actions and coerce malformed scalar fields safely', () {
      final iconButton = StacAppIconButton.fromJson({
        'icon': 'share',
        'onPressed': {'actionType': 'share'},
      });
      final row = StacAppListRow.fromJson({
        'title': 'Physics',
        'dense': true,
        'onTap': {'actionType': 'openPage'},
      });

      expect(iconButton.toJson()['onPressed'], {'actionType': 'share'});
      expect(row.toJson()['onTap'], {'actionType': 'openPage'});
      expect(row.dense, isTrue);
      expect(
        StacAppLineIcon.fromJson({'icon': 1, 'size': 'large'}),
        const StacAppLineIcon(icon: ''),
      );
    });
  });

  group('badge models', () {
    test('preserve defaults and normalize malformed collections', () {
      final tag = StacAppTag.fromJson({'label': 'Live', 'withDot': true});
      final stack = StacAppAvatarStack.fromJson({
        'names': ['Ada', 1, 'Linus'],
        'size': 32,
      });

      expect(tag, const StacAppTag(label: 'Live', withDot: true));
      expect(stack.names, ['Ada', 'Linus']);
      expect(stack.size, 32);
      expect(
        StacAppAvatar.fromJson({'name': 1, 'size': 'large'}),
        const StacAppAvatar(name: ''),
      );
    });
  });

  group('data models', () {
    test('preserve action keys and normalize segmented options', () {
      final segmented = StacAppSegmentedControl.fromJson({
        'selectedIndex': 1,
        'options': [
          {'label': 'Today'},
          {
            'label': 'Week',
            'onSelected': {'actionType': 'openPage'},
          },
          'invalid',
        ],
      });
      final error = StacAppErrorState.fromJson({
        'title': 'Unavailable',
        'message': 'Try again',
        'onPrimary': {'actionType': 'reload'},
      });

      expect(segmented.options, hasLength(2));
      expect(error.toJson()['onPrimary'], {'actionType': 'reload'});
      expect(
        StacAppProgressRing.fromJson({'value': 'invalid'}),
        const StacAppProgressRing(value: 0),
      );
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
