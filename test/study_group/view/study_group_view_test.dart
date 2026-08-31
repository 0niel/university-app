import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/study_group/study_group.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

class MockStudyGroupsRepository extends Mock implements StudyGroupsRepository {}

int _pastelCardCount(WidgetTester tester, Color accentSoft) {
  var count = 0;
  for (final box in tester.widgetList<DecoratedBox>(
    find.byType(DecoratedBox),
  )) {
    final decoration = box.decoration;
    if (decoration is BoxDecoration && decoration.color == accentSoft) {
      count++;
    }
  }
  return count;
}

void main() {
  late StudyGroupsRepository repository;

  const group = StudyGroup(
    id: 'g1',
    name: 'ИКБО-09-22',
    joinCode: 'MNMN6T',
    description: 'Кибербезопасность, 3 курс',
    memberCount: 2,
  );
  const owned = MyStudyGroup(
    hasGroup: true,
    isOwner: true,
    group: group,
    members: [
      StudyGroupMember(
        userId: 'u1',
        fullName: 'Иван Иванов',
        role: 'owner',
        isOwner: true,
        isMe: true,
      ),
      StudyGroupMember(
        userId: 'u2',
        fullName: 'Пётр Петров',
        handle: 'petya',
      ),
    ],
  );

  setUp(() => repository = MockStudyGroupsRepository());

  Widget buildSubject() {
    return MaterialApp(
      theme: NinjaTheme.dark(),
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: RepositoryProvider<StudyGroupsRepository>.value(
        value: repository,
        child: const StudyGroupPage(),
      ),
    );
  }

  NinjaColors colorsOf(WidgetTester tester) =>
      tester.element(find.byType(StudyGroupView)).ninja;

  testWidgets('the group card is the only pastel feature card', (tester) async {
    when(repository.getMyGroup).thenAnswer((_) async => owned);

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final colors = colorsOf(tester);
    expect(find.byType(NinjaStudyGroupHeroCard), findsOneWidget);
    expect(_pastelCardCount(tester, colors.accentSoft), 1);

    final hero = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(NinjaStudyGroupHeroCard),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect((hero.decoration as BoxDecoration).color, colors.accentSoft);
    expect(find.text('ИКБО-09-22'), findsOneWidget);
    expect(find.text('Пётр Петров'), findsOneWidget);
  });

  testWidgets('cold load shows a skeleton with no pastel card', (tester) async {
    final pending = Completer<MyStudyGroup>();
    when(repository.getMyGroup).thenAnswer((_) => pending.future);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.byType(NinjaStudyGroupSkeleton), findsOneWidget);
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    expect(_pastelCardCount(tester, colorsOf(tester).accentSoft), 0);

    pending.complete(MyStudyGroup.empty);
    await tester.pumpAndSettle();
  });

  testWidgets('a failed load shows a retryable error state', (tester) async {
    when(repository.getMyGroup).thenThrow(
      const GetMyStudyGroupFailure('boom'),
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byType(NinjaErrorState), findsOneWidget);
    expect(find.byType(NinjaEmptyState), findsNothing);

    when(repository.getMyGroup).thenAnswer((_) async => MyStudyGroup.empty);
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();

    verify(repository.getMyGroup).called(greaterThan(1));
    expect(find.byType(NinjaErrorState), findsNothing);
  });

  testWidgets('the empty state offers a create-group action', (tester) async {
    when(repository.getMyGroup).thenAnswer((_) async => MyStudyGroup.empty);

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byType(NinjaEmptyState), findsOneWidget);
    expect(find.byType(NinjaStudyGroupHeroCard), findsNothing);

    await tester.tap(find.text('Создать группу'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateGroupSheet), findsOneWidget);
  });

  testWidgets('state swaps run through the shared switcher', (tester) async {
    when(repository.getMyGroup).thenAnswer((_) async => owned);

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byType(NinjaStateSwitcher), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(NinjaStudyGroupContent),
        matching: find.byType(NinjaButton),
      ),
      findsNWidgets(2),
    );
  });
}
