import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_content.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_quick_actions.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../gallery/home_dashboard_fixture.dart';
import '../../helpers/pump_app.dart';

void main() {
  Future<HomeQuickActions> pumpDashboard(
    WidgetTester tester,
    FavoriteServicesCubit favorites,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final now = DateTime(2026, 9, 1, 11, 22);
    await tester.pumpApp(
      Scaffold(
        body: homeDashboardFixture(
          controller: controller,
          child: BlocProvider<FavoriteServicesCubit>.value(
            value: favorites,
            child: HomeDashboardContent(
              now: now,
              selectedDay: now,
              scrollController: controller,
              searchKey: GlobalKey(),
              onSelectedDay: (_) {},
              onRetry: () {},
            ),
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    final quickActions = find.byType(HomeQuickActions);
    await tester.scrollUntilVisible(
      quickActions,
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 800));
    return tester.widget<HomeQuickActions>(quickActions);
  }

  testWidgets('fresh dashboard shows all eight defaults in requested order', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final favorites = FavoriteServicesCubit();
    addTearDown(favorites.close);
    await favorites.load();

    final shortcuts = await pumpDashboard(tester, favorites);

    expect(
      shortcuts.services.map((entry) => entry.id),
      HomeServiceDefaults.routes,
    );
    expect(shortcuts.services, hasLength(8));
    expect(find.text('Сообщество'), findsOneWidget);
    final labels = tester.widgetList<AppServiceTile>(
      find.descendant(
        of: find.byType(HomeQuickActions),
        matching: find.byType(AppServiceTile),
      ),
    );
    expect(labels.map((tile) => tile.label), [
      'Дедлайны',
      'Афиша',
      'Друзья',
      'Маркет',
      'Бюро находок',
      'Сообщество',
      'Опросы',
      'Люди',
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard preserves a custom saved shortcut order', (
    tester,
  ) async {
    const ids = ['/services/polls', '/services/events', '/services/deadlines'];
    SharedPreferences.setMockInitialValues({'services.favorites': ids});
    final favorites = FavoriteServicesCubit();
    addTearDown(favorites.close);
    await favorites.load();

    final shortcuts = await pumpDashboard(tester, favorites);

    expect(shortcuts.services.map((entry) => entry.id), ids);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard respects a deliberately empty saved selection', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'services.favorites': <String>[]});
    final favorites = FavoriteServicesCubit();
    addTearDown(favorites.close);
    await favorites.load();

    final shortcuts = await pumpDashboard(tester, favorites);

    expect(shortcuts.services, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
