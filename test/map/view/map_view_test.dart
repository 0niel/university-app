import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/map/map.dart';
import 'package:rtu_mirea_app/map/services/map_volume_projection.dart';
import 'package:rtu_mirea_app/map/widgets/map_volume_layer.dart';

import '../../helpers/pump_app.dart';

class _MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class _MockFreeRoomsCubit extends MockCubit<FreeRoomsState>
    implements FreeRoomsCubit {}

class _RecordingMapController extends SvgInteractiveMapController {
  int zoomInCalls = 0;
  int zoomOutCalls = 0;
  int fitCalls = 0;

  @override
  void zoomIn() {
    zoomInCalls++;
    super.zoomIn();
  }

  @override
  void zoomOut() {
    zoomOutCalls++;
    super.zoomOut();
  }

  @override
  void fit() {
    fitCalls++;
    super.fit();
  }
}

void main() {
  const asset = 'packages/app_ui/assets/icons/oval.svg';
  const secondAsset = 'packages/app_ui/assets/icons/tag.svg';
  const firstFloor = FloorModel(id: 'v78-1', number: 1, svgPath: asset);
  const secondFloor = FloorModel(
    id: 'v78-2',
    number: 2,
    svgPath: secondAsset,
  );
  const campuses = [
    CampusModel(
      id: 'v78',
      displayName: 'В-78',
      floors: [firstFloor, secondFloor],
    ),
    CampusModel(id: 's20', displayName: 'С-20', floors: [firstFloor]),
    CampusModel(id: 'mp1', displayName: 'МП-1', floors: [firstFloor]),
  ];

  late _MockMapBloc bloc;
  late _MockFreeRoomsCubit freeRooms;

  setUp(() {
    bloc = _MockMapBloc();
    freeRooms = _MockFreeRoomsCubit();
    when(() => freeRooms.state).thenReturn(
      const FreeRoomsState(
        status: FreeRoomsStatus.populated,
        rooms: [FreeRoom(room: 'А-101', campus: 'В-78')],
      ),
    );
    addTearDown(bloc.close);
    addTearDown(freeRooms.close);
  });

  Widget provide(Widget child) => MultiBlocProvider(
    providers: [
      BlocProvider<MapBloc>.value(value: bloc),
      BlocProvider<FreeRoomsCubit>.value(value: freeRooms),
    ],
    child: child,
  );

  Future<void> pumpMap(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    TextScaler textScaler = TextScaler.noScaling,
    SvgInteractiveMapController? mapController,
    bool initialize = true,
    bool failure = false,
    bool reduceMotion = false,
    bool reloading = false,
    bool navigationViewport = false,
    String? dataWarning,
    List<RoomModel>? rooms,
    Rect bounds = const Rect.fromLTWH(0, 0, 600, 400),
  }) async {
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
    final state = failure
        ? const MapState(status: .failure, errorMessage: 'boom')
        : initialize
        ? MapState(
            status: reloading ? .loading : .loaded,
            availableCampuses: campuses,
            selectedCampus: campuses.first,
            selectedFloor: firstFloor,
            rooms:
                rooms ??
                [
                  RoomModel(
                    roomId: 'v78__r__101',
                    name: 'А-101',
                    path: Path()..addRect(const Rect.fromLTWH(0, 0, 40, 40)),
                  ),
                  RoomModel(
                    roomId: 'v78__r__205',
                    name: 'Б-205',
                    path: Path()..addRect(const Rect.fromLTWH(60, 0, 40, 40)),
                  ),
                ],
            boundingRect: bounds,
            dataWarning: dataWarning,
          )
        : const MapState();
    when(() => bloc.state).thenReturn(state);
    await tester.pumpApp(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: reduceMotion,
            accessibleNavigation: reduceMotion,
          ),
          child: navigationViewport
              ? AppBottomBarViewport(
                  bottomInset: AppBottomBar.extentOf(context),
                  child: provide(MapView(mapController: mapController)),
                )
              : provide(MapView(mapController: mapController)),
        ),
      ),
      size: size,
      textScaler: textScaler,
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('uses a full-bleed map with an expandable level panel', (
    tester,
  ) async {
    await pumpMap(tester);

    expect(find.byType(SvgInteractiveMap), findsOneWidget);
    final map = tester.widget<SvgInteractiveMap>(
      find.byType(SvgInteractiveMap),
    );
    expect(map.viewportPadding.top, greaterThan(52));
    expect(map.viewportPadding.bottom, greaterThan(60));
    expect(map.viewportPadding.bottom, lessThan(200));
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    expect(find.byType(AppInnerHeader), findsNothing);
    expect(find.byType(Divider), findsNothing);
    expect(find.text('В-78'), findsWidgets);
    expect(find.text('Аудитория, кафедра, столовая'), findsOneWidget);
    expect(find.text('1 этаж'), findsWidgets);

    expect(find.byType(MapFreeRoomsPanel), findsOneWidget);
    expect(find.byType(MapTopBar), findsOneWidget);

    await tester.tap(find.text('В-78').first);
    await tester.pumpAndSettle();

    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    expect(sheet.maxChildSize, greaterThan(sheet.initialChildSize));
  });

  testWidgets('keeps room search in the top chrome', (tester) async {
    const size = Size(390, 844);
    await pumpMap(tester);

    final search = tester.getRect(find.text('Аудитория, кафедра, столовая'));
    expect(search.center.dy, lessThan(size.height * .2));
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('friends action inside search works at 320px and $scale text', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        await pumpMap(
          tester,
          size: const Size(320, 568),
          textScaler: TextScaler.linear(scale),
        );
        final search = find.byType(AppSearchField);
        final friends = find.descendant(
          of: search,
          matching: find.bySemanticsLabel('Друзья на карте'),
        );
        expect(friends, findsOneWidget);
        expect(
          tester.getRect(search).contains(tester.getCenter(friends)),
          isTrue,
        );
        await tester.enterText(search, 'А-101');
        await tester.pumpAndSettle();
        expect(friends, findsNothing);
        final clearLabel = MaterialLocalizations.of(
          tester.element(search),
        ).deleteButtonTooltip;
        await tester.tap(
          find.descendant(
            of: search,
            matching: find.bySemanticsLabel(clearLabel),
          ),
        );
        await tester.pumpAndSettle();
        expect(friends, findsOneWidget);
        await tester.tap(friends);
        await tester.pumpAndSettle();
        expect(
          find.textContaining('Позиции внутри здания и этажи неизвестны.'),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(AppButton, 'Друзья на карте'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    });
  }

  testWidgets('uses one campus selector and preserves every campus choice', (
    tester,
  ) async {
    await pumpMap(tester);
    expect(find.text('С-20'), findsNothing);
    expect(find.text('МП-1'), findsNothing);
    await tester.tap(find.widgetWithText(AppButton, 'В-78'));
    await tester.pumpAndSettle();
    expect(find.text('Кампусы'), findsOneWidget);
    await tester.tap(find.text('С-20'));
    await tester.pumpAndSettle();
    verify(() => bloc.add(MapEvent.campusSelected(campuses[1]))).called(1);
  });

  testWidgets('standalone map reserves no phantom navigation bar', (
    tester,
  ) async {
    await pumpMap(tester);
    final panel = tester.widget<MapFreeRoomsPanel>(
      find.byType(MapFreeRoomsPanel),
    );
    expect(panel.bottomInset, 0);
    expect(panel.compactContentExtent, lessThan(100));
    final bounds = tester.getRect(
      find.byKey(const ValueKey('map-panel-surface')),
    );
    expect(bounds.height, closeTo(panel.compactContentExtent, 1));
  });

  testWidgets(
    'manual refresh reports fallback once without a permanent banner',
    (
      tester,
    ) async {
      final states = StreamController<MapState>.broadcast();
      addTearDown(states.close);
      whenListen(bloc, states.stream, initialState: const MapState());
      await pumpMap(tester);
      final initial = bloc.state;
      await tester.tap(find.byTooltip('Действия с картой'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('О плане и источнике'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Проверить обновления'));
      await tester.pumpAndSettle();
      states.add(initial.copyWith(status: MapStatus.loading));
      await tester.pump();
      states.add(initial.copyWith(isOffline: true));
      await tester.pumpAndSettle();
      expect(
        find.text('Сервер недоступен. Показан встроенный план.'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      states.add(initial.copyWith(roomFloors: {'101': 1}));
      await tester.pumpAndSettle();
      expect(
        find.text('Сервер недоступен. Показан встроенный план.'),
        findsNothing,
      );
      expect(find.text('Сохранённый план · обновить'), findsNothing);
    },
  );

  testWidgets(
    'bundled fallback does not nag and refresh remains in plan information',
    (tester) async {
      await pumpMap(tester, dataWarning: 'Нет связи с каталогом');
      expect(find.text('Сохранённый план · обновить'), findsNothing);
      expect(find.text('Нет связи с каталогом'), findsNothing);
      await tester.tap(find.byTooltip('Действия с картой'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('О плане и источнике'));
      await tester.pumpAndSettle();
      expect(find.textContaining('План входит в приложение'), findsOneWidget);
      await tester.tap(find.text('Проверить обновления'));
      await tester.pumpAndSettle();
      verify(() => bloc.add(const MapEvent.refreshRequested())).called(1);
    },
  );

  testWidgets('starts compact and collapses back after expansion', (
    tester,
  ) async {
    await pumpMap(tester, reduceMotion: true);
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    expect(sheet.initialChildSize, lessThan(.4));
    expect(sheet.minChildSize, sheet.initialChildSize);
    final compactPadding = tester
        .widget<SvgInteractiveMap>(
          find.byType(SvgInteractiveMap),
        )
        .viewportPadding
        .bottom;
    await tester.tap(find.byTooltip('Развернуть список'));
    await tester.pump();
    expect(sheet.controller!.size, .78);
    expect(find.byType(MapCanvasControls), findsNothing);
    expect(find.byType(AppSearchField).hitTestable(), findsOneWidget);
    expect(
      tester
          .widget<SvgInteractiveMap>(find.byType(SvgInteractiveMap))
          .viewportPaddingListenable!
          .value
          .bottom,
      greaterThan(compactPadding),
    );
    await tester.tap(find.byTooltip('Свернуть список'));
    await tester.pump();
    expect(sheet.controller!.size, sheet.minChildSize);
    expect(find.byType(MapCanvasControls), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sheet animation keeps the map and content trees stable', (
    tester,
  ) async {
    await pumpMap(tester);
    final map = tester.widget<SvgInteractiveMap>(
      find.byType(SvgInteractiveMap),
    );
    final topBar = tester.widget<MapTopBar>(find.byType(MapTopBar));
    final panel = tester.widget<MapFreeRoomsPanel>(
      find.byType(MapFreeRoomsPanel),
    );
    final transform = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!;
    var transformUpdates = 0;
    transform.addListener(() => transformUpdates++);
    await tester.tap(find.byTooltip('Развернуть список'));
    await tester.pump();
    for (var frame = 0; frame < 20; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(
        tester.widget<SvgInteractiveMap>(find.byType(SvgInteractiveMap)),
        same(map),
      );
      expect(tester.widget<MapTopBar>(find.byType(MapTopBar)), same(topBar));
      expect(
        tester.widget<MapFreeRoomsPanel>(find.byType(MapFreeRoomsPanel)),
        same(panel),
      );
    }
    expect(transformUpdates, 0);
    expect(
      map.viewportPaddingListenable!.value.bottom,
      closeTo(844 * .78 + AppSpacing.md, .1),
    );
    await tester.pump(const Duration(milliseconds: 140));
    await tester.pumpAndSettle();
    expect(transformUpdates, greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  testWidgets('sheet drag retains the map transform until settling', (
    tester,
  ) async {
    await pumpMap(tester);
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    final transform = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!;
    final initial = transform.value.clone();
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Места')),
    );
    for (var frame = 0; frame < 10; frame++) {
      await gesture.moveBy(const Offset(0, -20));
      await tester.pump(const Duration(milliseconds: 16));
      expect(transform.value, initial);
    }
    expect(sheet.controller!.size, greaterThan(sheet.minChildSize));
    await gesture.up();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 140));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced-motion refit respects a newer zoom command', (
    tester,
  ) async {
    final controller = SvgInteractiveMapController();
    addTearDown(controller.dispose);
    await pumpMap(tester, reduceMotion: true, mapController: controller);
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    sheet.controller!.jumpTo(sheet.maxChildSize);
    controller.zoomIn();
    final zoomedScale = controller.currentScale;
    await tester.pump();
    expect(controller.currentScale, zoomedScale);
    expect(tester.takeException(), isNull);
  });

  testWidgets('typing a room query expands reachable results', (tester) async {
    await pumpMap(tester);
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    expect(sheet.controller!.size, sheet.minChildSize);
    await tester.enterText(find.byType(TextField), 'А-101');
    await tester.pumpAndSettle();
    verify(() => freeRooms.queryChanged('А-101')).called(1);
    expect(sheet.controller!.size, sheet.maxChildSize);
    expect(
      find
          .descendant(
            of: find.byType(MapFreeRoomsPanel),
            matching: find.text('А-101'),
          )
          .hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation viewport is reserved once in the compact panel', (
    tester,
  ) async {
    await pumpMap(tester, navigationViewport: true);
    final panel = tester.widget<MapFreeRoomsPanel>(
      find.byType(MapFreeRoomsPanel),
    );
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    expect(
      panel.bottomInset,
      AppControlSize.bottomBar +
          NinjaBottomBar.topPadding +
          NinjaBottomBar.bottomPadding,
    );
    expect(sheet.initialChildSize, lessThan(.4));
    expect(
      sheet.initialChildSize * 844 - panel.bottomInset,
      moreOrLessEquals(panel.compactContentExtent),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('header drag returns to the compact map viewport', (
    tester,
  ) async {
    await pumpMap(tester);
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    sheet.controller!.jumpTo(sheet.maxChildSize);
    await tester.pumpAndSettle();
    await tester.drag(find.text('Места'), const Offset(0, 420));
    await tester.pumpAndSettle();
    expect(sheet.controller!.size, moreOrLessEquals(sheet.minChildSize));
    expect(tester.takeException(), isNull);
  });

  testWidgets('separates the map and panel with flat kit surfaces', (
    tester,
  ) async {
    await pumpMap(tester);

    final colors = tester.element(find.byType(MapView)).colors;
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, colors.canvas);
    final mapSurface = tester.widget<ColoredBox>(
      find.byKey(const ValueKey('map-canvas-surface')),
    );
    final panelSurface = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('map-panel-surface')),
    );
    final panelDecoration = panelSurface.decoration as BoxDecoration;
    expect(mapSurface.color, colors.surface2);
    expect(panelDecoration.color, colors.canvas);
    expect(panelDecoration.color, isNot(mapSurface.color));
    expect(panelDecoration.border, Border.all(color: colors.line));

    final decorations = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>();
    expect(decorations, isNotEmpty);
    expect(
      decorations.every(
        (decoration) =>
            decoration.boxShadow == null && decoration.gradient == null,
      ),
      isTrue,
    );
  });

  testWidgets('compact panel does not show a clipped room card', (
    tester,
  ) async {
    await pumpMap(tester, navigationViewport: true);
    expect(find.byKey(const ValueKey('free-rooms-list')), findsNothing);
    final scroll = tester.getRect(
      find.byKey(const ValueKey('map-panel-scroll')),
    );
    final panel = tester.widget<MapFreeRoomsPanel>(
      find.byType(MapFreeRoomsPanel),
    );
    expect(scroll.bottom, 844 - panel.bottomInset);
    expect(tester.getRect(find.text('1 этаж')).bottom, lessThan(scroll.bottom));
    await tester.tap(find.byTooltip('Развернуть список'));
    await tester.pumpAndSettle();
    expect(find.text('А-101').hitTestable(), findsOneWidget);
    await tester.tap(find.byTooltip('Свернуть список'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('free-rooms-list')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the free rooms header and campus context', (
    tester,
  ) async {
    await pumpMap(tester);
    expect(find.text('Места'), findsOneWidget);
    expect(find.text('Свободно сейчас'), findsNothing);
    await tester.tap(find.byTooltip('Развернуть список'));
    await tester.pumpAndSettle();
    expect(find.text('Свободно сейчас'), findsOneWidget);
    expect(find.textContaining('по живому расписанию'), findsOneWidget);
    expect(find.byType(MapFreeRoomsPanel), findsOneWidget);
  });

  testWidgets('loading state mirrors the map composition with one pulse', (
    tester,
  ) async {
    await pumpMap(tester, initialize: false);

    expect(find.byType(MapSkeleton), findsOneWidget);
    expect(find.byType(NinjaSkeletonGroup), findsWidgets);
    expect(find.byType(NinjaSkeleton), findsWidgets);
    expect(find.byType(NinjaSpinner), findsNothing);
    expect(find.byType(SvgInteractiveMap), findsNothing);
  });

  testWidgets('failure state offers a retryable error screen', (tester) async {
    await pumpMap(tester, failure: true);

    expect(find.byType(NinjaErrorState), findsOneWidget);
    expect(find.text('Ошибка загрузки'), findsOneWidget);
    expect(find.byType(SvgInteractiveMap), findsNothing);

    await tester.tap(find.text('Повторить'));
    await tester.pump();

    verify(() => bloc.add(const MapEvent.initialized())).called(1);
  });

  testWidgets('keeps floor and map controls reachable in the compact state', (
    tester,
  ) async {
    await pumpMap(tester);

    expect(find.byTooltip('Приблизить карту'), findsOneWidget);
    expect(find.byTooltip('Отдалить карту'), findsOneWidget);
    expect(find.byTooltip('Показать весь этаж'), findsOneWidget);
    expect(
      tester.getSize(find.byTooltip('Приблизить карту')).height,
      greaterThanOrEqualTo(44),
    );

    await tester.tap(find.byTooltip('Приблизить карту'));
    await tester.pump();
    await tester.tap(find.byTooltip('Отдалить карту'));
    await tester.pump();
    await tester.tap(find.byTooltip('Показать весь этаж'));
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.tap(find.widgetWithText(AppChip, '1 этаж'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 этаж'));
    await tester.pump();

    verify(
      () => bloc.add(
        MapEvent.floorSelected(floor: secondFloor, campus: campuses.first),
      ),
    ).called(1);
  });

  testWidgets('volume preserves focus and projected room taps', (tester) async {
    final controller = SvgInteractiveMapController();
    addTearDown(controller.dispose);
    await pumpMap(tester, mapController: controller, reduceMotion: true);
    controller.focusPoints([const Offset(20, 20)]);
    await tester.pumpAndSettle();
    final scale = controller.currentScale;
    final originalCenter = tester
        .renderObject<RenderBox>(find.byType(MapFloorCanvas))
        .localToGlobal(const Offset(20, 20));
    await tester.tap(find.byTooltip('Объёмный план'));
    await tester.pumpAndSettle();
    expect(controller.currentScale, scale);
    final volume = tester.widget<MapVolumeLayer>(find.byType(MapVolumeLayer));
    final projection = MapVolumeProjection(
      viewportSize: volume.viewportSize,
      transform: volume.transform.value,
      pivot: volume.pivot,
      bearing: volume.bearing,
    );
    final canvas = tester.renderObject<RenderBox>(find.byType(MapVolumeLayer));
    final ground = projection.sceneToScreen(const Offset(20, 20));
    final projectedCenter = canvas.localToGlobal(ground);
    expect((projectedCenter - originalCenter).distance, lessThan(.1));
    expect(
      projection.sceneToScreen(const Offset(20, 20), height: 10).dy,
      lessThan(ground.dy),
    );
    await tester.tapAt(projectedCenter);
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    verify(() => bloc.add(const MapEvent.roomTapped('v78__r__101'))).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('volume rotation and panning preserve the selected scale', (
    tester,
  ) async {
    final controller = SvgInteractiveMapController();
    addTearDown(controller.dispose);
    await pumpMap(tester, mapController: controller, reduceMotion: true);
    await tester.tap(find.byTooltip('Объёмный план'));
    await tester.pumpAndSettle();
    final initial = tester.widget<MapVolumeLayer>(find.byType(MapVolumeLayer));
    final scale = controller.currentScale;
    await tester.tap(find.byTooltip('Повернуть план'));
    await tester.pumpAndSettle();
    final rotated = tester.widget<MapVolumeLayer>(find.byType(MapVolumeLayer));
    expect(rotated.bearing, greaterThan(initial.bearing));
    expect(controller.currentScale, scale);
    final before = rotated.transform.value.clone();
    final origin = tester
        .renderObject<RenderBox>(find.byType(MapVolumeLayer))
        .localToGlobal(rotated.pivot!);
    await tester.dragFrom(origin, const Offset(45, 30));
    await tester.pumpAndSettle();
    final after = rotated.transform.value;
    expect(after[12], isNot(before[12]));
    expect(controller.currentScale, scale);
    await tester.tap(find.byTooltip('Вид сверху'));
    await tester.pumpAndSettle();
    expect(find.byType(MapVolumeLayer), findsNothing);
    expect(controller.currentScale, scale);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rotated tall volume plans fit inside the visible viewport', (
    tester,
  ) async {
    final controller = SvgInteractiveMapController();
    addTearDown(controller.dispose);
    const bounds = Rect.fromLTWH(0, 0, 400, 4000);
    await pumpMap(
      tester,
      size: const Size(320, 844),
      bounds: bounds,
      mapController: controller,
      reduceMotion: true,
    );
    await tester.tap(find.byTooltip('Объёмный план'));
    await tester.pumpAndSettle();
    for (var rotation = 0; rotation < 2; rotation++) {
      await tester.tap(find.byTooltip('Повернуть план'));
      await tester.pumpAndSettle();
      controller.fit();
      await tester.pumpAndSettle();
      final volume = tester.widget<MapVolumeLayer>(find.byType(MapVolumeLayer));
      final wallHeight = math.min(
        bounds.shortestSide * .008,
        20 / controller.currentScale!,
      );
      _expectProjectedPointsVisible(tester, [
        bounds.topLeft,
        bounds.topRight,
        bounds.bottomLeft,
        bounds.bottomRight,
      ], height: wallHeight);
      expect(volume.bearing, closeTo(math.pi / 4 * (rotation + 1), .001));
    }
  });

  testWidgets('volume route and large room focus fit projected extents', (
    tester,
  ) async {
    final controller = SvgInteractiveMapController();
    addTearDown(controller.dispose);
    final room = RoomModel(
      roomId: 'long-room',
      name: 'Большой зал',
      path: Path()..addRect(const Rect.fromLTWH(100, 200, 200, 3600)),
    );
    await pumpMap(
      tester,
      size: const Size(320, 844),
      bounds: const Rect.fromLTWH(0, 0, 400, 4000),
      rooms: [room],
      mapController: controller,
      reduceMotion: true,
    );
    await tester.tap(find.byTooltip('Объёмный план'));
    await tester.pumpAndSettle();
    for (var rotation = 0; rotation < 2; rotation++) {
      await tester.tap(find.byTooltip('Повернуть план'));
      await tester.pumpAndSettle();
    }
    const route = [Offset(100, 200), Offset(300, 3800)];
    controller.focusPoints(route);
    await tester.pumpAndSettle();
    _expectProjectedPointsVisible(tester, route);
    controller.focusRoom(room);
    await tester.pumpAndSettle();
    final rect = room.path.getBounds();
    _expectProjectedPointsVisible(tester, [
      rect.topLeft,
      rect.topRight,
      rect.bottomLeft,
      rect.bottomRight,
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('panel resizing preserves an explored area and its zoom', (
    tester,
  ) async {
    final controller = SvgInteractiveMapController();
    addTearDown(controller.dispose);
    await pumpMap(tester, mapController: controller, reduceMotion: true);
    controller.zoomIn();
    await tester.pumpAndSettle();
    final scale = controller.currentScale;
    final viewer = tester.widget<InteractiveViewer>(
      find.byType(InteractiveViewer),
    );
    final map = tester.widget<SvgInteractiveMap>(
      find.byType(SvgInteractiveMap),
    );
    Offset visibleCenter() {
      final padding = map.viewportPaddingListenable!.value;
      return Offset(
        (390 + padding.left - padding.right) / 2,
        (844 + padding.top - padding.bottom) / 2,
      );
    }

    final center = viewer.transformationController!.toScene(visibleCenter());
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    sheet.controller!.jumpTo(.5);
    await tester.pumpAndSettle();
    expect(controller.currentScale, scale);
    expect(
      (viewer.transformationController!.toScene(visibleCenter()) - center)
          .distance,
      lessThan(.01),
    );
    sheet.controller!.jumpTo(sheet.minChildSize);
    await tester.pumpAndSettle();
    expect(controller.currentScale, scale);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tall plans fit between overlays on a short screen', (
    tester,
  ) async {
    final controller = _RecordingMapController();
    addTearDown(controller.dispose);
    await pumpMap(
      tester,
      size: const Size(320, 420),
      bounds: const Rect.fromLTWH(0, 0, 1600, 2400),
      reduceMotion: true,
      mapController: controller,
    );
    final map = tester.widget<SvgInteractiveMap>(
      find.byType(SvgInteractiveMap),
    );
    final padding = map.viewportPaddingListenable!.value;
    final viewer = tester.widget<InteractiveViewer>(
      find.byType(InteractiveViewer),
    );
    final matrix = viewer.transformationController!.value;
    expect(controller.currentScale, lessThan(.1));
    expect(matrix[13], greaterThanOrEqualTo(padding.top - .01));
    expect(
      matrix[13] + 2400 * controller.currentScale!,
      lessThanOrEqualTo(420 - padding.bottom + .01),
    );
    expect(
      matrix[12] + 1600 * controller.currentScale!,
      lessThanOrEqualTo(320 - padding.right + .01),
    );
    controller.zoomIn();
    await tester.pumpAndSettle();
    controller.fit();
    await tester.pumpAndSettle();
    expect(controller.currentScale, closeTo(matrix[0], .0001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('zoom and fit controls change the real map transform', (
    tester,
  ) async {
    final controller = _RecordingMapController();
    addTearDown(controller.dispose);
    await pumpMap(tester, mapController: controller);
    final fittedScale = controller.currentScale!;

    await tester.tap(find.byTooltip('Приблизить карту'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));
    expect(controller.zoomInCalls, 1);
    expect(controller.currentScale, greaterThan(fittedScale));

    await tester.tap(find.byTooltip('Показать весь этаж'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));
    expect(controller.currentScale, moreOrLessEquals(fittedScale));

    await tester.tap(find.byTooltip('Отдалить карту'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));
    expect(controller.currentScale, lessThan(fittedScale));

    await tester.tap(find.byTooltip('Приблизить карту'));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tap(find.byTooltip('Показать весь этаж'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));
    expect(controller.currentScale, moreOrLessEquals(fittedScale));
  });

  testWidgets('disables stale map interactions while another floor loads', (
    tester,
  ) async {
    final controller = _RecordingMapController();
    addTearDown(controller.dispose);
    await pumpMap(
      tester,
      mapController: controller,
      reloading: true,
    );

    await tester.tap(find.byTooltip('Приблизить карту'));
    await tester.pump();

    expect(find.byType(MapRoomFinder), findsNothing);
    expect(controller.zoomInCalls, 0);
  });

  testWidgets('new floor fit wins over an active zoom animation', (
    tester,
  ) async {
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
    final controller = _RecordingMapController();
    final states = StreamController<MapState>();
    addTearDown(controller.dispose);
    addTearDown(states.close);
    final firstState = MapState(
      status: .loaded,
      availableCampuses: campuses,
      selectedCampus: campuses.first,
      selectedFloor: firstFloor,
      boundingRect: const Rect.fromLTWH(0, 0, 600, 400),
    );
    final secondState = firstState.copyWith(
      selectedFloor: secondFloor,
      boundingRect: const Rect.fromLTWH(0, 0, 1200, 800),
    );
    whenListen(bloc, states.stream, initialState: firstState);
    await tester.pumpApp(
      provide(MapView(mapController: controller)),
      size: const Size(390, 844),
    );
    await tester.pump(const Duration(milliseconds: 400));
    final firstScale = controller.currentScale!;

    await tester.tap(find.byTooltip('Приблизить карту'));
    await tester.pump(const Duration(milliseconds: 80));
    states.add(secondState);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(controller.currentScale, lessThan(firstScale));
  });

  testWidgets('reattaches the interactive map when its controller changes', (
    tester,
  ) async {
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
    final first = SvgInteractiveMapController();
    final second = SvgInteractiveMapController();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    late StateSetter update;
    SvgInteractiveMapController? current = first;
    final state = MapState(
      status: .loaded,
      availableCampuses: campuses,
      selectedCampus: campuses.first,
      selectedFloor: firstFloor,
      boundingRect: const Rect.fromLTWH(0, 0, 600, 400),
    );
    when(() => bloc.state).thenReturn(state);
    await tester.pumpApp(
      provide(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MapView(mapController: current);
          },
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(first.currentScale, isNotNull);
    expect(second.currentScale, isNull);
    update(() => current = second);
    await tester.pump();

    expect(first.currentScale, isNull);
    expect(second.currentScale, isNotNull);
  });

  testWidgets('refits a mounted map when the viewport width changes', (
    tester,
  ) async {
    final controller = SvgInteractiveMapController();
    addTearDown(controller.dispose);
    await pumpMap(tester, mapController: controller);
    final phoneScale = controller.currentScale!;

    tester.view.physicalSize = const Size(520, 844);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(controller.currentScale, greaterThan(phoneScale));
  });

  testWidgets('room finder searches the current authored floor', (
    tester,
  ) async {
    await pumpMap(tester);
    await tester.pumpApp(
      Scaffold(body: MapRoomFinder(rooms: bloc.state.rooms)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppSearchField), findsOneWidget);
    expect(find.text('А-101'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Б');
    await tester.pumpAndSettle();

    expect(find.text('Б-205'), findsOneWidget);
    expect(find.text('А-101'), findsNothing);
  });

  testWidgets('room finder shows empty state and can clear the query', (
    tester,
  ) async {
    await pumpMap(tester);

    await tester.pumpApp(
      Scaffold(body: MapRoomFinder(rooms: bloc.state.rooms)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'ZZZ');
    await tester.pumpAndSettle();

    expect(find.byType(NinjaEmptyState), findsOneWidget);
    expect(find.text('На этом этаже ничего не найдено'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    expect(find.byType(NinjaEmptyState), findsNothing);
    expect(find.text('А-101'), findsOneWidget);
  });

  testWidgets('remains overflow-free at large text on a small phone', (
    tester,
  ) async {
    await pumpMap(
      tester,
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SvgInteractiveMap), findsOneWidget);
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    expect(find.byKey(const ValueKey('free-rooms-list')), findsNothing);
    await tester.ensureVisible(find.byTooltip('Развернуть список'));
    await tester.tap(find.byTooltip('Развернуть список'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('А-101'));
    expect(find.text('А-101').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded list scrolls without moving its header', (
    tester,
  ) async {
    when(() => freeRooms.state).thenReturn(
      FreeRoomsState(
        status: .populated,
        rooms: [
          for (var index = 101; index <= 116; index++)
            FreeRoom(room: 'А-$index', campus: 'В-78'),
        ],
      ),
    );
    await pumpMap(tester);
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    sheet.controller!.jumpTo(.78);
    await tester.pumpAndSettle();
    final title = find.text('Места');
    final headerPosition = tester.getTopLeft(title);
    final list = find.ancestor(
      of: find.byKey(const ValueKey('free-rooms-list')),
      matching: find.byType(SingleChildScrollView),
    );
    await tester.drag(list, const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(title), headerPosition);
    expect(find.text('А-116').hitTestable(), findsOneWidget);
    final listBottom = tester.getRect(list).bottom;
    final rowsBottom = tester
        .getRect(find.byKey(const ValueKey('free-rooms-list')))
        .bottom;
    expect(listBottom - rowsBottom, closeTo(AppSpacing.screen, .1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('removes control transitions when reduced motion is enabled', (
    tester,
  ) async {
    final controller = SvgInteractiveMapController();
    addTearDown(controller.dispose);
    await pumpMap(tester, reduceMotion: true, mapController: controller);
    final scale = controller.currentScale!;
    await tester.tap(find.byTooltip('Приблизить карту'));
    await tester.pump();
    expect(controller.currentScale, greaterThan(scale));
    await tester.tap(find.byTooltip('Развернуть список'));
    await tester.pump();
    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    expect(sheet.controller!.size, .78);
    expect(tester.takeException(), isNull);
  });

  testWidgets('map search keeps unnamed rooms reachable by authored id', (
    tester,
  ) async {
    when(() => freeRooms.state).thenReturn(
      const FreeRoomsState(
        status: FreeRoomsStatus.populated,
        query: 'unnamed',
      ),
    );
    await pumpMap(
      tester,
      rooms: [
        RoomModel(
          roomId: 'v78_unnamed_1',
          path: Path()..addRect(const Rect.fromLTWH(0, 0, 40, 40)),
        ),
      ],
    );
    expect(find.text('v78_unnamed_1'), findsOneWidget);
    await tester.ensureVisible(find.text('v78_unnamed_1'));
    await tester.tap(find.text('v78_unnamed_1'));
    await tester.pumpAndSettle();
    expect(find.byType(MapRoomSheet), findsOneWidget);
    expect(find.text('v78_unnamed_1'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}

void _expectProjectedPointsVisible(
  WidgetTester tester,
  List<Offset> points, {
  double height = 0,
}) {
  final map = tester.widget<SvgInteractiveMap>(find.byType(SvgInteractiveMap));
  final volume = tester.widget<MapVolumeLayer>(find.byType(MapVolumeLayer));
  final padding = map.viewportPaddingListenable!.value;
  final viewport = Rect.fromLTRB(
    padding.left,
    padding.top,
    volume.viewportSize.width - padding.right,
    volume.viewportSize.height - padding.bottom,
  );
  final projection = MapVolumeProjection(
    viewportSize: volume.viewportSize,
    transform: volume.transform.value,
    pivot: volume.pivot,
    bearing: volume.bearing,
  );
  for (final point in points) {
    for (final elevation in {0.0, height}) {
      final screen = projection.sceneToScreen(point, height: elevation);
      expect(
        screen.dx,
        inInclusiveRange(viewport.left - .1, viewport.right + .1),
      );
      expect(
        screen.dy,
        inInclusiveRange(viewport.top - .1, viewport.bottom + .1),
      );
    }
  }
}
