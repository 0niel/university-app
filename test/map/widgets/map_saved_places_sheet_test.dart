import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/widgets/map_saved_places_sheet.dart';

import '../../helpers/pump_app.dart';

class _Repository extends Fake implements MapDataRepository {
  bool authenticated = true;
  bool failLoading = false;
  bool failRemoving = false;
  bool remainsSaved = false;
  int loadCount = 0;
  (String, String)? removed;
  Completer<List<MapBookmark>>? pending;
  List<MapBookmark> bookmarks = [
    MapBookmark.fromJson({
      'campus_id': 'private-campus-id',
      'room_id': 'private-room-id',
      'room_label': 'А-201',
      'campus_title': 'В-78',
    }),
  ];

  @override
  bool get isAuthenticated => authenticated;

  @override
  Future<List<MapBookmark>> getBookmarks() async {
    loadCount++;
    if (failLoading) throw const MapDataException('offline');
    return pending?.future ?? bookmarks;
  }

  @override
  Future<bool> setBookmark(
    String campusId,
    String roomId, {
    required bool saved,
  }) async {
    expect(saved, isFalse);
    removed = (campusId, roomId);
    if (failRemoving) throw const MapDataException('offline');
    return remainsSaved;
  }
}

Widget _page(Widget child) => Scaffold(
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: child,
  ),
);

Future<void> _tap(WidgetTester tester, String label) async {
  final button = label == 'Убрать из сохранённых'
      ? find.byTooltip(label)
      : find.widgetWithText(AppButton, label);
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('signed out state does not query private bookmarks', (
    tester,
  ) async {
    final repository = _Repository()..authenticated = false;
    await tester.pumpApp(
      _page(
        MapSavedPlacesSheet(
          repository: repository,
          onOpen: (_) {},
        ),
      ),
    );
    expect(repository.loadCount, 0);
    expect(find.textContaining('Войдите в аккаунт'), findsOneWidget);
  });

  testWidgets('shows loading then opens named place without displaying IDs', (
    tester,
  ) async {
    final repository = _Repository()..pending = Completer<List<MapBookmark>>();
    MapBookmark? opened;
    await tester.pumpApp(
      _page(
        MapSavedPlacesSheet(
          repository: repository,
          onOpen: (bookmark) => opened = bookmark,
        ),
      ),
      size: const Size(320, 640),
      textScaler: const TextScaler.linear(2),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.pending!.complete(repository.bookmarks);
    await tester.pumpAndSettle();
    expect(find.text('А-201'), findsOneWidget);
    expect(find.text('В-78'), findsOneWidget);
    expect(find.textContaining('private-'), findsNothing);
    await tester.tap(find.text('А-201'));
    await tester.pumpAndSettle();
    expect(opened, same(repository.bookmarks.single));
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed load offers retry without claiming empty bookmarks', (
    tester,
  ) async {
    final repository = _Repository()..failLoading = true;
    await tester.pumpApp(
      _page(
        MapSavedPlacesSheet(
          repository: repository,
          onOpen: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Не удалось загрузить'), findsOneWidget);
    expect(find.textContaining('Пока нет сохранённых'), findsNothing);
    repository.failLoading = false;
    await _tap(tester, 'Повторить');
    expect(find.text('А-201'), findsOneWidget);
    expect(repository.loadCount, 2);
  });

  testWidgets(
    'removes only after server confirmation and shows empty guidance',
    (tester) async {
      final repository = _Repository();
      await tester.pumpApp(
        _page(
          MapSavedPlacesSheet(
            repository: repository,
            onOpen: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _tap(tester, 'Убрать из сохранённых');
      expect(repository.removed, ('private-campus-id', 'private-room-id'));
      expect(find.text('А-201'), findsNothing);
      expect(find.textContaining('Пока нет сохранённых'), findsOneWidget);
    },
  );

  testWidgets('failed removal retains the saved place', (tester) async {
    final repository = _Repository()..failRemoving = true;
    await tester.pumpApp(
      _page(
        MapSavedPlacesSheet(
          repository: repository,
          onOpen: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _tap(tester, 'Убрать из сохранённых');
    expect(find.text('А-201'), findsOneWidget);
    expect(find.textContaining('Не удалось убрать'), findsOneWidget);
  });

  testWidgets('server saved=true cannot be mistaken for successful removal', (
    tester,
  ) async {
    final repository = _Repository()..remainsSaved = true;
    await tester.pumpApp(
      _page(
        MapSavedPlacesSheet(
          repository: repository,
          onOpen: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _tap(tester, 'Убрать из сохранённых');
    expect(find.text('А-201'), findsOneWidget);
    expect(find.textContaining('Сервер не подтвердил'), findsOneWidget);
  });

  testWidgets('search filters saved rooms and clear restores the list', (
    tester,
  ) async {
    final repository = _Repository()
      ..bookmarks = [
        for (var index = 1; index <= 7; index++)
          MapBookmark.fromJson({
            'campus_id': 'v-78',
            'room_id': 'room-$index',
            'room_label': 'А-20$index',
            'campus_title': 'В-78',
          }),
      ];
    await tester.pumpApp(
      _page(MapSavedPlacesSheet(repository: repository, onOpen: (_) {})),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'А-203');
    await tester.pumpAndSettle();
    expect(find.text('А-203'), findsNWidgets(2));
    expect(find.text('А-201'), findsNothing);
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('А-201'), findsOneWidget);
    expect(repository.loadCount, 1);
  });
}
