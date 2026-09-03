import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';

class MockCommunityRepository extends Mock implements CommunityRepository {}

void main() {
  group('TopTopicsView', () {
    late CommunityRepository communityRepository;

    setUp(() {
      communityRepository = MockCommunityRepository();
    });

    Widget buildSubject({TextScaler textScaler = TextScaler.noScaling}) {
      return MaterialApp(
        theme: NinjaTheme.dark(),
        locale: const Locale('ru'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        home: MediaQuery(
          data: MediaQueryData(textScaler: textScaler),
          child: RepositoryProvider<CommunityRepository>.value(
            value: communityRepository,
            child: RepositoryProvider<UniversityConfig>.value(
              value: UniversityConfig.current,
              child: const Scaffold(body: TopTopicsView()),
            ),
          ),
        ),
      );
    }

    testWidgets(
      'shows the skeleton on cold load and hides the spinner',
      (tester) async {
        final pending = Completer<TopTopicsResponse>();
        when(
          () => communityRepository.getTopTopics(),
        ).thenAnswer((_) => pending.future);

        await tester.pumpWidget(buildSubject());
        await tester.pump();

        expect(find.byType(TopicNewsCardSkeleton), findsWidgets);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets('loading rail reserves 200 percent text geometry', (
      tester,
    ) async {
      final pending = Completer<TopTopicsResponse>();
      when(
        () => communityRepository.getTopTopics(),
      ).thenAnswer((_) => pending.future);

      await tester.pumpWidget(
        buildSubject(textScaler: const TextScaler.linear(2)),
      );
      await tester.pump();

      expect(tester.getSize(find.byType(TopTopicsContent)).height, 272);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the rail does not truncate a populated page at fifteen', (
      tester,
    ) async {
      when(() => communityRepository.getTopTopics()).thenAnswer(
        (_) async => TopTopicsResponse(
          topics: List.generate(
            20,
            (index) => DiscourseTopic(
              id: index + 1,
              title: 'Topic $index',
              postsCount: 2,
              replyCount: 1,
              likeCount: 0,
              views: 20,
              posters: const [],
            ),
          ),
          users: const [],
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));
      final rail = tester.widget<ListView>(find.byType(ListView));
      expect(rail.childrenDelegate.estimatedChildCount, 39);
      expect(tester.takeException(), isNull);
    });
  });
}
