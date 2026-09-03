import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_page.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friend_card.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_discovery_action.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_results_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:user_repository/user_repository.dart';

class _MockFriendsRepository extends Mock implements FriendsRepository {}

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late FriendsRepository repository;
  late AppBloc appBloc;

  const roster = GroupRoster(
    group: 'ИКБО-09',
    members: [
      GroupMember(userId: 'g1', fullName: 'Олег Титов', handle: 'oleg'),
      GroupMember(userId: 'me', fullName: 'Я', isMe: true),
      GroupMember(userId: 'g2', fullName: 'Друг', isFriend: true),
    ],
  );
  const suggestions = [
    SuggestedFriend(userId: 's1', fullName: 'Вера Лис', mutualCount: 5),
  ];

  setUp(() {
    repository = _MockFriendsRepository();
    appBloc = _MockAppBloc();
    when(
      () => appBloc.state,
    ).thenReturn(
      const AppState(
        status: AppStatus.authenticated,
        user: User(id: 'me'),
      ),
    );
    when(() => repository.getGroupMembers()).thenAnswer((_) async => roster);
    when(
      () => repository.getPeopleYouMayKnow(),
    ).thenAnswer((_) async => suggestions);
    when(() => repository.searchUsers(any())).thenAnswer((_) async => const []);
    when(() => repository.sendFriendRequest(any())).thenAnswer((_) async {});
  });

  Widget wrap({String initialQuery = '', String? initialUserId}) {
    return RepositoryProvider<FriendsRepository>.value(
      value: repository,
      child: BlocProvider<AppBloc>.value(
        value: appBloc,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FindFriendsPage(
            initialQuery: initialQuery,
            initialUserId: initialUserId,
          ),
        ),
      ),
    );
  }

  testWidgets('header keeps a display title and a circular close button', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Добавить друзей'), findsOneWidget);
    final close = tester.widget<AppHeaderCircleButton>(
      find.byType(AppHeaderCircleButton),
    );
    expect(close.action.semanticsLabel, 'Закрыть');
    expect(close.action.icon, AppLineIcon.close);
    expect(find.text('Мой QR-код'), findsOneWidget);
    expect(find.text('Сканировать'), findsOneWidget);
  });

  testWidgets('exactly one discovery card carries the pastel accent', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final actions = tester.widgetList<NinjaFindFriendsDiscoveryAction>(
      find.byType(NinjaFindFriendsDiscoveryAction),
    );
    expect(actions, hasLength(2));
    expect(actions.where((action) => action.accented), hasLength(1));
  });

  testWidgets('cold load shows card skeletons, not a spinner', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.byType(NinjaFindFriendsResultsSkeleton), findsOneWidget);
    expect(find.byType(NinjaSkeleton), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  });

  testWidgets('a failed load shows an inline error card with a live retry', (
    tester,
  ) async {
    when(() => repository.getGroupMembers()).thenThrow(Exception('offline'));

    await tester.pumpWidget(wrap());
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.text('Ошибка загрузки'), findsOneWidget);

    when(() => repository.getGroupMembers()).thenAnswer((_) async => roster);
    await tester.tap(find.text('Повторить'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AppErrorState), findsNothing);
    expect(find.text('Олег Титов'), findsOneWidget);
  });

  testWidgets('shows group + suggestions, hides me and existing friends', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Из твоей группы ИКБО-09'), findsOneWidget);
    expect(find.text('Олег Титов'), findsOneWidget);
    expect(find.text('Добавить всю группу · 1 чел.'), findsOneWidget);
    expect(find.text('Возможно, вы знакомы'), findsOneWidget);
    expect(find.text('Вера Лис'), findsOneWidget);
    expect(find.text('Позвать из Telegram'), findsOneWidget);
    expect(find.text('Я'), findsNothing);
    expect(find.text('Друг'), findsNothing);
  });

  testWidgets('tapping Add sends a request and flips to a "sent" pill', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Добавить').first);
    await tester.pump();

    verify(() => repository.sendFriendRequest('g1')).called(1);
    expect(find.text('заявка отправлена'), findsOneWidget);
    expect(find.byType(AppTag), findsWidgets);
  });

  testWidgets('an empty search shows the ninja empty state', (tester) async {
    await tester.pumpWidget(wrap(initialQuery: 'Анна'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('Никого не нашли'), findsOneWidget);
  });

  testWidgets('search failure stays distinct from no matches and retries', (
    tester,
  ) async {
    when(() => repository.searchUsers('Анна')).thenThrow(Exception('offline'));
    await tester.pumpWidget(wrap(initialQuery: 'Анна'));
    await tester.pumpAndSettle();
    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.text('Никого не нашли'), findsNothing);
    when(
      () => repository.searchUsers('Анна'),
    ).thenAnswer((_) async => const []);
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.text('Никого не нашли'), findsOneWidget);
  });

  testWidgets('clearing a deep-linked query loads discovery', (tester) async {
    await tester.pumpWidget(wrap(initialQuery: 'Анна'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('Олег Титов'), findsOneWidget);
    verify(repository.getGroupMembers).called(1);
  });

  testWidgets('opens with and highlights the exact global-search person', (
    tester,
  ) async {
    when(() => repository.searchUsers('Анна Соколова')).thenAnswer(
      (_) async => const [
        UserSearchResult(userId: 'other', fullName: 'Анна Соколова'),
        UserSearchResult(userId: 'selected', fullName: 'Анна Соколова'),
      ],
    );

    await tester.pumpWidget(
      wrap(initialQuery: 'Анна Соколова', initialUserId: 'selected'),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final rows = tester.widgetList<NinjaFindFriendCard>(
      find.byType(NinjaFindFriendCard),
    );
    expect(rows.map((row) => row.selected), [true, false]);
    verify(() => repository.searchUsers('Анна Соколова')).called(1);
    verifyNever(() => repository.getGroupMembers());
  });
}
