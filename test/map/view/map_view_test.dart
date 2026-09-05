import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/map/map.dart';

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
    List<RoomModel>? rooms,
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
            boundingRect: const Rect.fromLTWH(0, 0, 600, 400),
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
    expect(map.viewportPadding.bottom, greaterThan(120));
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
      closeTo(844 * .78 + 12, .1),
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
      tester.getCenter(find.text('Свободно сейчас')),
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
    await tester.drag(find.text('Свободно сейчас'), const Offset(0, 420));
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

    await tester.tap(find.text('2 этаж'));
    await tester.pump();

    verify(
      () => bloc.add(
        MapEvent.floorSelected(floor: secondFloor, campus: campuses.first),
      ),
    ).called(1);
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
    final title = find.text('Свободно сейчас');
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
