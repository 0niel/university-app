@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/map.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';

import 'gallery_fonts.dart';

class _Map extends MockBloc<MapEvent, MapState> implements MapBloc {}

class _FreeRooms extends MockCubit<FreeRoomsState> implements FreeRoomsCubit {}

void main() {
  late MapState mapState;
  setUpAll(() async {
    await loadGalleryFonts();
    final campus = CampusesConfig.campuses.first;
    final floor = campus.floors.firstWhere((floor) => floor.number == 3);
    final objects = ObjectsService();
    await objects.loadObjects();
    final (parsed, bounds) = await const SvgRoomParser().parseSvg(
      floor.svgPath,
    );
    final rooms = [
      for (final room in parsed)
        room.copyWith(
          name:
              objects.getNameById(
                room.roomId.split('__r__').elementAtOrNull(1) ?? '',
              ) ??
              '',
        ),
    ];
    mapState = MapState(
      status: .loaded,
      availableCampuses: CampusesConfig.campuses,
      selectedCampus: campus,
      selectedFloor: floor,
      rooms: rooms,
      roomFloors: {
        for (final room in rooms)
          if (room.name.isNotEmpty) roomKey(room.name): floor.number,
      },
      boundingRect: bounds,
    );
  });

  Widget app(
    Widget child, {
    required bool dark,
    TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: child,
  );

  for (final dark in [false, true]) {
    for (final largeText in [false, true]) {
      testWidgets(
        'actual map at 390x844 ${dark ? 'dark' : 'light'}'
        '${largeText ? ' large text' : ''}',
        (
          tester,
        ) async {
          tester.view
            ..physicalSize = const Size(390, 844)
            ..devicePixelRatio = 1;
          if (largeText) {
            tester.view
              ..padding = const FakeViewPadding(bottom: 34)
              ..viewPadding = const FakeViewPadding(bottom: 34);
          }
          addTearDown(tester.view.reset);
          final map = _Map();
          final free = _FreeRooms();
          when(() => map.state).thenReturn(mapState);
          when(() => free.state).thenReturn(
            FreeRoomsState(
              status: .populated,
              campus: 'В-78',
              rooms: [
                for (final room
                    in mapState.rooms
                        .where((room) => room.name.isNotEmpty)
                        .take(7))
                  FreeRoom(room: room.name, campus: 'В-78'),
              ],
            ),
          );
          addTearDown(map.close);
          addTearDown(free.close);
          await tester.pumpWidget(
            app(
              MultiBlocProvider(
                providers: [
                  BlocProvider<MapBloc>.value(value: map),
                  BlocProvider<FreeRoomsCubit>.value(value: free),
                ],
                child: Builder(
                  builder: (context) => Scaffold(
                    extendBody: true,
                    body: AppBottomBarViewport(
                      bottomInset: AppBottomBar.extentOf(context),
                      child: const MapView(),
                    ),
                    bottomNavigationBar: AppBottomNavigationBar(
                      currentIndex: 2,
                      onSelected: (_) {},
                    ),
                  ),
                ),
              ),
              dark: dark,
              textScaler: largeText
                  ? const TextScaler.linear(2)
                  : TextScaler.noScaling,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (!largeText) {
            expect(
              tester.getRect(find.byType(AppSearchField)),
              const Rect.fromLTWH(20, 56, 350, 50),
            );
          }
          final listViewport = find.byKey(const ValueKey('map-panel-scroll'));
          final navigation = tester.getRect(
            find.byType(AppBottomNavigationBar),
          );
          final panel = tester.widget<MapFreeRoomsPanel>(
            find.byType(MapFreeRoomsPanel),
          );
          final sheet = tester.widget<DraggableScrollableSheet>(
            find.byType(DraggableScrollableSheet),
          );
          expect(navigation.height, largeText ? 148 : 102);
          expect(panel.bottomInset, navigation.height);
          expect(tester.getRect(listViewport).bottom, navigation.top);
          expect(sheet.initialChildSize, lessThanOrEqualTo(.42));
          if (!largeText) {
            expect(sheet.initialChildSize, lessThan(.4));
          }
          expect(sheet.controller!.size, sheet.minChildSize);
          expect(find.byKey(const ValueKey('free-rooms-list')), findsNothing);
          final goldenName =
              'map${largeText ? '_large_text' : ''}_${dark ? 'dark' : 'light'}';
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/$goldenName.png'),
          );
          await tester.ensureVisible(find.byTooltip('Развернуть список'));
          await tester.tap(find.byTooltip('Развернуть список'));
          await tester.pumpAndSettle();
          expect(sheet.controller!.size, sheet.maxChildSize);
          expect(find.byType(MapCanvasControls), findsNothing);
          expect(tester.getRect(listViewport).bottom, navigation.top);
          expect(
            tester
                .widget<SingleChildScrollView>(listViewport)
                .controller!
                .offset,
            0,
          );
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/${goldenName}_expanded.png'),
          );
          final scrollBounds = tester.getRect(listViewport);
          await tester.dragFrom(
            Offset(
              scrollBounds.center.dx,
              scrollBounds.bottom - AppSpacing.screen,
            ),
            const Offset(0, -1600),
          );
          await tester.pumpAndSettle();
          final roomsBottom = tester
              .getRect(find.byKey(const ValueKey('free-rooms-list')))
              .bottom;
          expect(navigation.top - roomsBottom, closeTo(AppSpacing.screen, .1));
          await tester.ensureVisible(find.byTooltip('Свернуть список'));
          await tester.tap(find.byTooltip('Свернуть список'));
          await tester.pumpAndSettle();
          expect(sheet.controller!.size, sheet.minChildSize);
          expect(find.byType(MapCanvasControls), findsOneWidget);
          expect(
            tester
                .widget<SingleChildScrollView>(listViewport)
                .controller!
                .offset,
            0,
          );
          expect(find.byKey(const ValueKey('free-rooms-list')), findsNothing);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
        },
      );
    }
  }
}
