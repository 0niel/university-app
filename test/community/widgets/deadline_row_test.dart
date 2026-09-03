import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_row.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/pump_app.dart';

void main() {
  Deadline deadline({bool isDone = false}) => Deadline(
    id: 'one',
    title: 'Отчёт',
    subjectName: 'Физика',
    dueAt: DateTime(2026, 9, 10, 12),
    source: DeadlineSource.me,
    isMine: true,
    isDone: isDone,
  );

  Future<void> pumpRow(
    WidgetTester tester, {
    required Deadline item,
    VoidCallback? onToggle,
    VoidCallback? onDelete,
    VoidCallback? onLongPress,
  }) {
    return tester.pumpApp(
      Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 360,
          child: DeadlineRow(
            deadline: item,
            pending: false,
            onToggle: onToggle,
            onDelete: onDelete,
            onLongPress: onLongPress ?? () {},
            now: DateTime(2026, 9, 9),
          ),
        ),
      ),
    );
  }

  testWidgets('swiping right toggles done without removing the row', (
    tester,
  ) async {
    var toggled = 0;
    await pumpRow(tester, item: deadline(), onToggle: () => toggled++);

    await tester.drag(find.byType(DeadlineRow), const Offset(300, 0));
    await tester.pumpAndSettle();

    expect(toggled, 1);
    expect(find.byType(DeadlineRow), findsOneWidget);
  });

  testWidgets('swiping left deletes the row', (tester) async {
    var deleted = 0;
    await pumpRow(tester, item: deadline(), onDelete: () => deleted++);

    await tester.drag(find.byType(DeadlineRow), const Offset(-300, 0));
    await tester.pumpAndSettle();

    expect(deleted, 1);
  });

  testWidgets('long-press invokes the actions callback', (tester) async {
    var pressed = 0;
    await pumpRow(tester, item: deadline(), onLongPress: () => pressed++);

    await tester.longPress(find.byType(DeadlineRow));
    await tester.pumpAndSettle();

    expect(pressed, 1);
  });

  testWidgets('a shared deadline that is not mine cannot be swiped', (
    tester,
  ) async {
    final shared = Deadline(
      id: 'two',
      title: 'Общее',
      dueAt: DateTime(2026, 9, 10, 12),
      source: DeadlineSource.group,
    );
    await pumpRow(tester, item: shared, onToggle: () {}, onDelete: () {});

    expect(find.byType(Dismissible), findsNothing);
  });
}
