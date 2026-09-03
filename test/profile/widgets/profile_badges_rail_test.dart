import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/profile/widgets/profile/profile_widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  GamificationBadge earnedFromRpcRow(Map<String, Object?> row) =>
      GamificationBadge.fromJson(row);

  final earnedStreak = earnedFromRpcRow({
    'id': 'streak_3',
    'category': 'Активность',
    'name': 'Разогрев',
    'description': 'Стрик 3 дня',
    'emoji': '🔥',
    'rarity': 'common',
    'xpReward': 20,
    'shurikenReward': 10,
    'isEarned': true,
    'progress': 1,
    'earnedAt': '2026-08-13T19:24:37.287867+00:00',
  });
  final earnedFriend = earnedFromRpcRow({
    'id': 'friend_1',
    'category': 'Сообщество',
    'name': 'Не один',
    'description': 'Первый друг',
    'emoji': '🤝',
    'rarity': 'common',
    'xpReward': 20,
    'shurikenReward': 10,
    'isEarned': true,
    'progress': 1,
    'earnedAt': '2026-09-03T12:36:52.534459+00:00',
  });
  final lockedMaterial = earnedFromRpcRow({
    'id': 'material_25',
    'category': 'Учёба',
    'name': 'Хранитель знаний',
    'description': '25 публичных материалов',
    'emoji': '🏛️',
    'rarity': 'epic',
    'xpReward': 100,
    'shurikenReward': 50,
    'isEarned': false,
    'progress': 0.24,
    'earnedAt': null,
  });

  testWidgets('shows every earned badge from the real RPC shape', (
    tester,
  ) async {
    await tester.pumpApp(
      ProfileBadgesRail(
        badges: [earnedStreak, earnedFriend, lockedMaterial],
        totalBadges: 17,
      ),
    );

    expect(find.text('Разогрев'), findsOneWidget);
    expect(find.text('Не один'), findsOneWidget);
    expect(find.text('Хранитель знаний'), findsOneWidget);
    expect(find.text('все 17'), findsOneWidget);
    expect(find.text('Стрик 3 дня'), findsOneWidget);
  });

  testWidgets('tapping a card and the header action both fire', (
    tester,
  ) async {
    var allTapped = 0;
    var badgeTapped = 0;
    await tester.pumpApp(
      ProfileBadgesRail(
        badges: [earnedStreak],
        totalBadges: 17,
        onAll: () => allTapped++,
        onBadge: () => badgeTapped++,
      ),
    );

    await tester.tap(find.text('все 17'));
    await tester.tap(find.text('Разогрев'));
    expect(allTapped, 1);
    expect(badgeTapped, 1);
  });

  testWidgets('empty state hints at the first achievement', (tester) async {
    await tester.pumpApp(const ProfileBadgesRail(badges: [], totalBadges: 0));

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('все 0'), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });
}
