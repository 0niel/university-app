import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/view/map_view.dart';
import 'package:rtu_mirea_app/map/widgets/map_canvas_controls.dart';
import 'package:rtu_mirea_app/map/widgets/map_free_rooms_panel.dart';
import 'package:rtu_mirea_app/map/widgets/map_top_bar.dart';

import '../../helpers/pump_app.dart';

class _MapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class _FreeRooms extends MockCubit<FreeRoomsState> implements FreeRoomsCubit {}

Future<_FreeRooms> _pump(
  WidgetTester tester, {
  bool glass = true,
  double textScale = 1,
}) async {
  final map = _MapBloc();
  final free = _FreeRooms();
  const floor = FloorModel(id: 'one', number: 1, svgPath: 'floor.svg');
  const campus = CampusModel(
    id: 'campus',
    displayName: 'В-78',
    floors: [floor],
  );
  when(() => map.state).thenReturn(
    const MapState(
      status: MapStatus.loaded,
      selectedCampus: campus,
      selectedFloor: floor,
      availableCampuses: [campus],
      boundingRect: Rect.fromLTWH(0, 0, 200, 100),
      svgContent:
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 100"> '
          '<rect width="200" height="100" fill="#f07030"/></svg>',
    ),
  );
  when(
    () => free.state,
  ).thenReturn(const FreeRoomsState(status: FreeRoomsStatus.populated));
  when(free.load).thenAnswer((_) async {});
  addTearDown(map.close);
  addTearDown(free.close);
  addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
  await tester.pumpApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>.value(value: map),
        BlocProvider<FreeRoomsCubit>.value(value: free),
      ],
      child: Theme(
        data: AppTheme.generateTheme(
          AppColors.light,
          Brightness.light,
          glassEnabled: glass,
        ),
        child: const MapView(),
      ),
    ),
    size: const Size(390, 844),
    textScaler: TextScaler.linear(textScale),
  );
  await tester.pumpAndSettle();
  return free;
}

Finder _lenses(Finder widget) =>
    find.descendant(of: widget, matching: find.byType(LiquidGlassLens));
int? _id(Element lens) => LiquidGlassBatch.backdropIdOf(lens);
Rect _bounds(WidgetTester tester, Iterable<Element> lenses) => lenses
    .map((element) => tester.getRect(find.byWidget(element.widget)))
    .reduce((a, b) => a.expandToInclude(b));

void main() {
  for (final scale in [1.0, 2.0]) {
    for (final is3D in [false, true]) {
      testWidgets(
        'map capture geometry survives portrait/landscape at $scale text, 3D=$is3D',
        (tester) async {
          await _pump(tester, textScale: scale);
          if (is3D) {
            await tester.tap(find.byTooltip('Объёмный план'));
            await tester.pumpAndSettle();
          }
          var sawShared = false;
          var sawIsolated = false;
          for (final size in [
            const Size(320, 700),
            const Size(844, 390),
            const Size(844, 420),
            const Size(844, 600),
            const Size(390, 844),
          ]) {
            tester.view.physicalSize = size;
            await tester.pumpAndSettle();
            await tester.pump(const Duration(milliseconds: 120));
            final top = _lenses(find.byType(MapTopBar)).evaluate().toList();
            final canvas = _lenses(
              find.byType(MapCanvasControls),
            ).evaluate().toList();
            expect(top, hasLength(3));
            expect(canvas, isNotEmpty);
            final topId = _id(top.first);
            expect(topId, isNotNull);
            expect(top.map(_id).toSet(), {topId});
            expect(canvas.map(_id).toSet(), hasLength(1));
            final shares = _id(canvas.first) == topId;
            if (shares) {
              sawShared = true;
              final gap =
                  _bounds(tester, canvas).top - _bounds(tester, top).bottom;
              expect(gap, greaterThanOrEqualTo(60));
              final peers = [...top, ...canvas];
              for (var i = 0; i < peers.length; i++) {
                for (var j = i + 1; j < peers.length; j++) {
                  expect(
                    tester
                        .getRect(find.byWidget(peers[i].widget))
                        .overlaps(
                          tester.getRect(find.byWidget(peers[j].widget)),
                        ),
                    isFalse,
                  );
                }
              }
            } else {
              sawIsolated = true;
            }
            final more = find.byTooltip('Действия с картой');
            final moreLens = _lenses(more).evaluate();
            expect(moreLens, hasLength(1));
            expect(_id(moreLens.single), isNot(topId));
            expect(tester.takeException(), isNull);
          }
          expect(sawShared, isTrue);
          if (is3D || scale == 2) expect(sawIsolated, isTrue);
        },
      );
    }
  }

  testWidgets(
    'shared canvas keeps search and sheets isolated with real actions',
    (tester) async {
      final free = await _pump(tester);
      final top = find.byType(MapTopBar);
      final l10n = tester.element(top).l10n;
      final shared = _id(_lenses(top).evaluate().first);
      expect(
        _lenses(find.byType(MapCanvasControls)).evaluate().map(_id).toSet(),
        {shared},
      );
      await tester.tap(find.byTooltip(l10n.mapSearchPlaceholder));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      final search = _lenses(find.byType(AppSearchField));
      expect(search, findsOneWidget);
      final searchId = _id(tester.element(search));
      expect(searchId, isNotNull);
      expect(searchId, isNot(shared));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus,
        isTrue,
      );
      await tester.enterText(find.byType(TextField), '101');
      verify(() => free.queryChanged('101')).called(1);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
      await tester.tap(find.text('В-78').first);
      await tester.pumpAndSettle();
      expect(find.byType(AppSheet), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byType(AppSheet),
          matching: find.byType(AppGlassBatch),
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('disabled glass keeps map controls actionable without lenses', (
    tester,
  ) async {
    await _pump(tester, glass: false);
    expect(find.byType(LiquidGlassLens), findsNothing);
    for (final label in [
      'Приблизить карту',
      'Отдалить карту',
      'Показать весь этаж',
    ]) {
      await tester.tap(find.byTooltip(label));
      await tester.pumpAndSettle();
    }
    expect(find.byType(MapFreeRoomsPanel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
