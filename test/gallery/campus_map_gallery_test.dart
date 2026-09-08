@Tags(['gallery'])
library;

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/view/map_view.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_details_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_editor_page.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_share_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';

import 'gallery_fonts.dart';

class _Map extends MockBloc<MapEvent, MapState> implements MapBloc {}

class _Free extends MockCubit<FreeRoomsState> implements FreeRoomsCubit {}

class _Photos extends Mock implements CampusRepository {}

class _Cache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;
  @override
  Future<void> write(String key, String value) async {}
}

void main() {
  setUpAll(() async {
    await loadGalleryFonts();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  for (final id in ['v-78', 'v-86', 's-20', 'mp-1']) {
    for (final dark in [false, true]) {
      testWidgets('Pulse $id ${dark ? 'dark' : 'light'}', (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final textScale = ValueNotifier<TextScaler>(TextScaler.noScaling);
        addTearDown(textScale.dispose);
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _Cache(),
          bundledCatalogAsset: MapDataRepository.pulseCatalogAsset,
          rpc: (_, _) async => throw const MapDataException('offline'),
        );
        final catalog = (await tester.runAsync(repository.loadCatalog))!;
        final campus = (await tester.runAsync(
          () => repository.loadCampus(id),
        ))!;
        final floor = campus.floors
            .firstWhere((f) => f.floor.number == 1)
            .floor;
        final svg = await repository.loadSvg(floor.svgPath);
        final (rooms, bounds) = await SvgRoomParser(
          onLoadSvg: repository.loadSvg,
        ).parseSvg(floor.svgPath);
        final state = MapState(
          status: .loaded,
          availableCampuses: catalog.entries.map((e) => e.campus).toList(),
          selectedCampus: campus.campus,
          selectedFloor: floor,
          campusData: campus,
          boundingRect: bounds,
          svgContent: svg,
          rooms: [
            for (final room in rooms)
              room.copyWith(name: campus.placeForId(room.roomId)?.label ?? ''),
          ],
          dataWarning: campus.warning,
        );
        final map = _Map();
        final free = _Free();
        final photos = _Photos();
        when(
          () => photos.getRoomPhotos(
            campus: any(named: 'campus'),
            roomKey: any(named: 'roomKey'),
          ),
        ).thenAnswer((_) async => const []);
        when(() => map.state).thenReturn(state);
        when(() => map.repository).thenReturn(repository);
        when(() => map.syntheticRoomIds).thenReturn(const {});
        when(
          () => free.state,
        ).thenReturn(const FreeRoomsState(status: .populated));
        addTearDown(() async {
          await tester.pumpWidget(const SizedBox.shrink());
          await map.close();
          await free.close();
          repository.dispose();
        });
        const boundaryKey = ValueKey('campus-map-preview');
        await tester.pumpWidget(
          RepaintBoundary(
            key: boundaryKey,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => ValueListenableBuilder<TextScaler>(
                valueListenable: textScale,
                builder: (context, scale, _) =>
                    RepositoryProvider<CampusRepository>.value(
                      value: photos,
                      child: MediaQuery(
                        data: MediaQuery.of(
                          context,
                        ).copyWith(textScaler: scale),
                        child: child!,
                      ),
                    ),
              ),
              home: MultiBlocProvider(
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
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();
        if (id != 'mp-1') {
          final preparation = Stopwatch()..start();
          while (tester
              .widget<MapCartographicLayer>(find.byType(MapCartographicLayer))
              .navigationLandmarks
              .isEmpty) {
            if (preparation.elapsed > const Duration(seconds: 10)) {
              fail('Navigation landmarks did not finish preparing for $id');
            }
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 20)),
            );
            await tester.pump();
          }
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
        Future<void> capture(String suffix) async {
          if (!const bool.fromEnvironment('MAP_PREVIEWS')) return;
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(boundaryKey),
          );
          await tester.runAsync(() async {
            final image = await boundary.toImage(pixelRatio: 2);
            final png = await image.toByteData(format: ui.ImageByteFormat.png);
            image.dispose();
            final directory = Directory('output/campus-map/previews');
            await directory.create(recursive: true);
            await File(
              '${directory.path}/$id-${dark ? 'dark' : 'light'}'
              '-$suffix.png',
            ).writeAsBytes(png!.buffer.asUint8List());
          });
        }

        Future<void> toggleVolume(String title) async {
          final control = find.byTooltip(title);
          if (control.evaluate().isNotEmpty) {
            await tester.tap(control);
          } else {
            await tester.tap(find.byTooltip('Действия с картой'));
            await tester.pumpAndSettle();
            final action = find.widgetWithText(AppListRow, title);
            await tester.ensureVisible(action);
            await tester.pumpAndSettle();
            await tester.tap(action);
          }
          await tester.pumpAndSettle();
        }

        await capture('map');
        for (var step = 0; step < 4; step++) {
          await tester.tap(find.byTooltip('Приблизить карту'));
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
        await capture('zoom');
        await toggleVolume('Объёмный план');
        expect(find.byTooltip('Вид сверху'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await capture('volume');
        await toggleVolume('Вид сверху');
        tester.view.physicalSize = const Size(320, 568);
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await capture('compact');
        await toggleVolume('Объёмный план');
        expect(tester.takeException(), isNull);
        await capture('compact-volume');
        await toggleVolume('Вид сверху');
        textScale.value = const TextScaler.linear(2);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await capture('compact-large-text');
        textScale.value = TextScaler.noScaling;
        tester.view.physicalSize = const Size(320, 420);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await capture('short');
        await toggleVolume('Объёмный план');
        expect(tester.takeException(), isNull);
        await capture('short-volume');
        await toggleVolume('Вид сверху');
        tester.view.physicalSize = const Size(390, 844);
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Развернуть список'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await capture('places');
        if (id == 'v-86' || id == 'mp-1') {
          final firstPlace = find
              .descendant(
                of: find.byType(MapPlacesExplorer),
                matching: find.byType(AppListRow),
              )
              .first;
          await tester.tap(firstPlace);
          await tester.pumpAndSettle();
          expect(find.byType(MapPlaceDetailsSheet), findsOneWidget);
          expect(tester.takeException(), isNull);
          await capture('place');
          final photoHeader = find.widgetWithText(
            AppListRow,
            'Фотографии места',
          );
          Future<void> showPhotos() async {
            await tester.ensureVisible(photoHeader);
            await tester.pumpAndSettle();
            await tester.tap(photoHeader);
            await tester.pumpAndSettle();
            await Scrollable.ensureVisible(
              tester.element(photoHeader),
            );
            await tester.pumpAndSettle();
          }

          Future<void> closePhotos() async {
            await tester.ensureVisible(photoHeader);
            await tester.pumpAndSettle();
            await tester.tap(photoHeader);
            await tester.pumpAndSettle();
            Scrollable.of(tester.element(photoHeader)).position.jumpTo(0);
            await tester.pumpAndSettle();
          }

          await showPhotos();
          expect(tester.takeException(), isNull);
          await capture('place-photos');
          await closePhotos();
          tester.view.physicalSize = const Size(320, 568);
          textScale.value = const TextScaler.linear(2);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await capture('place-large-text');
          await showPhotos();
          expect(tester.takeException(), isNull);
          await capture('place-photos-large-text');
          await tester.ensureVisible(find.text('Добавить фото'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Добавить фото'));
          await tester.pumpAndSettle();
          expect(find.text('Камера'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await capture('place-photo-sources-large-text');
          Navigator.of(
            tester.element(find.text('Камера')),
            rootNavigator: true,
          ).pop();
          await tester.pumpAndSettle();
          await closePhotos();
          await tester.ensureVisible(find.byTooltip('Поделиться · QR-код'));
          await tester.tap(find.byTooltip('Поделиться · QR-код'));
          await tester.pumpAndSettle();
          expect(find.byType(MapPlaceShareSheet), findsOneWidget);
          expect(tester.takeException(), isNull);
          await capture('place-share-large-text');
          await tester.ensureVisible(
            find.widgetWithText(AppButton, 'Копировать'),
          );
          await tester.pumpAndSettle();
          for (final label in ['Поделиться', 'Копировать']) {
            expect(
              tester
                  .renderObject<RenderParagraph>(find.text(label))
                  .didExceedMaxLines,
              isFalse,
            );
          }
          await capture('place-share-actions-large-text');
          Navigator.of(
            tester.element(find.byType(MapPlaceShareSheet)),
            rootNavigator: true,
          ).pop();
          await tester.pumpAndSettle();
          final correction = find.widgetWithText(
            AppListRow,
            'Предложить исправление',
          );
          await tester.ensureVisible(correction);
          await tester.pumpAndSettle();
          await tester.tap(correction);
          await tester.pumpAndSettle();
          expect(find.text('Сведения о месте'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await capture('place-correction-large-text');
          final navigator = Navigator.of(
            tester.element(find.byType(MapPlaceDetailsSheet)),
            rootNavigator: true,
          )..popUntil((route) => route.isFirst);
          await tester.pumpAndSettle();
          textScale.value = TextScaler.noScaling;
          tester.view.physicalSize = const Size(390, 844);
          unawaited(
            navigator.push<void>(
              MaterialPageRoute(
                builder: (_) => MapPlaceEditorPage(
                  campus: campus,
                  repository: repository,
                  initialFloorId: floor.id,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await capture('place-editor');
          tester.view.physicalSize = const Size(320, 568);
          textScale.value = const TextScaler.linear(2);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await capture('place-editor-large-text');
          final category = find.widgetWithText(AppListRow, 'Столовая');
          await tester.scrollUntilVisible(
            category,
            200,
            scrollable: find
                .descendant(
                  of: find.byType(MapPlaceEditorPage),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
          await tester.pumpAndSettle();
          await tester.tap(category);
          await tester.pumpAndSettle();
          expect(find.text('Категория').last, findsOneWidget);
          expect(tester.takeException(), isNull);
          await capture('place-editor-category-large-text');
        }
      });
    }
  }
}
