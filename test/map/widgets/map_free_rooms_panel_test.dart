import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/widgets/map_free_rooms_panel.dart';

import '../../helpers/pump_app.dart';

class _Rooms extends MockCubit<FreeRoomsState> implements FreeRoomsCubit {}

void main() {
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
}
