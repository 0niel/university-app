import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_page.dart';

import '../../helpers/pump_app.dart';

Widget _header({GlobalKey? searchKey}) => Scaffold(
  body: CustomScrollView(
    slivers: [
      HomeDashboardHeader(
        day: DateTime(2026, 8, 18),
        locale: 'ru',
        userName: 'Иван Иванов',
        greeting: 'Привет, Иван',
        loading: false,
        searchKey: searchKey ?? GlobalKey(),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 900)),
    ],
  ),
);

Widget _title(HomeDayStatus status, {bool offline = false}) => Scaffold(
  body: HomeTitleBlock(
    day: DateTime(2026, 8, 18),
    locale: 'ru',
    status: status,
    loading: false,
    offline: offline,
  ),
);

void main() {
  testWidgets('the identity row leads with name and date', (tester) async {
    await tester.pumpApp(_header(), size: const Size(360, 720));
    await tester.pump();

    final greeting = tester.widget<Text>(find.text('Привет, Иван'));
    expect(greeting.style?.fontSize, NinjaText.headline.fontSize);
    expect(find.textContaining('Вторник'), findsOneWidget);
    expect(find.byType(NinjaAvatar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the header carries circular search and bell actions', (
    tester,
  ) async {
    final searchKey = GlobalKey();
    await tester.pumpApp(
      _header(searchKey: searchKey),
      size: const Size(360, 720),
    );
    await tester.pump();

    expect(find.byKey(searchKey), findsOneWidget);
    final icons = tester
        .widgetList<AppLineIconWidget>(find.byType(AppLineIconWidget))
        .map((w) => w.icon)
        .toList();
    expect(icons, contains(AppLineIcon.search));
    expect(icons, contains(AppLineIcon.bell));
  });

  testWidgets('the title block leads with the day', (tester) async {
    await tester.pumpApp(
      _title((
        kind: HomeDayStatusKind.upcoming,
        lessonCount: 3,
        minutes: 40,
        startsAt: DateTime(2026, 8, 18, 10, 40),
      )),
      size: const Size(360, 720),
    );
    await tester.pump();

    final date = tester.widget<Text>(find.text('18 августа'));
    expect(date.style?.fontSize, NinjaText.display.fontSize);
    expect(find.textContaining('через 40 мин'), findsOneWidget);
  });

  testWidgets('a scheduled day names its first bell', (tester) async {
    await tester.pumpApp(
      _title((
        kind: HomeDayStatusKind.scheduled,
        lessonCount: 2,
        minutes: 0,
        startsAt: DateTime(2026, 8, 18, 9, 30),
      )),
      size: const Size(360, 720),
    );
    await tester.pump();

    expect(find.textContaining('09:30'), findsOneWidget);
  });

  testWidgets('an empty offline day says so', (tester) async {
    await tester.pumpApp(
      _title(
        (
          kind: HomeDayStatusKind.free,
          lessonCount: 0,
          minutes: 0,
          startsAt: null,
        ),
        offline: true,
      ),
      size: const Size(360, 720),
    );
    await tester.pump();

    expect(find.textContaining('нет пар'), findsOneWidget);
    expect(find.textContaining('Оффлайн'), findsOneWidget);
  });

  testWidgets('the title block survives 320px at 200 percent text', (
    tester,
  ) async {
    await tester.pumpApp(
      _title((
        kind: HomeDayStatusKind.live,
        lessonCount: 4,
        minutes: 25,
        startsAt: DateTime(2026, 8, 18, 10, 40),
      )),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();

    final date = tester.widget<Text>(find.text('18 августа'));
    expect(date.style?.fontSize, NinjaText.title.fontSize);
    expect(tester.takeException(), isNull);
  });
}
