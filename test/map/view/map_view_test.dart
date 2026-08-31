import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/map/map.dart';

import '../../helpers/pump_app.dart';

class _MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

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

  setUp(() {
    bloc = _MockMapBloc();
    addTearDown(bloc.close);
  });

  Future<void> pumpMap(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    TextScaler textScaler = TextScaler.noScaling,
    SvgInteractiveMapController? mapController,
    bool initialize = true,
    bool failure = false,
    bool reduceMotion = false,
    bool reloading = false,
  }) async {
    final state = failure
        ? const MapState(status: .failure, errorMessage: 'boom')
        : initialize
        ? MapState(
            status: reloading ? .loading : .loaded,
            availableCampuses: campuses,
            selectedCampus: campuses.first,
            selectedFloor: firstFloor,
            rooms: [
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
          child: BlocProvider<MapBloc>.value(
            value: bloc,
            child: MapView(mapController: mapController),
          ),
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
    expect(find.byType(NinjaAppBar), findsNothing);
    expect(find.byType(Divider), findsNothing);
    expect(find.text('В-78'), findsWidgets);
    expect(find.text('Найти аудиторию'), findsOneWidget);
    expect(find.text('1 этаж'), findsWidgets);

    expect(find.byType(MapFloorSwitcher), findsOneWidget);
    expect(find.byType(CampusSelector), findsOneWidget);

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

    final search = tester.getRect(find.text('Найти аудиторию'));
    expect(search.center.dy, lessThan(size.height * .2));
  });

  testWidgets('paints the map chrome on the deep canvas without borders', (
    tester,
  ) async {
    await pumpMap(tester);

    final colors = tester.element(find.byType(MapView)).ninja;
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, colors.canvas);

    final decorations = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>();
    expect(decorations, isNotEmpty);
    expect(
      decorations.every(
        (decoration) =>
            decoration.border == null &&
            decoration.boxShadow == null &&
            decoration.gradient == null,
      ),
      isTrue,
    );
  });

  testWidgets('renders the level header as the single accentSoft card', (
    tester,
  ) async {
    await pumpMap(tester);

    final colors = tester.element(find.byType(MapView)).ninja;
    final accented = tester
        .widgetList<Container>(find.byType(Container))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .where((decoration) => decoration.color == colors.accentSoft);
    expect(accented, hasLength(1));
    expect(find.byType(MapPanelHeader), findsOneWidget);
  });

  testWidgets('loading state mirrors the map composition with one pulse', (
    tester,
  ) async {
    await pumpMap(tester, initialize: false);

    expect(find.byType(MapSkeleton), findsOneWidget);
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    expect(find.byType(NinjaSkeleton), findsNWidgets(7));
    expect(find.byType(NinjaSpinner), findsOneWidget);
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
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
    expect(find.text('Весь этаж'), findsOneWidget);

    final colors = tester.element(find.byType(MapView)).ninja;
    final circles = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(MapActionButton),
            matching: find.byType(Container),
          ),
        )
        .toList();
    expect(circles, hasLength(2));
    for (final circle in circles) {
      expect(circle.constraints?.maxWidth, NinjaMetrics.minTouchTarget);
      expect(
        (circle.decoration! as BoxDecoration).shape,
        BoxShape.circle,
      );
      expect((circle.decoration! as BoxDecoration).color, colors.surfaceAlt);
    }

    await tester.tap(find.byTooltip('Приблизить карту'));
    await tester.pump();
    await tester.tap(find.byTooltip('Отдалить карту'));
    await tester.pump();
    await tester.tap(find.byTooltip('Показать весь этаж'));
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('2'));
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

    await tester.tap(find.text('Найти аудиторию'));
    await tester.tap(find.byTooltip('Приблизить карту'));
    await tester.pump();

    expect(find.byType(MapRoomFinder), findsNothing);
    expect(controller.zoomInCalls, 0);
  });

  testWidgets('new floor fit wins over an active zoom animation', (
    tester,
  ) async {
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
      BlocProvider<MapBloc>.value(
        value: bloc,
        child: MapView(mapController: controller),
      ),
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
      BlocProvider<MapBloc>.value(
        value: bloc,
        child: StatefulBuilder(
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

  testWidgets('room finder searches the current floor with pill filters', (
    tester,
  ) async {
    await pumpMap(tester);

    await tester.tap(find.text('Найти аудиторию'));
    await tester.pumpAndSettle();

    expect(find.byType(NinjaInput), findsOneWidget);
    expect(find.text('А-101'), findsOneWidget);
    expect(find.text('v78__r__101'), findsOneWidget);
    expect(find.byType(NinjaChip), findsNWidgets(3));

    await tester.tap(find.widgetWithText(NinjaChip, 'Б'));
    await tester.pumpAndSettle();

    expect(find.text('Б-205'), findsOneWidget);
    expect(find.text('А-101'), findsNothing);
  });

  testWidgets('room finder shows an empty state with a reset pill', (
    tester,
  ) async {
    await pumpMap(tester);

    await tester.tap(find.text('Найти аудиторию'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(NinjaInput), 'ZZZ');
    await tester.pumpAndSettle();

    expect(find.byType(NinjaEmptyState), findsOneWidget);
    expect(find.text('На этом этаже ничего не найдено'), findsOneWidget);

    await tester.tap(find.widgetWithText(NinjaChip, 'Очистить'));
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
  });

  testWidgets('removes control transitions when reduced motion is enabled', (
    tester,
  ) async {
    await pumpMap(tester, reduceMotion: true);

    final transitions = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .toList();
    expect(transitions, isNotEmpty);
    expect(
      transitions.every((widget) => widget.duration == Duration.zero),
      isTrue,
    );

    await tester.tap(find.text('В-78').first);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
