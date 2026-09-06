import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_gallery.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_community_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_contribution_form.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_details_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_share_sheet.dart';

import '../../helpers/pump_app.dart';

class _Repository extends Fake implements MapDataRepository {
  bool authenticated = true;
  Exception? failure;
  DateTime? requestedDate;
  Map<String, Object?>? submitted;
  bool reviewed = false;
  Future<MapProposal> Function(String)? proposalLoader;
  int? confirmedRevision;
  List<MapBookmark> bookmarks = [];
  (String, bool)? bookmarkChange;
  Exception? bookmarkFailure;
  List<Map<String, Object?>> proposals = [];
  MapRoomDetails details = MapRoomDetails.fromJson({
    'room': _roomJson,
    'date': '2026-09-06',
    'schedule_linked': true,
    'schedule': [
      {
        'id': 'lesson',
        'title': 'Математический анализ',
        'start_time': '09:00:00',
        'end_time': '10:30:00',
        'groups': ['ИКБО-01-26'],
      },
    ],
    'revision': 2,
  });

  @override
  bool get isAuthenticated => authenticated;

  @override
  Future<MapRoomDetails> getRoom(
    String campusId,
    String roomId, {
    DateTime? date,
  }) async {
    requestedDate = date;
    if (failure != null) throw failure!;
    return details;
  }

  @override
  Future<List<MapBookmark>> getBookmarks() async => bookmarks;

  @override
  Future<MapProposalList> getProposals(
    String campusId, {
    String status = 'pending',
    int limit = 50,
  }) async => MapProposalList.fromJson({'proposals': proposals});

  @override
  Future<bool> setBookmark(
    String campusId,
    String roomId, {
    required bool saved,
  }) async {
    bookmarkChange = (roomId, saved);
    if (bookmarkFailure != null) throw bookmarkFailure!;
    return saved;
  }

  @override
  Future<MapRoomVerification> confirmRoom(
    String campusId,
    String roomId,
    int baseRevision, {
    bool confirmed = true,
  }) async {
    confirmedRevision = baseRevision;
    if (failure != null) throw failure!;
    return MapRoomVerification.fromJson({
      'confirmed_by_me': confirmed,
      'confirmation_count': confirmed ? 1 : 0,
    });
  }

  @override
  Future<MapProposal> submitProposal({
    required String campusId,
    required int baseRevision,
    required String entityType,
    required String entityId,
    required Map<String, Object?> patch,
    required String reason,
  }) async {
    submitted = {
      'campus_id': campusId,
      'base_revision': baseRevision,
      'entity_type': entityType,
      'entity_id': entityId,
      'patch': patch,
      'reason': reason,
    };
    if (failure != null) throw failure!;
    return MapProposal.fromJson({
      ...submitted!,
      'id': 'proposal',
      'status': 'pending',
    });
  }

  @override
  Future<MapProposal> getProposal(String id) => proposalLoader!(id);

  @override
  Future<MapProposal> reviewProposal(
    String id, {
    required bool approve,
    String? note,
  }) async {
    reviewed = true;
    if (failure != null) throw failure!;
    return MapProposal.fromJson({
      'id': id,
      'status': approve ? 'approved' : 'rejected',
    });
  }
}

class _PhotoRepository extends Fake implements CampusRepository {
  int loads = 0;

  @override
  Future<List<RoomPhoto>> getRoomPhotos({
    required String campus,
    required String roomKey,
  }) async {
    loads++;
    return [];
  }
}

const _roomJson = <String, Object?>{
  'id': 'room-1',
  'legacy_ids': ['previous-room-1'],
  'floor_id': 'floor-2',
  'label': 'А-201',
  'kind': 'classroom',
  'equipment': ['Проектор', 'Розетки'],
  'capacity': 30,
};

CampusMapData _campus({MapDataOrigin origin = MapDataOrigin.remote}) =>
    CampusMapData(
      campus: const CampusModel(
        id: 'campus-1',
        displayName: 'В-78',
        floors: [],
      ),
      floors: [],
      rooms: [MapPlaceData.fromJson(_roomJson)],
      graph: {},
      sourceUrl: 'https://pulse.mirea.ru/services/maps',
      sourceLabel: 'Пульс РТУ МИРЭА',
      revision: 2,
      origin: origin,
    );

Widget _page(Widget child) => Scaffold(
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: child,
  ),
);

Future<void> _tap(WidgetTester tester, String label) async {
  final button = find.widgetWithText(AppButton, label);
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> _input(WidgetTester tester, String label, String value) async {
  final field = find.descendant(
    of: find.widgetWithText(AppInputField, label),
    matching: find.byType(TextField),
  );
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pump();
}

void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  testWidgets(
    'place uses Moscow date and keeps schedule readable at large text',
    (tester) async {
      final repository = _Repository();
      await tester.pumpApp(
        _page(
          MapPlaceDetailsSheet(
            repository: repository,
            campus: _campus(),
            room: MapPlaceData.fromJson(_roomJson),
          ),
        ),
        size: const Size(320, 740),
        textScaler: const TextScaler.linear(2),
      );
      await tester.pumpAndSettle();
      final today = DateTime.now().toUtc().add(const Duration(hours: 3));
      expect(repository.requestedDate?.day, today.day);
      expect(repository.requestedDate?.month, today.month);
      expect(find.text('09:00–10:30'), findsOneWidget);
      expect(find.text('Математический анализ'), findsOneWidget);
      expect(find.text('pulse.mirea.ru · источник'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('unknown schedule never claims that the room is free', (
    tester,
  ) async {
    final repository = _Repository()
      ..details = MapRoomDetails.fromJson({
        'room': _roomJson,
        'schedule_linked': false,
        'schedule': <Object?>[],
      });
    await tester.pumpApp(
      _page(
        MapPlaceDetailsSheet(
          repository: repository,
          campus: _campus(),
          room: MapPlaceData.fromJson(_roomJson),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Занятость неизвестна'), findsOneWidget);
    expect(find.textContaining('занятий в расписании нет'), findsNothing);
  });

  testWidgets('photos disclose in place and load lazily at 320px double text', (
    tester,
  ) async {
    final repository = _Repository();
    final photos = _PhotoRepository();
    await tester.pumpApp(
      RepositoryProvider<CampusRepository>.value(
        value: photos,
        child: _page(
          MapPlaceDetailsSheet(
            repository: repository,
            campus: _campus(),
            room: MapPlaceData.fromJson(_roomJson),
          ),
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();
    expect(photos.loads, 0);
    final header = find.widgetWithText(AppListRow, 'Фотографии места');
    await tester.ensureVisible(header);
    await tester.pumpAndSettle();
    await tester.tap(header);
    await tester.pumpAndSettle();
    expect(photos.loads, 1);
    expect(find.byType(RoomPhotoGallery), findsOneWidget);
    expect(
      tester.getRect(find.byType(RoomPhotoGallery)).bottom,
      lessThan(tester.getRect(find.text('Предложить исправление')).top),
    );
    await tester.ensureVisible(find.text('Добавить фото'));
    await tester.pumpAndSettle();
    expect(
      tester
          .renderObject<RenderParagraph>(find.text('Добавить фото'))
          .didExceedMaxLines,
      isFalse,
    );
    await tester.tap(find.text('Добавить фото'));
    await tester.pumpAndSettle();
    expect(find.text('Камера'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('proposal review shows a place name instead of its database id', (
    tester,
  ) async {
    final proposalJson = <String, Object?>{
      'id': 'proposal',
      'entity_id': 'room-1',
      'entity_type': 'room',
      'status': 'pending',
      'reason': 'Проверено оснащение',
      'patch': {'description': 'Есть проектор'},
    };
    final proposal = MapProposal.fromJson(proposalJson);
    final repository = _Repository()
      ..proposals = [proposalJson]
      ..proposalLoader = (_) async => proposal;
    await tester.pumpApp(
      _page(MapCommunitySheet(repository: repository, campus: _campus())),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.tap(find.widgetWithText(AppChip, 'Предложения'));
    await tester.pumpAndSettle();
    await _tap(tester, 'Подробнее');
    expect(find.text('А-201'), findsOneWidget);
    expect(find.text('room-1'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saved legacy room toggles the canonical bookmark at 320px', (
    tester,
  ) async {
    final repository = _Repository()
      ..bookmarks = [
        MapBookmark.fromJson({
          'campus_id': 'campus-1',
          'room_id': 'previous-room-1',
        }),
      ];
    await tester.pumpApp(
      _page(
        MapPlaceDetailsSheet(
          repository: repository,
          campus: _campus(),
          room: MapPlaceData.fromJson(_roomJson),
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Убрать из избранного'));
    await tester.pumpAndSettle();
    expect(repository.bookmarkChange, ('room-1', false));
    expect(find.byTooltip('Сохранить место'), findsOneWidget);
    await tester.tap(find.byTooltip('Поделиться · QR-код'));
    await tester.pumpAndSettle();
    expect(find.byType(MapPlaceShareSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('outdated menu is explicitly dated and flagged', (tester) async {
    final room = MapPlaceData.fromJson({
      ..._roomJson,
      'kind': 'canteen',
      'menu_date': '2020-01-01',
      'menu': [
        {'name': 'Борщ', 'price': 120, 'currency': 'RUB'},
      ],
    });
    final repository = _Repository()
      ..failure = const MapDataException('offline');
    await tester.pumpApp(
      _page(
        MapPlaceDetailsSheet(
          repository: repository,
          campus: _campus(),
          room: room,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Меню · 1 января 2020'), findsOneWidget);
    expect(find.textContaining('Это меню на другую дату'), findsOneWidget);
    expect(find.text('120 ₽'), findsOneWidget);
    expect(find.textContaining('Не удалось обновить'), findsOneWidget);
  });

  testWidgets('relocated places explain that their entrances need review', (
    tester,
  ) async {
    final room = {..._roomJson, 'navigation_needs_review': true};
    final repository = _Repository()
      ..details = MapRoomDetails.fromJson({
        'room': room,
        'revision': 2,
        'schedule_linked': false,
      });
    await tester.pumpApp(
      _page(
        MapPlaceDetailsSheet(
          repository: repository,
          campus: _campus(),
          room: MapPlaceData.fromJson(room),
          onRouteTo: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Место перенесено. Проходы к нему ещё проверяются.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  for (final moved in [false, true]) {
    testWidgets(
      'latest room revision blocks stale route actions moved=$moved',
      (
        tester,
      ) async {
        var routes = 0;
        var refreshes = 0;
        final repository = _Repository()
          ..details = MapRoomDetails.fromJson({
            'room': {..._roomJson, 'navigation_needs_review': moved},
            'revision': 3,
            'schedule_linked': false,
          });
        await tester.pumpApp(
          _page(
            MapPlaceDetailsSheet(
              repository: repository,
              campus: _campus(),
              room: MapPlaceData.fromJson(_roomJson),
              onRouteFrom: () => routes++,
              onRouteTo: () => routes++,
              onRefreshMap: () => refreshes++,
            ),
          ),
          size: const Size(320, 568),
          textScaler: const TextScaler.linear(2),
        );
        await tester.pumpAndSettle();
        for (final label in ['Маршрут сюда', 'Отсюда']) {
          final button = find.widgetWithText(AppButton, label);
          expect(tester.widget<AppButton>(button).onPressed, isNull);
          await tester.ensureVisible(button);
          await tester.pumpAndSettle();
          await tester.tap(button);
        }
        expect(routes, 0);
        await tester.ensureVisible(find.text('Обновить карту'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Обновить карту'));
        expect(refreshes, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'bundled revision needs a full plan only after remote details load',
    (
      tester,
    ) async {
      for (final remoteLoaded in [false, true]) {
        var routes = 0;
        var refreshes = 0;
        final repository = _Repository()
          ..failure = remoteLoaded ? null : const MapDataException('offline');
        await tester.pumpApp(
          _page(
            MapPlaceDetailsSheet(
              key: ValueKey(remoteLoaded),
              repository: repository,
              campus: _campus(origin: MapDataOrigin.bundled),
              room: MapPlaceData.fromJson(_roomJson),
              onRouteFrom: () => routes++,
              onRouteTo: () => routes++,
              onRefreshMap: () => refreshes++,
            ),
          ),
          size: const Size(320, 568),
          textScaler: const TextScaler.linear(2),
        );
        await tester.pumpAndSettle();
        for (final label in ['Маршрут сюда', 'Отсюда']) {
          final button = find.widgetWithText(AppButton, label);
          expect(
            tester.widget<AppButton>(button).onPressed,
            remoteLoaded ? isNull : isNotNull,
          );
          await tester.ensureVisible(button);
          await tester.pumpAndSettle();
          await tester.tap(button);
        }
        expect(routes, remoteLoaded ? 0 : 2);
        if (remoteLoaded) {
          expect(find.textContaining('Обновите полный план'), findsOneWidget);
          await tester.ensureVisible(find.text('Обновить карту'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Обновить карту'));
          expect(refreshes, 1);
        } else {
          expect(find.text('Обновить карту'), findsNothing);
        }
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('room contribution previews and submits at 320px double text', (
    tester,
  ) async {
    final repository = _Repository();
    var complete = false;
    await tester.pumpApp(
      _page(
        MapContributionForm(
          repository: repository,
          campus: _campus(),
          room: MapPlaceData.fromJson(_roomJson),
          onSubmitted: () => complete = true,
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await _input(tester, 'Описание', 'Кабинет самостоятельной работы');
    await _input(
      tester,
      'Почему данные нужно изменить',
      'Проверено лично сегодня у аудитории',
    );
    await _input(
      tester,
      'Ссылка на источник, если есть',
      'https://pulse.mirea.ru/services/maps',
    );
    await _tap(tester, 'Проверить предложение');
    expect(repository.submitted, isNull);
    expect(find.text('Предлагаемые изменения'), findsOneWidget);
    await _tap(tester, 'Отправить на проверку');
    expect(complete, isTrue);
    expect(repository.submitted?['base_revision'], 2);
    expect(repository.submitted?['entity_type'], 'room');
    expect(repository.submitted?['patch'], {
      'description': 'Кабинет самостоятельной работы',
    });
    expect(
      repository.submitted?['reason'],
      contains('Источник: https://pulse.mirea.ru'),
    );
  });

  testWidgets('failed submission preserves draft and never reports success', (
    tester,
  ) async {
    final repository = _Repository()
      ..failure = const MapDataException('stale', code: '40001');
    var complete = false;
    await tester.pumpApp(
      _page(
        MapContributionForm(
          repository: repository,
          campus: _campus(),
          room: MapPlaceData.fromJson(_roomJson),
          onSubmitted: () => complete = true,
        ),
      ),
    );
    await _input(tester, 'Описание', 'Новое описание аудитории');
    await _input(
      tester,
      'Почему данные нужно изменить',
      'Проверено лично сегодня у аудитории',
    );
    await _tap(tester, 'Проверить предложение');
    await _tap(tester, 'Отправить на проверку');
    expect(complete, isFalse);
    expect(find.textContaining('Карта уже изменилась'), findsOneWidget);
    expect(find.text('Новое описание аудитории'), findsOneWidget);
  });

  testWidgets('unauthenticated draft cannot be submitted', (tester) async {
    final repository = _Repository()..authenticated = false;
    await tester.pumpApp(
      _page(
        MapContributionForm(
          repository: repository,
          campus: _campus(),
          room: MapPlaceData.fromJson(_roomJson),
          onSubmitted: () {},
        ),
      ),
    );
    await _input(tester, 'Описание', 'Новое описание аудитории');
    await _input(
      tester,
      'Почему данные нужно изменить',
      'Проверено лично сегодня у аудитории',
    );
    await _tap(tester, 'Проверить предложение');
    final button = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Отправить на проверку'),
    );
    expect(button.onPressed, isNull);
    expect(repository.submitted, isNull);
  });

  testWidgets('menu proposal records price and date at 320px double text', (
    tester,
  ) async {
    final repository = _Repository();
    await tester.pumpApp(
      _page(
        MapContributionForm(
          repository: repository,
          campus: _campus(),
          room: MapPlaceData.fromJson(_roomJson),
          onSubmitted: () {},
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.ensureVisible(find.widgetWithText(AppChip, 'Меню'));
    await tester.tap(find.widgetWithText(AppChip, 'Меню'));
    await tester.pumpAndSettle();
    await _input(tester, 'Название блюда', 'Гречка с овощами');
    await _input(tester, 'Цена, ₽', '99,50');
    await _input(
      tester,
      'Почему данные нужно изменить',
      'Меню проверено сегодня в столовой',
    );
    await _tap(tester, 'Проверить предложение');
    await _tap(tester, 'Отправить на проверку');
    final patch = repository.submitted!['patch']! as Map<String, Object?>;
    expect(patch['menu'], [
      {
        'name': 'Гречка с овощами',
        'price': 99.5,
        'currency': 'RUB',
        'available': true,
      },
    ]);
    final menuDate = DateTime.parse(patch['menu_date']! as String);
    final expiry = DateTime.parse(patch['expires_at']! as String);
    expect(
      expiry,
      DateTime.utc(
        menuDate.year,
        menuDate.month,
        menuDate.day + 1,
      ).subtract(const Duration(hours: 3)),
    );
  });

  testWidgets('plan report preserves the target without fabricating geometry', (
    tester,
  ) async {
    final repository = _Repository();
    await tester.pumpApp(
      _page(
        MapContributionForm(
          repository: repository,
          campus: _campus(),
          floorId: 'floor-2',
          onSubmitted: () {},
        ),
      ),
    );
    await _input(
      tester,
      'Где и что нужно проверить',
      'Второй этаж, проход у А-201 закрыт',
    );
    await _input(
      tester,
      'Почему данные нужно изменить',
      'Проверено лично сегодня на втором этаже',
    );
    await _tap(tester, 'Проверить предложение');
    await _tap(tester, 'Отправить на проверку');
    expect(repository.submitted?['entity_type'], 'report');
    expect(repository.submitted?['entity_id'], 'floor-2');
    expect(repository.submitted?['patch'], {
      'category': 'plan',
      'details': 'Второй этаж, проход у А-201 закрыт',
    });
  });

  testWidgets('community verification confirms only the displayed revision', (
    tester,
  ) async {
    final repository = _Repository();
    await tester.pumpApp(
      _page(
        MapPlaceDetailsSheet(
          repository: repository,
          campus: _campus(),
          room: MapPlaceData.fromJson(_roomJson),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _tap(tester, 'Подтверждаю сведения');
    expect(repository.confirmedRevision, 2);
    expect(find.text('Подтверждений этой версии: 1'), findsOneWidget);
    expect(find.text('Отозвать подтверждение'), findsOneWidget);
  });

  testWidgets('review rejects own approval even if API flag is incorrect', (
    tester,
  ) async {
    final repository = _Repository();
    await tester.pumpApp(
      _page(
        MapProposalReview(
          repository: repository,
          proposal: MapProposal.fromJson({
            'id': 'proposal',
            'status': 'pending',
            'entity_type': 'room',
            'is_mine': true,
            'can_review': true,
            'reason': 'Уточнено оснащение',
            'patch': {
              'equipment': ['Проектор'],
            },
          }),
        ),
      ),
    );
    expect(find.text('Принять и опубликовать'), findsNothing);
    expect(find.textContaining('другой модератор'), findsOneWidget);
    expect(repository.reviewed, isFalse);
  });

  testWidgets('moderator must explain rejection and conflict stays visible', (
    tester,
  ) async {
    final repository = _Repository()
      ..failure = const MapDataException('stale', code: '40001');
    await tester.pumpApp(
      _page(
        MapProposalReview(
          repository: repository,
          proposal: MapProposal.fromJson({
            'id': 'proposal',
            'status': 'pending',
            'entity_type': 'room',
            'is_mine': false,
            'can_review': true,
            'reason': 'Уточнено оснащение',
            'patch': {
              'equipment': ['Проектор'],
            },
          }),
        ),
      ),
    );
    await _tap(tester, 'Отклонить');
    expect(repository.reviewed, isFalse);
    expect(find.textContaining('Укажите причину отклонения'), findsOneWidget);
    await _tap(tester, 'Принять и опубликовать');
    expect(repository.reviewed, isTrue);
    expect(find.textContaining('Карта уже изменилась'), findsOneWidget);
  });

  testWidgets('summary review waits for detail and retries before decisions', (
    tester,
  ) async {
    final first = Completer<MapProposal>();
    final second = Completer<MapProposal>();
    var loads = 0;
    final repository = _Repository()
      ..proposalLoader = (id) {
        expect(id, 'proposal');
        return ++loads == 1 ? first.future : second.future;
      };
    final summary = <String, Object?>{
      'id': 'proposal',
      'status': 'pending',
      'entity_type': 'room',
      'is_mine': false,
      'can_review': true,
      'reason': 'Уточнено оснащение',
      'has_full_patch': false,
      'patch_keys': ['equipment'],
      'patch_bytes': 42,
    };
    await tester.pumpApp(
      _page(
        MapProposalReview(
          repository: repository,
          proposal: MapProposal.fromJson(summary),
        ),
      ),
    );
    expect(loads, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Принять и опубликовать'), findsNothing);
    first.completeError(const MapDataException('Offline'));
    await tester.pumpAndSettle();
    expect(find.text('Повторить загрузку изменений'), findsOneWidget);
    expect(repository.reviewed, isFalse);
    await tester.tap(find.text('Повторить загрузку изменений'));
    await tester.pump();
    expect(loads, 2);
    expect(find.text('Принять и опубликовать'), findsNothing);
    second.complete(
      MapProposal.fromJson({
        ...summary,
        'has_full_patch': true,
        'patch': {
          'equipment': ['Проектор'],
        },
      }),
    );
    await tester.pumpAndSettle();
    expect(find.text('Проектор'), findsOneWidget);
    expect(find.text('Принять и опубликовать'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail permissions replace stale summary permissions', (
    tester,
  ) async {
    final repository = _Repository()
      ..proposalLoader = (_) async => MapProposal.fromJson({
        'id': 'proposal',
        'status': 'approved',
        'can_review': false,
        'patch': {'label': 'А-201'},
        'has_full_patch': true,
      });
    await tester.pumpApp(
      _page(
        MapProposalReview(
          repository: repository,
          proposal: MapProposal.fromJson({
            'id': 'proposal',
            'status': 'pending',
            'can_review': true,
            'has_full_patch': false,
          }),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Принять и опубликовать'), findsNothing);
    expect(find.text('Опубликовано'), findsOneWidget);
    expect(repository.reviewed, isFalse);
  });

  testWidgets('graph preview never serializes thousands of nodes and edges', (
    tester,
  ) async {
    await tester.pumpApp(
      _page(
        MapPatchPreview(
          patch: {
            'nodes': List.filled(16217, const _NoGraphSerialization()),
            'edges': List.filled(41104, const _NoGraphSerialization()),
          },
        ),
      ),
    );
    expect(find.textContaining('Точек в схеме:'), findsOneWidget);
    expect(find.textContaining('Проходов в схеме:'), findsOneWidget);
    expect(find.byType(SelectableText), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('QR share copies the place link at 320px double text', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpApp(
      _page(
        const MapPlaceShareSheet(
          campusId: 'campus-1',
          roomId: 'room-1',
          title: 'А-201',
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();
    await _tap(tester, 'Копировать');
    expect(copied, mapPlaceShareLink('campus-1', 'room-1').toString());
    expect(find.text('Ссылка скопирована'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test(
    'shared place URL encodes both identifiers without injecting parameters',
    () {
      final uri = mapPlaceShareLink('campus&room=wrong', 'А-201 & entrance');
      expect(uri.queryParameters, {
        'campus': 'campus&room=wrong',
        'room': 'А-201 & entrance',
      });
      expect(uri.path, endsWith('/services/map'));
    },
  );
}

class _NoGraphSerialization {
  const _NoGraphSerialization();
  Object toJson() => throw StateError('Graph preview must use counts only');
}
