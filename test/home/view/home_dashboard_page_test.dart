import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_content.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../gallery/home_dashboard_fixture.dart';
import '../../helpers/mocks/mock_schedule_repository.dart';
import '../../helpers/pump_app.dart';

class _Community extends Mock implements CommunityRepository {}

class _Gamification extends Mock implements GamificationRepository {}

void main() {
  testWidgets('clock refreshes immediately when the home tab is shown', (
    tester,
  ) async {
    final repository = MockScheduleRepository();
    when(repository.getDeadlines).thenAnswer((_) async => []);
    final community = _Community();
    when(community.getTopTopics).thenAnswer(
      (_) async => const TopTopicsResponse(users: [], topics: []),
    );
    final gamification = _Gamification();
    when(gamification.getProfile).thenAnswer(
      (_) async => UserGamificationProfile.empty,
    );
    when(() => gamification.getProfileOverview(any())).thenAnswer(
      (_) async => ProfileOverview.empty,
    );
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final enabled = ValueNotifier(true);
    addTearDown(enabled.dispose);
    await tester.pumpApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ScheduleRepository>.value(value: repository),
          RepositoryProvider<CommunityRepository>.value(value: community),
          RepositoryProvider<GamificationRepository>.value(value: gamification),
        ],
        child: homeDashboardFixture(
          controller: controller,
          child: ValueListenableBuilder(
            valueListenable: enabled,
            child: const HomeDashboardPage(),
            builder: (_, visible, child) =>
                TickerMode(enabled: visible, child: child!),
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pump();
    final before = tester
        .widget<HomeDashboardContent>(
          find.byType(HomeDashboardContent),
        )
        .now;
    enabled.value = false;
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    expect(
      tester
          .widget<HomeDashboardContent>(find.byType(HomeDashboardContent))
          .now,
      before,
    );
    enabled.value = true;
    await tester.pump();
    await tester.pump();
    expect(
      tester
          .widget<HomeDashboardContent>(find.byType(HomeDashboardContent))
          .now
          .isAfter(before),
      isTrue,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
