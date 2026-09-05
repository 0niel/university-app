import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_pill_button.dart';
import 'package:rtu_mirea_app/friends/widgets/ninja_friends_panel.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

const _friend = Friend(
  friendshipId: 'f1',
  userId: 'u1',
  fullName: 'Наруто Узумаки',
  group: 'ИКБО-01-23',
  latitude: 55.67,
  longitude: 37.48,
);

void main() {
  group('FriendsPanel', () {
    testWidgets('the map panel can be expanded with a desktop mouse', (
      tester,
    ) async {
      final controller = DraggableScrollableController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            controller: controller,
            friends: const [_friend],
            loading: false,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );
      final listBounds = tester.getRect(find.byType(ListView));
      await tester.dragFrom(
        listBounds.topCenter + const Offset(0, 8),
        const Offset(0, -180),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pump();

      expect(controller.size, greaterThan(.28));
    });

    testWidgets('large student lists build only visible profiles', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            friends: List.generate(
              500,
              (index) => _friend.copyWith(
                userId: 'student-$index',
                fullName: 'Student $index',
              ),
            ),
            loading: false,
            showingStudents: true,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );

      expect(find.text('Student 0'), findsOneWidget);
      expect(find.text('Student 499'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('public profiles never expose remove-friend action', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const FriendCardSheet(friend: _friend, isFriend: false)),
      );

      expect(find.text('Виден всем студентам'), findsOneWidget);
      expect(find.byType(FriendsPillButton), findsNothing);

      await tester.pumpWidget(
        _wrap(const FriendCardSheet(friend: _friend)),
      );
      expect(find.byType(FriendsPillButton), findsOneWidget);
    });

    testWidgets('student map can be explored without sharing or friends', (
      tester,
    ) async {
      bool? selection;
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            friends: const [],
            loading: false,
            showingStudents: true,
            onShowStudentsChanged: (value) => selection = value,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Пока нет студентов на карте'), findsOneWidget);
      expect(
        find.textContaining('не делясь своей геопозицией'),
        findsOneWidget,
      );
      tester.widget<NinjaTabs<bool>>(find.byType(NinjaTabs<bool>)).onChanged!(
        false,
      );
      expect(selection, false);
    });

    testWidgets('shows skeleton cards on cold load, not a spinner', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            friends: const [],
            loading: true,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(AppEmptyState), findsNothing);
    });

    testWidgets('does not show skeleton once friends are loaded', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            friends: const [_friend],
            loading: false,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(NinjaSkeleton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Наруто Узумаки'), findsOneWidget);
    });

    testWidgets('renders a distance pill when my position is known', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            friends: [
              _friend.copyWith(
                locationUpdatedAt: DateTime.now().subtract(
                  const Duration(minutes: 1),
                ),
              ),
            ],
            loading: false,
            myLatitude: 55.6699,
            myLongitude: 37.4803,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('22 м'), findsOneWidget);
    });

    testWidgets('does not expose distance for private or invalid locations', (
      tester,
    ) async {
      final updatedAt = DateTime.now().subtract(const Duration(minutes: 1));
      final visible = _friend.copyWith(locationUpdatedAt: updatedAt);
      final cases = [
        (friend: _friend, latitude: 55.6699, longitude: 37.4803),
        (
          friend: visible.copyWith(isGhost: true),
          latitude: 55.6699,
          longitude: 37.4803,
        ),
        (friend: visible, latitude: 91.0, longitude: 37.4803),
        (friend: visible, latitude: 55.6699, longitude: double.nan),
        (
          friend: visible.copyWith(latitude: 91),
          latitude: 55.6699,
          longitude: 37.4803,
        ),
        (
          friend: visible.copyWith(
            locationUpdatedAt: DateTime.now().add(const Duration(days: 1)),
          ),
          latitude: 55.6699,
          longitude: 37.4803,
        ),
      ];
      for (final item in cases) {
        await tester.pumpWidget(
          _wrap(
            NinjaFriendsPanel(
              friends: [item.friend],
              loading: false,
              myLatitude: item.latitude,
              myLongitude: item.longitude,
              onFriendTap: (_) {},
              onAddFriend: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 400));
        expect(
          find.textContaining(RegExp(r'^\d+(?:[.,]\d+)? (?:м|км)$')),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('empty state offers a pill CTA that opens find friends', (
      tester,
    ) async {
      var addTapped = 0;
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            friends: const [],
            loading: false,
            onFriendTap: (_) {},
            onAddFriend: () => addTapped++,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.text('Пока никого'), findsOneWidget);

      final cta = tester.widget<FriendsPillButton>(
        find.widgetWithText(FriendsPillButton, 'Добавить друга'),
      );
      cta.onTap?.call();
      await tester.pump();
      expect(addTapped, 1);
    });

    testWidgets('failure state shows the error state and retries', (
      tester,
    ) async {
      var retries = 0;
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            friends: const [],
            loading: false,
            failed: true,
            onRetry: () => retries++,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(AppErrorState), findsOneWidget);
      expect(find.byType(AppEmptyState), findsNothing);

      tester
          .widget<AppErrorState>(find.byType(AppErrorState))
          .onPrimary
          ?.call();
      await tester.pump();
      expect(retries, 1);
    });

    testWidgets('the header add action is a pill button', (tester) async {
      await tester.pumpWidget(
        _wrap(
          NinjaFriendsPanel(
            friends: const [_friend],
            loading: false,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(FriendsPillButton), findsOneWidget);
      expect(find.text('+ Добавить'), findsOneWidget);
    });
  });
}
