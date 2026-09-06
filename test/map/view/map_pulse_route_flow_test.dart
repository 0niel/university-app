import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';
import 'package:rtu_mirea_app/map/view/map_view.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_details_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';

import '../../helpers/pump_app.dart';

class _CampusRepository extends Mock implements CampusRepository {}

class _NoCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

void main() {
  for (final (campusId, campusTitle, startLabel, destinationLabel, searchTitle)
      in const [
        ('v-78', 'В-78', 'А-107', 'А-203', 'А-203'),
        ('v-86', 'В-86', 'Главный вход', 'К-124', 'К-124'),
        ('s-20', 'С-20', 'Вход', '102', 'Аудитория 102'),
      ]) {
    testWidgets('public $campusId room search and picker draw the Pulse path', (
      tester,
    ) async {
      Map<String, dynamic>? refreshedCampus;
      late final Completer<void> refreshEntered;
      late final Completer<void> releaseRefresh;
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _NoCache(),
        bundledCatalogAsset: MapDataRepository.pulseCatalogAsset,
        rpc: (name, _) async {
          if (refreshedCampus != null) {
            if (name == 'get_map_catalog') {
              refreshEntered.complete();
              await releaseRefresh.future;
              return {
                'campuses': [
                  {
                    'id': campusId,
                    'short_title': campusTitle,
                    'revision': refreshedCampus['revision'],
                  },
                ],
              };
            }
            if (name == 'get_map_campus') return refreshedCampus;
          }
          throw const MapDataException('offline');
        },
      );
      late MapBloc map;
      late FreeRoomsCubit free;
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(() async {
          if (!releaseRefresh.isCompleted) releaseRefresh.complete();
          await map.close();
          await free.close();
          repository.dispose();
        });
      });
      await tester.runAsync(() async {
        refreshEntered = Completer<void>();
        releaseRefresh = Completer<void>();
        map = MapBloc(
          availableCampuses: const [],
          repository: repository,
          objectsService: ObjectsService(
            onLoadObjects: (_) async => '{"objects":[]}',
          ),
        );
        final campusRepository = _CampusRepository();
        when(campusRepository.getFreeRooms).thenAnswer((_) async => []);
        free = FreeRoomsCubit(campusRepository: campusRepository);
        final ready = map.stream.firstWhere(
          (state) => state.status == .loaded || state.status == .failure,
        );
        map.add(const MapEvent.initialized());
        await ready.timeout(const Duration(seconds: 30));
        await free.load();
      });
      expect(map.state.status, MapStatus.loaded);
      expect(map.state.selectedCampus?.id, 'v-78');
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<MapBloc>.value(value: map),
            BlocProvider<FreeRoomsCubit>.value(value: free),
          ],
          child: const MapView(),
        ),
        size: const Size(390, 844),
      );
      await tester.pumpAndSettle();

      if (campusId != 'v-78') {
        await tester.tap(find.widgetWithText(AppButton, 'В-78'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(campusTitle));
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          if (map.state.status != .loaded ||
              map.state.selectedCampus?.id != campusId) {
            await map.stream.firstWhere(
              (state) =>
                  state.status == .loaded &&
                  state.selectedCampus?.id == campusId,
            );
          }
        });
        await tester.pumpAndSettle();
      }

      await tester.enterText(find.byType(AppSearchField), destinationLabel);
      await tester.pumpAndSettle();
      await tester.tap(find.text(searchTitle).last);
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        if (map.state.status != .loaded) {
          await map.stream.firstWhere((state) => state.status == .loaded);
        }
      });
      await tester.pumpAndSettle();
      expect(find.byType(MapPlaceDetailsSheet), findsOneWidget);
      await tester.tap(find.text('Маршрут сюда'));
      await tester.pumpAndSettle();
      expect(find.byType(MapRouteSheet), findsOneWidget);
      expect(find.text('Куда: $destinationLabel'), findsOneWidget);
      await tester.tap(find.text('Выберите начало'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, startLabel);
      await tester.pumpAndSettle();
      await tester.tap(find.text(startLabel).last);
      await tester.pumpAndSettle();
      if (campusId == 'v-78') {
        expect(find.text('По лестнице на 2 этаж'), findsOneWidget);
      }
      await tester.ensureVisible(find.text('Показать путь'));
      await tester.tap(find.text('Показать путь'));
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        if (map.state.status != .loaded) {
          await map.stream.firstWhere((state) => state.status == .loaded);
        }
      });
      await tester.pumpAndSettle();
      expect(find.byType(MapRouteSheet), findsNothing);
      expect(find.byTooltip('Завершить маршрут'), findsOneWidget);
      expect(map.state.selectedFloor?.number, 1);
      expect(
        tester
            .widget<MapFloorCanvas>(find.byType(MapFloorCanvas))
            .routeSegments,
        isNotEmpty,
      );
      expect(
        tester
            .widget<DraggableScrollableSheet>(
              find.byType(DraggableScrollableSheet),
            )
            .controller!
            .size,
        lessThan(.5),
        reason: 'Search results must not cover the route after applying it',
      );
      expect(free.state.query, isEmpty);
      await tester.tap(find.text('Маршрут'));
      await tester.pumpAndSettle();
      expect(find.text('Откуда: $startLabel'), findsOneWidget);
      final campus = map.state.campusData!;
      final destination = tester.widget<MapRouteSheet>(
        find.byType(MapRouteSheet),
      );
      final startRoom = campus.placeForId(destination.startRoomId!);
      expect(startRoom?.label, startLabel);
      expect(
        campus.placeForId(startRoom!.sourceDatabaseId!)?.id,
        startRoom.id,
      );
      if (campusId == 'v-78') {
        destination.onClose!();
        await tester.pumpAndSettle();
        final nextBeforeRefresh = tester
            .widget<AppIconButton>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is AppIconButton &&
                    widget.tooltip == 'Следующий шаг',
              ),
            )
            .onPressed!;
        final previousStep = tester
            .widget<Text>(find.textContaining('Шаг 1 из'))
            .data;
        refreshedCampus =
            jsonDecode(
                  File(
                    'packages/app_ui/assets/maps/pulse/campus_v-78.json',
                  ).readAsStringSync(),
                )
                as Map<String, dynamic>;
        refreshedCampus['revision'] = campus.revision + 1;
        for (final edge
            in (refreshedCampus['graph'] as Map)['edges'] as List) {
          (edge as Map)['closed'] = true;
        }
        await tester.runAsync(() async {
          map.add(const MapEvent.refreshRequested());
          await refreshEntered.future.timeout(const Duration(seconds: 5));
        });
        await tester.pump();
        expect(map.state.status, MapStatus.loading);
        nextBeforeRefresh();
        await tester.pump();
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pump();
        expect(
          find.text(previousStep!),
          findsOneWidget,
          reason: 'An in-flight next-step callback must not use the old plan',
        );
        expect(
          map.state.status,
          MapStatus.loading,
          reason: 'Route advancement must not replace the pending refresh',
        );
        final nextDuringRefresh = tester.widget<AppIconButton>(
          find.byWidgetPredicate(
            (widget) =>
                widget is AppIconButton && widget.tooltip == 'Следующий шаг',
          ),
        );
        expect(nextDuringRefresh.onPressed, isNull);
        await tester.runAsync(() async {
          final updated = map.stream.firstWhere(
            (state) =>
                state.status == .loaded &&
                state.campusData?.revision == campus.revision + 1,
          );
          releaseRefresh.complete();
          await updated.timeout(const Duration(seconds: 15));
        });
        await tester.pumpAndSettle();
        expect(find.byTooltip('Завершить маршрут'), findsNothing);
        expect(
          tester
              .widget<MapFloorCanvas>(find.byType(MapFloorCanvas))
              .routeSegments,
          isEmpty,
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
}
