import 'package:app_ui/app_ui.dart';
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
      expect(find.byType(NinjaEmptyState), findsNothing);
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
            friends: const [_friend],
            loading: false,
            myLatitude: 55.6699,
            myLongitude: 37.4803,
            onFriendTap: (_) {},
            onAddFriend: () {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.textContaining(' м'), findsOneWidget);
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

      expect(find.byType(NinjaEmptyState), findsOneWidget);
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

      expect(find.byType(NinjaErrorState), findsOneWidget);
      expect(find.byType(NinjaEmptyState), findsNothing);

      tester
          .widget<NinjaErrorState>(find.byType(NinjaErrorState))
          .onRetry
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
