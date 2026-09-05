import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/people.dart';
import 'package:rtu_mirea_app/study_group/study_group.dart';
import 'package:study_groups_repository/study_groups_repository.dart';
import 'package:user_repository/user_repository.dart';

class _AppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _FriendsRepository extends Mock implements FriendsRepository {}

class _GroupsRepository extends Mock implements StudyGroupsRepository {}

void main() {
  const group = StudyGroup(id: 'group', name: 'Учебная группа');
  late _AppBloc app;
  late _FriendsRepository friends;
  late _GroupsRepository groups;
  late GoRouter router;

  setUp(() {
    app = _AppBloc();
    when(() => app.state).thenReturn(
      const AppState(user: User(id: 'student', isNewUser: false)),
    );
    friends = _FriendsRepository();
    groups = _GroupsRepository();
    when(friends.getFriends).thenAnswer((_) async => []);
    when(friends.getFriendRequests).thenAnswer((_) async => []);
    when(groups.getMyGroup).thenAnswer((_) async => MyStudyGroup.empty);
  });

  tearDown(() async {
    router.dispose();
    await app.close();
  });

  Future<void> pump(WidgetTester tester, String location) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() => tester.pumpWidget(const SizedBox()));
    router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(
          path: '/services/people',
          builder: (_, _) => const PeoplePage(),
        ),
      ],
    );
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<FriendsRepository>.value(value: friends),
          RepositoryProvider<StudyGroupsRepository>.value(value: groups),
        ],
        child: BlocProvider<AppBloc>.value(
          value: app,
          child: MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (_, child) => NinjaToastHost(child: child!),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  PeopleCubit people(WidgetTester tester) =>
      tester.element(find.byType(PeopleView)).read<PeopleCubit>();

  testWidgets('group notification selects group and consumes the query', (
    tester,
  ) async {
    await pump(tester, '/services/people?tab=group');
    expect(people(tester).state.tab, PeopleTab.group);
    expect(router.routeInformationProvider.value.uri.query, isEmpty);
    expect(find.byType(StudyGroupPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a new notification updates the already open people page', (
    tester,
  ) async {
    await pump(tester, '/services/people');
    final page = tester.state(find.byType(PeoplePage));
    expect(people(tester).state.tab, PeopleTab.friends);
    router.go('/services/people?tab=group');
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(PeoplePage)), same(page));
    expect(people(tester).state.tab, PeopleTab.group);
    expect(router.routeInformationProvider.value.uri.query, isEmpty);
  });

  testWidgets('group owners open request management from a notification', (
    tester,
  ) async {
    when(groups.getMyGroup).thenAnswer(
      (_) async => const MyStudyGroup(
        hasGroup: true,
        isOwner: true,
        group: group,
      ),
    );
    await pump(tester, '/services/people?tab=group&manageGroup=1');
    expect(find.byType(StudyGroupPage), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.query, isEmpty);
    Navigator.of(tester.element(find.byType(StudyGroupPage))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(StudyGroupPage), findsNothing);
    expect(people(tester).state.tab, PeopleTab.group);
    expect(tester.takeException(), isNull);
  });

  testWidgets('friend notifications switch an open group tab to friends', (
    tester,
  ) async {
    await pump(tester, '/services/people?tab=group');
    final page = tester.state(find.byType(PeoplePage));
    expect(people(tester).state.tab, PeopleTab.group);
    router.go('/services/people?tab=friends');
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(PeoplePage)), same(page));
    expect(people(tester).state.tab, PeopleTab.friends);
    expect(router.routeInformationProvider.value.uri.query, isEmpty);
  });

  testWidgets('group members cannot open owner management via the query', (
    tester,
  ) async {
    when(groups.getMyGroup).thenAnswer(
      (_) async => const MyStudyGroup(hasGroup: true, group: group),
    );
    await pump(tester, '/services/people?tab=group&manageGroup=1');
    expect(people(tester).state.tab, PeopleTab.group);
    expect(find.byType(StudyGroupPage), findsNothing);
    expect(router.routeInformationProvider.value.uri.query, isEmpty);
  });

  testWidgets('legacy add and join queries still execute once', (tester) async {
    when(() => friends.sendFriendRequest('peer')).thenAnswer((_) async {});
    when(() => groups.joinByCode('code')).thenAnswer(
      (_) async => const MyStudyGroup(hasGroup: true, group: group),
    );
    await pump(tester, '/services/people?add=peer&joinGroup=code');
    verify(() => friends.sendFriendRequest('peer')).called(1);
    verify(() => groups.joinByCode('code')).called(1);
    expect(router.routeInformationProvider.value.uri.query, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('stale ownership does not open management after a load failure', (
    tester,
  ) async {
    when(groups.getMyGroup).thenAnswer(
      (_) async => const MyStudyGroup(
        hasGroup: true,
        isOwner: true,
        group: group,
      ),
    );
    await pump(tester, '/services/people');
    when(groups.getMyGroup).thenThrow(StateError('offline'));
    router.go('/services/people?tab=group&manageGroup=1');
    await tester.pumpAndSettle();
    expect(people(tester).state.tab, PeopleTab.group);
    expect(find.byType(StudyGroupPage), findsNothing);
    expect(router.routeInformationProvider.value.uri.query, isEmpty);
    await tester.pump(const Duration(seconds: 4));
  });
}
