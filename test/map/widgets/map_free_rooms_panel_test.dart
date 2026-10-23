import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_row.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_rooms_list.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/widgets/map_free_rooms_panel.dart';
import 'package:rtu_mirea_app/map/widgets/map_panel_expand_button.dart';

import '../../helpers/pump_app.dart';

class _Rooms extends MockCubit<FreeRoomsState> implements FreeRoomsCubit {}

void main() {
  testWidgets('free room repaint isolation stays row sized and interactive', (
    tester,
  ) async {
    String? opened;
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: FreeRoomsList(
            state: FreeRoomsState(
              status: FreeRoomsStatus.populated,
              rooms: [for (var n = 1; n <= 40; n++) FreeRoom(room: '$n')],
            ),
            onRetry: () {},
            onRoomTap: (room) => opened = room.name,
          ),
        ),
      ),
    );
    final rows = find.byType(FreeRoomRow);
    expect(rows, findsNWidgets(40));
    for (final element in rows.evaluate()) {
      final boundary = element.findAncestorWidgetOfExactType<RepaintBoundary>();
      expect(boundary?.child, same(element.widget));
      expect(element.size!.height, lessThan(200));
    }
    await tester.tap(rows.first);
    expect(opened, contains('1'));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'reopening excludes rooms that expired while the panel was hidden',
    (
      tester,
    ) async {
      final expiresAt = DateTime.now().add(const Duration(seconds: 3));
      final rooms = _Rooms();
      final state = FreeRoomsState(
        status: FreeRoomsStatus.populated,
        rooms: [FreeRoom(room: '101', freeUntil: expiresAt)],
      );
      when(() => rooms.state).thenReturn(state);
      final controller = DraggableScrollableController();
      addTearDown(controller.dispose);
      var discoveryMounts = 0;
      await tester.pumpApp(
        BlocProvider<FreeRoomsCubit>.value(
          value: rooms,
          child: Scaffold(
            body: MapFreeRoomsPanel(
              controller: controller,
              collapsedSize: .3,
              viewportHeight: 900,
              bottomInset: 104,
              compactContentExtent: 100,
              mapState: const MapState(),
              onRoomTap: (_) {},
              onFloor: (_) {},
              onToggle: () {},
              onMappedRoomTap: (_) {},
              discovery: _DiscoveryProbe(onMount: () => discoveryMounts++),
            ),
          ),
        ),
        size: const Size(320, 900),
      );
      controller.jumpTo(.78);
      await tester.pumpAndSettle();
      expect(find.byType(FreeRoomRow), findsOneWidget);
      final list = tester.element(find.byType(FreeRoomsList));
      final discovery = tester.element(find.byType(_DiscoveryProbe));
      controller.jumpTo(.3);
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final remaining = expiresAt.difference(DateTime.now());
        if (!remaining.isNegative) {
          await Future<void>.delayed(
            remaining + const Duration(milliseconds: 20),
          );
        }
      });
      controller.jumpTo(.78);
      await tester.pumpAndSettle();
      expect(DateTime.now().isAfter(expiresAt), isTrue);
      expect(find.byType(FreeRoomRow), findsNothing);
      expect(find.byKey(const ValueKey('free-rooms-empty')), findsOneWidget);
      expect(tester.element(find.byType(FreeRoomsList)), same(list));
      expect(tester.element(find.byType(_DiscoveryProbe)), same(discovery));
      expect(discoveryMounts, 1);
      expect(rooms.state, same(state));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets('discovery rail reaches panel edges at ${scale * 100}% text', (
      tester,
    ) async {
      final rooms = _Rooms();
      when(
        () => rooms.state,
      ).thenReturn(const FreeRoomsState(status: FreeRoomsStatus.populated));
      final controller = DraggableScrollableController();
      addTearDown(controller.dispose);
      await tester.pumpApp(
        BlocProvider<FreeRoomsCubit>.value(
          value: rooms,
          child: Scaffold(
            body: Stack(
              children: [
                MapFreeRoomsPanel(
                  controller: controller,
                  collapsedSize: .3,
                  viewportHeight: 900,
                  bottomInset: 104,
                  compactContentExtent: 100,
                  mapState: const MapState(),
                  onRoomTap: (_) {},
                  onFloor: (_) {},
                  onToggle: () {},
                  onMappedRoomTap: (_) {},
                  discovery: AppChipRow<int>(
                    key: const ValueKey('discovery-categories'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen,
                    ),
                    items: [
                      for (var i = 0; i < 6; i++)
                        AppChipRowItem(value: i, label: 'Category $i'),
                    ],
                    value: 0,
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
          ),
        ),
        size: const Size(320, 900),
        textScaler: TextScaler.linear(scale),
      );
      controller.jumpTo(.78);
      await tester.pumpAndSettle();
      final rail = find.byKey(const ValueKey('discovery-categories'));
      final viewport = tester.getRect(rail);
      expect(viewport.left, 0);
      expect(viewport.right, 320);
      expect(
        tester
            .getRect(
              find.descendant(of: rail, matching: find.byType(AppChip)).first,
            )
            .left,
        AppSpacing.screen,
      );
      final scroll = tester.state<ScrollableState>(
        find.descendant(of: rail, matching: find.byType(Scrollable)),
      );
      await tester.dragFrom(
        Offset(318, viewport.center.dy),
        const Offset(-220, 0),
      );
      await tester.pumpAndSettle();
      expect(scroll.position.pixels, greaterThan(0));
      final previous = scroll.position.pixels;
      await tester.dragFrom(
        Offset(2, viewport.center.dy),
        const Offset(220, 0),
      );
      await tester.pumpAndSettle();
      expect(scroll.position.pixels, lessThan(previous));
      expect(tester.getRect(rail).bottom, lessThanOrEqualTo(900 - 104));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'extent changes reuse header and discovery at ${scale * 100}%',
      (
        tester,
      ) async {
        final rooms = _Rooms();
        when(() => rooms.state).thenReturn(
          const FreeRoomsState(status: FreeRoomsStatus.populated),
        );
        final controller = DraggableScrollableController();
        addTearDown(controller.dispose);
        var mounts = 0;
        var toggles = 0;
        await tester.pumpApp(
          BlocProvider<FreeRoomsCubit>.value(
            value: rooms,
            child: Scaffold(
              body: MapFreeRoomsPanel(
                controller: controller,
                collapsedSize: .3,
                viewportHeight: 900,
                bottomInset: 104,
                compactContentExtent: 100,
                mapState: const MapState(),
                onRoomTap: (_) {},
                onFloor: (_) {},
                onToggle: () => toggles++,
                onMappedRoomTap: (_) {},
                discovery: _DiscoveryProbe(onMount: () => mounts++),
              ),
            ),
          ),
          size: const Size(320, 900),
          textScaler: TextScaler.linear(scale),
        );
        expect(find.text('persistent discovery'), findsNothing);
        controller.jumpTo(.5);
        await tester.pumpAndSettle();
        final discovery = tester.element(find.byType(_DiscoveryProbe));
        final title = tester.widget<Text>(find.text('Места'));
        final expand = tester.widget<AppIconButton>(
          find.descendant(
            of: find.byType(MapPanelExpandButton),
            matching: find.byType(AppIconButton),
          ),
        );
        for (final extent in [.52, .56, .62, .70]) {
          controller.jumpTo(extent);
          await tester.pump();
          expect(tester.widget<Text>(find.text('Места')), same(title));
          expect(
            tester.widget<AppIconButton>(
              find.descendant(
                of: find.byType(MapPanelExpandButton),
                matching: find.byType(AppIconButton),
              ),
            ),
            same(expand),
          );
          expect(tester.element(find.byType(_DiscoveryProbe)), same(discovery));
        }
        controller.jumpTo(.3);
        await tester.pumpAndSettle();
        expect(find.text('persistent discovery'), findsNothing);
        final hidden = find.byType(_DiscoveryProbe, skipOffstage: false);
        expect(TickerMode.valuesOf(tester.element(hidden)).enabled, isFalse);
        expect(
          Focus.of(tester.element(hidden)).descendantsAreFocusable,
          isFalse,
        );
        controller.jumpTo(.78);
        await tester.pumpAndSettle();
        expect(tester.element(find.byType(_DiscoveryProbe)), same(discovery));
        expect(mounts, 1);
        await tester.tap(find.byType(MapPanelExpandButton));
        expect(toggles, 1);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}

class _DiscoveryProbe extends StatefulWidget {
  const _DiscoveryProbe({required this.onMount});

  final VoidCallback onMount;

  @override
  State<_DiscoveryProbe> createState() => _DiscoveryProbeState();
}

class _DiscoveryProbeState extends State<_DiscoveryProbe> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 700,
    child: Text('persistent discovery'),
  );
}
