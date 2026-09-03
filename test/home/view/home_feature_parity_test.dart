import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_hero.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_quick_actions.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_week_pills.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('home pills show each lesson type but no standalone change dot', (
    tester,
  ) async {
    final today = DateTime(2026, 9, 2);
    const marks = [Colors.green, Colors.blue, Colors.purple, Colors.green];
    await tester.pumpWidget(
      _app(
        HomeWeekPills(
          days: homeWeekDays(today),
          selectedIndex: 2,
          today: today,
          lessonCounts: const [0, 0, 4, 0, 0, 0, 0],
          lessonColors: const [[], [], marks, [], [], [], []],
          changedDays: const {3},
          onSelected: (_) {},
        ),
      ),
    );
    final strip = tester.widget<AppWeekStrip>(find.byType(AppWeekStrip));
    expect(strip.days[2].dots, marks);
    expect(strip.days[3].dots, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home retains all three tour anchors', (tester) async {
    final today = DateTime(2026, 9, 2);
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            HomeWeekPills(
              days: homeWeekDays(today),
              selectedIndex: 2,
              today: today,
              lessonCounts: const [],
              changedDays: const {},
              onSelected: (_) {},
            ),
            HomeHero(
              entries: const [],
              kind: HomeHeroKind.free,
              tomorrow: const [],
              now: today,
              onOpen: (_) {},
              onRoute: null,
              onNote: (_) {},
              onFreeRooms: () {},
              onDeadlines: () {},
              onTomorrow: () {},
            ),
            HomeQuickActions(services: const [], onAll: () {}),
          ],
        ),
      ),
    );
    await tester.pump();
    for (final target in [
      AppTourTarget.homeDays,
      AppTourTarget.homeBoard,
      AppTourTarget.homeServices,
    ]) {
      expect(AppTourAnchors.contextOf(target), isNotNull);
    }
    await tester.pumpWidget(const SizedBox.shrink());
    for (final target in [
      AppTourTarget.homeDays,
      AppTourTarget.homeBoard,
      AppTourTarget.homeServices,
    ]) {
      expect(AppTourAnchors.contextOf(target), isNull);
    }
  });

  testWidgets('home day browsing crosses both week boundaries', (tester) async {
    final today = DateTime(2026, 9, 2);
    var selected = today;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) {
            final days = homeWeekDays(selected);
            return HomeWeekPills(
              days: days,
              selectedIndex: days.indexWhere(
                (day) => DateUtils.isSameDay(day, selected),
              ),
              today: today,
              lessonCounts: const [],
              changedDays: const {},
              onSelected: (index) => setState(() => selected = days[index]),
              onWeekChanged: (step) => setState(
                () => selected = selected.add(Duration(days: step * 7)),
              ),
            );
          },
        ),
      ),
    );
    await tester.fling(find.byType(HomeWeekPills), const Offset(-250, 0), 800);
    await tester.pumpAndSettle();
    expect(selected, DateTime(2026, 9, 9));
    expect(
      tester.widget<HomeWeekPills>(find.byType(HomeWeekPills)).days.first,
      DateTime(2026, 9, 7),
    );
    await tester.fling(find.byType(HomeWeekPills), const Offset(250, 0), 800);
    await tester.pumpAndSettle();
    await tester.fling(find.byType(HomeWeekPills), const Offset(250, 0), 800);
    await tester.pumpAndSettle();
    expect(selected, DateTime(2026, 8, 26));
    expect(tester.takeException(), isNull);
  });
}
