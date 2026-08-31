import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/actions/device_actions.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';

class DeviceActionsTest extends MiniAppHost {
  DeviceActionsTest({
    this.locationResult,
    this.image,
    this.code,
    this.file,
    this.authOk = false,
    this.reminderId,
    this.eventOk = false,
  });

  final Map<String, double>? locationResult;
  final String? image;
  final String? code;
  final Map<String, String>? file;
  final bool authOk;
  final int? reminderId;
  final bool eventOk;

  bool fromCameraSeen = false;

  @override
  Future<Map<String, double>?> getLocation() async => locationResult;

  @override
  Future<String?> pickImage({required bool fromCamera}) async {
    fromCameraSeen = fromCamera;
    return image;
  }

  @override
  Future<String?> scanCode() async => code;

  @override
  Future<Map<String, String>?> pickFile() async => file;

  @override
  Future<bool> authenticate({required String reason}) async => authOk;

  @override
  Future<int?> scheduleReminder({
    required String title,
    required String body,
    required String whenIso,
  }) async => reminderId;

  @override
  Future<bool> addCalendarEvent({
    required String title,
    required String startIso,
    String? endIso,
    String? location,
    String? notes,
  }) async => eventOk;

  @override
  Future<void> openLocation(String location) => .value();
  @override
  Future<void> openExternalUrl(Uri url) => .value();
  @override
  Future<void> openPage({required String path, String? title}) => .value();
  @override
  Future<void> openMiniApp({required String slug, String? path}) => .value();
  @override
  Future<void> reload() => .value();
  @override
  Future<void> setStorage(String key, Object? value) => .value();
  @override
  void closeMiniApp() => ();
}

void main() {
  Future<BuildContext> pumpScope(
    WidgetTester tester,
    MiniAppStateStore store,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MiniAppStateScope(
        store: store,
        child: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return context;
  }

  MiniAppSession? session;

  void useHost(DeviceActionsTest testHost) {
    session = MiniAppSession(slug: 'demo', host: testHost);
    MiniAppSessionStack.push(session!);
  }

  tearDown(() {
    final current = session;
    if (current != null) MiniAppSessionStack.pop(current);
    session = null;
  });

  group('StacGetLocationActionParser', () {
    testWidgets('writes lat/lng/accuracy under saveAs', (tester) async {
      useHost(
        DeviceActionsTest(
          locationResult: {'lat': 55.7, 'lng': 37.6, 'accuracy': 8},
        ),
      );
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacGetLocationActionParser();
      await parser.onCall(context, const {'saveAs': 'loc'});

      expect(store.get('locLat'), 55.7);
      expect(store.get('locLng'), 37.6);
      expect(store.get('locAccuracy'), 8);
    });

    testWidgets('writes nothing when the host denies', (tester) async {
      useHost(DeviceActionsTest());
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacGetLocationActionParser();
      await parser.onCall(context, const {'saveAs': 'loc'});

      expect(store.get('locLat'), isNull);
    });
  });

  group('StacPickImageActionParser', () {
    testWidgets('uploads via host and stores the url', (tester) async {
      final host = DeviceActionsTest(image: 'https://cdn/x.jpg');
      useHost(host);
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacPickImageActionParser();
      await parser.onCall(context, const {'saveAs': 'photo'});

      expect(store.get('photo'), 'https://cdn/x.jpg');
      expect(host.fromCameraSeen, isTrue);
    });

    testWidgets('source gallery asks the host for the gallery', (tester) async {
      final host = DeviceActionsTest(image: 'https://cdn/y.jpg');
      useHost(host);
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacPickImageActionParser();
      await parser.onCall(context, const {'source': 'gallery'});

      expect(host.fromCameraSeen, isFalse);
      expect(store.get('photo'), 'https://cdn/y.jpg');
    });
  });

  group('StacScanCodeActionParser', () {
    testWidgets('stores the decoded text under saveAs', (tester) async {
      useHost(DeviceActionsTest(code: 'TICKET-42'));
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacScanCodeActionParser();
      await parser.onCall(context, const {'saveAs': 'ticket'});

      expect(store.get('ticket'), 'TICKET-42');
    });
  });

  group('StacPickFileActionParser', () {
    testWidgets('stores url and name under saveAs', (tester) async {
      useHost(
        DeviceActionsTest(
          file: const {'url': 'https://cdn/d.pdf', 'name': 'd.pdf'},
        ),
      );
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacPickFileActionParser();
      await parser.onCall(context, const {'saveAs': 'doc'});

      expect(store.get('doc'), 'https://cdn/d.pdf');
      expect(store.get('docName'), 'd.pdf');
    });
  });

  group('StacAuthenticateActionParser', () {
    testWidgets('writes true on success', (tester) async {
      useHost(DeviceActionsTest(authOk: true));
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacAuthenticateActionParser();
      await parser.onCall(context, const {'saveAs': 'ok'});

      expect(store.get('ok'), true);
    });

    testWidgets('writes nothing on failure', (tester) async {
      useHost(DeviceActionsTest());
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacAuthenticateActionParser();
      await parser.onCall(context, const {'saveAs': 'ok'});

      expect(store.get('ok'), isNull);
    });
  });

  group('StacScheduleReminderActionParser', () {
    testWidgets('stores the reminder id', (tester) async {
      useHost(DeviceActionsTest(reminderId: 7));
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacScheduleReminderActionParser();
      await parser.onCall(context, const {
        'title': 'x',
        'when': '2026-06-20T09:00:00',
        'saveAs': 'rid',
      });

      expect(store.get('rid'), 7);
    });

    testWidgets('is a no-op without a when', (tester) async {
      useHost(DeviceActionsTest(reminderId: 7));
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacScheduleReminderActionParser();
      await parser.onCall(context, const {'title': 'x', 'saveAs': 'rid'});

      expect(store.get('rid'), isNull);
    });
  });

  group('StacAddCalendarEventActionParser', () {
    testWidgets('writes true when the host adds the event', (tester) async {
      useHost(DeviceActionsTest(eventOk: true));
      final store = MiniAppStateStore()..seed(const {});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacAddCalendarEventActionParser();
      await parser.onCall(context, const {
        'title': 'Экзамен',
        'start': '2026-06-22T10:00:00',
        'saveAs': 'added',
      });

      expect(store.get('added'), true);
    });
  });
}
