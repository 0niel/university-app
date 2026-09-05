import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/widgets/kit/kit_image_parser.dart';
import 'package:stac_bridge/src/widgets/kit/kit_image_picker_parser.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_store.dart';
import 'package:stac_bridge/stac_bridge.dart';

import 'kit_harness.dart';

class ImagePickerHost extends MiniAppHost {
  ImagePickerHost(this.pick);

  final Future<String?> Function() pick;
  final List<bool> sources = [];
  int reloads = 0;

  @override
  Future<String?> pickImage({required bool fromCamera}) {
    sources.add(fromCamera);
    return pick();
  }

  @override
  void closeMiniApp() {}

  @override
  void openLocation(String location) {}

  @override
  void openExternalUrl(Uri url) {}

  @override
  void openPage({required String path, String? title}) {}

  @override
  void openMiniApp({required String slug, String? path}) {}

  @override
  void reload() => reloads++;

  @override
  void setStorage(String key, Object? value) {}
}

void main() {
  setUpAll(
    () => StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => null,
      ),
    ),
  );

  void useHost(ImagePickerHost host) {
    final session = MiniAppSession(slug: 'demo', host: host);
    MiniAppSessionStack.push(session);
    addTearDown(() => MiniAppSessionStack.pop(session));
  }

  const parser = StacAppImagePickerParser();
  const model = <String, dynamic>{
    'stateKey': 'photo',
    'label': 'Фото профиля',
    'galleryLabel': 'Галерея',
    'cameraLabel': 'Камера',
    'loadingLabel': 'Загрузка фото',
    'selectedLabel': 'Выбрано',
    'existingLabel': 'Сохранено',
    'emptyLabel': 'Добавить',
    'removeLabel': 'Убрать',
    'errorMessage': 'Повторите загрузку',
  };

  testWidgets('selection remains after state changes and rebuilds', (
    tester,
  ) async {
    final pending = Completer<String?>();
    final host = ImagePickerHost(() => pending.future);
    useHost(host);
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    await pumpKit(tester, parser, {
      ...model,
      'onChanged': {
        'actionType': 'setState',
        'key': 'capturedPhoto',
        'value': '{{state.photo}}',
      },
    }, store: store);

    await tester.tap(find.text('Галерея'));
    await tester.pump();
    expect(store.get('photoStatus'), 'picking');
    expect(find.text('Загрузка фото'), findsOneWidget);
    expect(find.byType(AppButtonSpinner), findsWidgets);
    await tester.tap(find.text('Галерея'));
    await tester.tap(find.text('Камера'));
    expect(host.sources, [false]);

    store.set('unrelated', 1);
    await tester.pump();
    pending.complete('https://example.test/selected.jpg');
    await tester.pumpAndSettle();
    expect(store.get('photo'), 'https://example.test/selected.jpg');
    expect(store.get('capturedPhoto'), 'https://example.test/selected.jpg');
    expect(store.get('photoStatus'), 'ready');
    expect(find.text('Выбрано'), findsOneWidget);
    expect(
      tester.widget<KitNetworkImage>(find.byType(KitNetworkImage)).src,
      'https://example.test/selected.jpg',
    );

    await pumpKit(
      tester,
      parser,
      {...model, 'helperText': 'Новая подсказка'},
      store: store,
    );
    expect(find.text('Выбрано'), findsOneWidget);
    expect(store.get('photo'), 'https://example.test/selected.jpg');
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancel preserves selection and invokes the cancel action', (
    tester,
  ) async {
    useHost(ImagePickerHost(() async => null));
    final store = MiniAppStateStore()
      ..seed({'photo': 'https://example.test/existing.jpg'});
    addTearDown(store.dispose);
    await pumpKit(tester, parser, {
      ...model,
      'onCancel': {
        'actionType': 'setState',
        'key': 'canceled',
        'value': true,
      },
    }, store: store);

    await tester.tap(find.text('Камера'));
    await tester.pumpAndSettle();
    expect(store.get('photo'), 'https://example.test/existing.jpg');
    expect(store.get('photoStatus'), 'ready');
    expect(store.get('canceled'), true);
    expect(find.text('Выбрано'), findsOneWidget);
    expect(find.byType(AppButtonSpinner), findsNothing);
  });

  testWidgets('failure retains the photo and exposes a retryable error', (
    tester,
  ) async {
    useHost(ImagePickerHost(() async => throw StateError('upload failed')));
    final store = MiniAppStateStore()
      ..seed({'photo': 'https://example.test/existing.jpg'});
    addTearDown(store.dispose);
    await pumpKit(tester, parser, model, store: store);

    await tester.tap(find.text('Камера'));
    await tester.pumpAndSettle();
    expect(store.get('photo'), 'https://example.test/existing.jpg');
    expect(store.get('photoStatus'), 'error');
    expect(store.get('photoError'), 'Повторите загрузку');
    expect(find.text('Повторите загрузку'), findsOneWidget);
    expect(find.text('Выбрано'), findsOneWidget);
    expect(
      tester
          .widgetList<AppButton>(find.byType(AppButton))
          .every(
            (button) => button.onPressed != null && !button.loading,
          ),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('existing preview does not become an upload payload', (
    tester,
  ) async {
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    await pumpKit(tester, parser, {
      ...model,
      'initialUrl': 'https://example.test/saved.jpg',
    }, store: store);
    expect(find.text('Сохранено'), findsOneWidget);
    expect(find.text('Убрать'), findsNothing);
    expect(store.get('photo'), isNull);
    expect(
      tester.widget<KitNetworkImage>(find.byType(KitNetworkImage)).src,
      'https://example.test/saved.jpg',
    );
  });

  testWidgets('removal survives remount and canceled replacement', (
    tester,
  ) async {
    useHost(ImagePickerHost(() async => null));
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    final withInitial = {
      ...model,
      'initialUrl': 'https://example.test/saved.jpg',
      'allowRemoveInitial': true,
    };
    await pumpKit(tester, parser, withInitial, store: store);

    await tester.tap(find.text('Убрать'));
    await tester.pumpAndSettle();
    expect(store.get('photo'), '');
    expect(store.get('photoRemoved'), true);
    expect(find.byType(KitNetworkImage), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await pumpKit(tester, parser, withInitial, store: store);
    expect(find.byType(KitNetworkImage), findsNothing);
    await tester.tap(find.text('Галерея'));
    await tester.pumpAndSettle();
    expect(store.get('photoStatus'), 'removed');
    expect(find.byType(KitNetworkImage), findsNothing);
  });

  testWidgets('clearing a draft restores the saved photo by default', (
    tester,
  ) async {
    useHost(ImagePickerHost(() async => 'https://example.test/new.jpg'));
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    await pumpKit(tester, parser, {
      ...model,
      'initialUrl': 'https://example.test/saved.jpg',
    }, store: store);
    await tester.tap(find.text('Галерея'));
    await tester.pumpAndSettle();
    expect(find.text('Выбрано'), findsOneWidget);

    await tester.tap(find.text('Убрать'));
    await tester.pumpAndSettle();
    expect(store.get('photo'), '');
    expect(store.get('photoRemoved'), false);
    expect(find.text('Сохранено'), findsOneWidget);
    expect(find.text('Убрать'), findsNothing);
    expect(
      tester.widget<KitNetworkImage>(find.byType(KitNetworkImage)).src,
      'https://example.test/saved.jpg',
    );
  });

  testWidgets('resetting bound state clears a picked preview', (tester) async {
    useHost(ImagePickerHost(() async => 'https://example.test/picked.jpg'));
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    await pumpKit(tester, parser, model, store: store);
    await tester.tap(find.text('Галерея'));
    await tester.pumpAndSettle();
    expect(find.text('Выбрано'), findsOneWidget);

    store.set('photo', null);
    await tester.pumpAndSettle();
    expect(find.text('Добавить'), findsOneWidget);
    expect(find.byType(KitNetworkImage), findsNothing);
  });

  testWidgets('completion after unmount does not write to disposed state', (
    tester,
  ) async {
    final pending = Completer<String?>();
    useHost(ImagePickerHost(() => pending.future));
    final store = MiniAppStateStore();
    await pumpKit(tester, parser, model, store: store);
    await tester.tap(find.text('Камера'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    store.dispose();

    pending.complete('https://example.test/late.jpg');
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('replacing a state scope releases an old pending selection', (
    tester,
  ) async {
    final pending = Completer<String?>();
    var picks = 0;
    useHost(
      ImagePickerHost(
        () => picks++ == 0
            ? pending.future
            : Future.value('https://example.test/new-scope.jpg'),
      ),
    );
    final original = MiniAppStateStore();
    final replacement = MiniAppStateStore();
    addTearDown(original.dispose);
    addTearDown(replacement.dispose);
    await pumpKit(tester, parser, model, store: original);
    await tester.tap(find.text('Галерея'));
    await tester.pump();

    await pumpKit(tester, parser, model, store: replacement);
    expect(find.text('Загрузка фото'), findsNothing);
    await tester.tap(find.text('Галерея'));
    await tester.pumpAndSettle();
    expect(replacement.get('photo'), 'https://example.test/new-scope.jpg');

    pending.complete('https://example.test/old-scope.jpg');
    await tester.pumpAndSettle();
    expect(original.get('photo'), isNull);
    expect(replacement.get('photo'), 'https://example.test/new-scope.jpg');
    expect(tester.takeException(), isNull);
  });

  testWidgets('follow-up stays in the session that opened the picker', (
    tester,
  ) async {
    final pending = Completer<String?>();
    final original = ImagePickerHost(() => pending.future);
    final other = ImagePickerHost(() async => null);
    useHost(original);
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    await pumpKit(tester, parser, {
      ...model,
      'onChanged': {'actionType': 'reload'},
    }, store: store);
    await tester.tap(find.text('Галерея'));
    await tester.pump();
    useHost(other);

    pending.complete('https://example.test/photo.jpg');
    await tester.pumpAndSettle();
    expect(original.reloads, 1);
    expect(other.reloads, 0);
    expect(store.get('photo'), 'https://example.test/photo.jpg');
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow layout supports large text and reduced motion', (
    tester,
  ) async {
    final pending = Completer<String?>();
    useHost(ImagePickerHost(() => pending.future));
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(240, 1000),
            textScaler: TextScaler.linear(2),
            disableAnimations: true,
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 240,
                child: MiniAppStateScope(
                  store: store,
                  child: Builder(
                    builder: (context) => parser.parse(context, model),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher)).duration,
      Duration.zero,
    );
    final camera = tester.getTopLeft(find.text('Камера'));
    final gallery = tester.getTopLeft(find.text('Галерея'));
    expect(camera.dy, greaterThan(gallery.dy));
    await tester.tap(find.text('Галерея'));
    await tester.pump();
    pending.complete(null);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
