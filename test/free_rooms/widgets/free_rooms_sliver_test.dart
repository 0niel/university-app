import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_row.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_rooms_list.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Widget _subject(int count, {ValueChanged<String>? onSelected}) {
  final rooms = [
    for (var index = 0; index < count; index++)
      FreeRoom(room: 'Room-$index', campus: 'mp1'),
  ];
  return MaterialApp(
    theme: NinjaTheme.dark(),
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: CustomScrollView(
        slivers: [
          FreeRoomsList.sliver(
            state: FreeRoomsState(
              status: FreeRoomsStatus.populated,
              rooms: rooms,
            ),
            onRetry: () {},
            onRoomTap: (room) => onSelected?.call(room.name),
          ),
        ],
      ),
    ),
  );
}

void main() {
  testWidgets('builds only viewport rows from a thousand available rooms', (
    tester,
  ) async {
    await tester.pumpWidget(_subject(1000));
    await tester.pumpAndSettle();
    expect(find.text('Room-0'), findsOneWidget);
    expect(find.text('Room-999'), findsNothing);
    expect(find.byType(FreeRoomRow).evaluate().length, lessThan(30));
    expect(tester.takeException(), isNull);
  });

  testWidgets('lazy rows remain scrollable and tappable at the end', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      _subject(300, onSelected: (room) => selected = room),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Room-299'),
      4000,
      maxScrolls: 15,
    );
    await tester.pumpAndSettle();
    expect(find.text('Room-299'), findsOneWidget);
    expect(find.text('Room-0'), findsNothing);
    expect(find.byType(FreeRoomRow).evaluate().length, lessThan(30));
    await tester.tap(find.text('Room-299'));
    expect(selected, 'Room-299');
    expect(tester.takeException(), isNull);
  });
}
