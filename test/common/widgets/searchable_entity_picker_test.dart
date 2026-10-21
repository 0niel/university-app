import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/widgets/searchable_entity_picker.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('large search results build only visible rows', (tester) async {
    var builtRows = 0;
    final queries = <String>[];
    await tester.pumpApp(
      Scaffold(
        body: SearchableEntityPicker<String>(
          onSearch: (query) async {
            queries.add(query);
            return List.generate(1000, (index) => 'Room $index');
          },
          titleBuilder: (item) => item,
          subtitleBuilder: (item) {
            builtRows++;
            return item;
          },
          onManualCreate: (name) => name,
          icon: AppLineIcon.search,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Room 0');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
    expect(find.text('Room 0'), findsWidgets);
    expect(builtRows, lessThan(40));
    expect(find.text('Room 999'), findsNothing);

    await tester.enterText(find.byType(EditableText), 'Room 0 ');
    await tester.pump(const Duration(milliseconds: 400));
    expect(queries, ['Room 0']);
    expect(tester.takeException(), isNull);
  });
}
