import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/search/view/search_sheet_row.dart';

void main() {
  for (final dark in [false, true]) {
    for (final direction in TextDirection.values) {
      testWidgets('search row preserves source columns $dark $direction', (
        tester,
      ) async {
        var opened = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: Directionality(
              textDirection: direction,
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 350,
                    child: SearchSheetRow(
                      hit: SearchSheetHit(
                        kind: 'ПРЕДМЕТ',
                        title: 'Математический анализ',
                        subtitle: 'Расписание',
                        onTap: () => opened = true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final kind = tester.getRect(find.text('ПРЕДМЕТ'));
        final title = tester.getRect(find.text('Математический анализ'));
        expect(kind.width, 76);
        expect(
          direction == TextDirection.ltr
              ? title.left - kind.right
              : kind.left - title.right,
          closeTo(12, .01),
        );
        expect(
          tester.getSize(find.byType(SearchSheetRow)).height,
          greaterThanOrEqualTo(44),
        );
        await tester.tap(find.byType(SearchSheetRow));
        expect(opened, isTrue);
      });
    }
  }

  testWidgets('recent visual pill retains a 44px semantic target', (
    tester,
  ) async {
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Wrap(
            children: [
              SearchRecentPill(label: 'Матан', onTap: () => opened = true),
            ],
          ),
        ),
      ),
    );
    final target = find.bySemanticsLabel('Матан');
    expect(tester.getSize(target).height, 44);
    final visual = find.descendant(
      of: find.byType(SearchRecentPill),
      matching: find.byType(Container),
    );
    expect(tester.getSize(visual).height, closeTo(37, 1));
    await tester.tapAt(tester.getTopLeft(target) + const Offset(10, 1));
    expect(opened, isTrue);
  });

  testWidgets('search row fits 320px with 200% text and full semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2),
          ),
          child: child!,
        ),
        home: Scaffold(
          body: SizedBox(
            width: 280,
            child: SearchSheetRow(
              hit: SearchSheetHit(
                kind: 'ПРЕПОДАВАТЕЛЬ',
                title: 'Преподаватель с длинным именем и фамилией',
                subtitle: 'Кафедра фундаментальной информатики',
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      find.bySemanticsLabel(RegExp('ПРЕПОДАВАТЕЛЬ, Преподаватель')),
      findsOneWidget,
    );
  });
}
