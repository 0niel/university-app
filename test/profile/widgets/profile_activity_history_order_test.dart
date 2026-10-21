import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_activity_card.dart';

void main() {
  final newest = DateTime(2026, 9, 17);
  final ascending = [
    for (var index = 0; index < 28; index++)
      ActivityDay(
        day: DateTime(2026, 8, 21 + index),
        count: index % 4,
      ),
  ];
  final orders = <String, List<ActivityDay>>{
    'ascending': ascending,
    'descending': ascending.reversed.toList(),
    'shuffled': [...ascending.skip(7), ...ascending.take(7)],
  };

  for (final entry in orders.entries) {
    testWidgets('${entry.key} activity retains all days and current month', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 340,
                child: ProfileActivityCard(
                  streakDays: 3,
                  longestStreak: 6,
                  days: entry.value,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final heatmap = find.byType(AppActivityHeatmap);
      final cells = find.descendant(
        of: heatmap,
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.tooltip != null,
        ),
      );
      expect(cells, findsNWidgets(28));
      expect(
        tester
            .widget<AppStreakCalendarCard>(
              find.byType(AppStreakCalendarCard),
            )
            .today,
        newest,
      );
      expect(
        find.descendant(of: heatmap, matching: find.text('Aug')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: heatmap, matching: find.text('Sep')),
        findsOneWidget,
      );
      final component = tester.widget<AppActivityHeatmap>(heatmap);
      expect(
        tester
            .widgetList<Semantics>(cells)
            .map((cell) => cell.properties.tooltip),
        orderedEquals([
          for (final day in ascending)
            component.tooltipBuilder!(day.day, day.count),
        ]),
      );
      final newestMessage = component.tooltipBuilder!(
        newest,
        ascending.last.count,
      );
      await tester.longPress(cells.last);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text(newestMessage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('narrow large-text history keeps the newest day visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2),
          ),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 320,
              child: ProfileActivityCard(
                streakDays: 3,
                longestStreak: 6,
                days: [
                  for (var offset = 0; offset < 140; offset++)
                    ActivityDay(
                      day: newest.subtract(Duration(days: offset)),
                      count: offset == 0 ? 5 : offset % 3,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final heatmap = find.byType(AppActivityHeatmap);
    final cells = tester.widgetList<Semantics>(
      find.descendant(
        of: heatmap,
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.tooltip != null,
        ),
      ),
    );
    expect(cells.length, inInclusiveRange(70, 140));
    expect(
      cells.map((cell) => cell.properties.tooltip),
      contains(
        tester.widget<AppActivityHeatmap>(heatmap).tooltipBuilder!(newest, 5),
      ),
    );
    expect(
      find.descendant(of: heatmap, matching: find.text('Sep')),
      findsOneWidget,
    );
    final outlined = tester
        .widgetList<DecoratedBox>(
          find.descendant(of: heatmap, matching: find.byType(DecoratedBox)),
        )
        .where((box) => (box.decoration as BoxDecoration).border != null);
    expect(outlined, hasLength(1));
    expect(tester.takeException(), isNull);
  });
}
