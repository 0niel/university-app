import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/marketplace/marketplace.dart';

import '../../helpers/pump_app.dart';

void main() {
  Widget buildSubject({
    bool isSold = false,
    VoidCallback? onToggleSold,
    VoidCallback? onEdit,
    VoidCallback? onArchive,
    VoidCallback? onDelete,
  }) => Scaffold(
    body: MarketOwnerActions(
      isSold: isSold,
      onToggleSold: onToggleSold,
      onEdit: onEdit,
      onArchive: onArchive,
      onDelete: onDelete,
    ),
  );

  testWidgets('renders the mark-sold label when the listing is active', (
    tester,
  ) async {
    await tester.pumpApp(buildSubject(onToggleSold: () {}));

    expect(find.text('Отметить проданным'), findsOneWidget);
  });

  testWidgets('renders the mark-available label when already sold', (
    tester,
  ) async {
    await tester.pumpApp(buildSubject(isSold: true, onToggleSold: () {}));

    expect(find.text('Снова доступно'), findsOneWidget);
  });

  testWidgets('invokes each callback and disables missing ones', (
    tester,
  ) async {
    var toggled = false;
    var edited = false;
    await tester.pumpApp(
      buildSubject(
        onToggleSold: () => toggled = true,
        onEdit: () => edited = true,
      ),
    );

    await tester.tap(find.text('Отметить проданным'));
    await tester.tap(find.text('Редактировать'));
    expect(toggled, isTrue);
    expect(edited, isTrue);

    final buttons = tester.widgetList<AppButton>(find.byType(AppButton));
    final archiveButton = buttons.firstWhere(
      (button) => button.label == 'В архив',
    );
    final deleteButton = buttons.firstWhere(
      (button) => button.label == 'Удалить объявление',
    );
    expect(archiveButton.onPressed, isNull);
    expect(deleteButton.onPressed, isNull);
  });
}
