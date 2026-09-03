import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MockCommunityRepository extends Mock implements CommunityRepository {}

void main() {
  group('DiscoursePostOverviewPageView', () {
    late CommunityRepository communityRepository;

    setUp(() {
      communityRepository = MockCommunityRepository();
    });

    Widget buildSubject({double textScale = 1, int postId = 1}) {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CommunityRepository>.value(
            value: communityRepository,
          ),
          RepositoryProvider<UniversityConfig>.value(
            value: const UniversityConfig(
              organizationId: 'test',
              appName: 'Campus',
              universityName: 'University',
              universityShortName: 'U',
              websiteUrl: 'https://example.edu',
              supportEmail: 'support@example.edu',
              deepLinkScheme: 'campus',
              webAppHost: 'example.edu',
              webAppPathPrefix: '/app',
              communityForumUrl: 'https://forum.example.edu',
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
              disableAnimations: true,
              accessibleNavigation: true,
            ),
            child: child!,
          ),
          home: DiscoursePostOverviewPageView(postId: postId),
        ),
      );
    }

    testWidgets(
      'shows a quiet pulsing skeleton while the post is loading',
      (tester) async {
        when(
          () => communityRepository.getPost(any()),
        ).thenAnswer((_) => Completer<DiscoursePost>().future);

        await tester.pumpWidget(buildSubject());
        await tester.pump();

        expect(find.byType(NinjaSkeleton), findsWidgets);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(AppInnerHeader), findsOneWidget);
      },
    );

    testWidgets('loaded thread remains usable at 320px and 200% text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 760);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      when(() => communityRepository.getPost(1)).thenAnswer(
        (_) async => DiscoursePost(
          id: 1,
          topicId: 10,
          username: 'student',
          avatarTemplate: '/avatar/{size}.png',
          cooked: '<p>Полезный материал для подготовки</p>',
          createdAt: DateTime(2026),
        ),
      );
      when(
        () => communityRepository.getPostComments(topicId: 10),
      ).thenAnswer(
        (_) async => [
          DiscoursePostComment(
            id: 2,
            username: 'reader',
            avatarTemplate: '/reader/{size}.png',
            cooked: '<p>Спасибо за публикацию</p>',
            createdAt: DateTime(2026, 1, 2),
            likeCount: 2,
          ),
        ],
      );

      await tester.pumpWidget(buildSubject(textScale: 2));
      await tester.pump();
      await tester.pump();

      expect(find.text('student'), findsOneWidget);
      expect(find.text('reader'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'comment failure is distinct from an empty thread and can retry',
      (tester) async {
        when(() => communityRepository.getPost(1)).thenAnswer(
          (_) async => DiscoursePost(
            id: 1,
            topicId: 10,
            username: 'student',
            avatarTemplate: '',
            cooked: '<p>Текст поста</p>',
            createdAt: DateTime(2026),
          ),
        );
        var requests = 0;
        when(() => communityRepository.getPostComments(topicId: 10)).thenAnswer(
          (_) async {
            requests++;
            if (requests == 1) throw Exception('offline');
            return [];
          },
        );
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();
        expect(find.text('Не удалось загрузить комментарии'), findsOneWidget);
        expect(find.text('Пока нет комментариев'), findsNothing);
        await tester.ensureVisible(find.text('Повторить'));
        await tester.tap(find.text('Повторить'));
        await tester.pumpAndSettle();
        expect(find.text('Пока нет комментариев'), findsOneWidget);
        expect(find.text('Не удалось загрузить комментарии'), findsNothing);
      },
    );

    testWidgets('changing the post id replaces the scoped loader', (
      tester,
    ) async {
      when(() => communityRepository.getPost(any())).thenAnswer((
        invocation,
      ) async {
        final id = invocation.positionalArguments.single as int;
        return DiscoursePost(
          id: id,
          topicId: id * 10,
          username: 'student_$id',
          avatarTemplate: '',
          cooked: '<p>Post $id</p>',
          createdAt: DateTime(2026),
        );
      });
      when(
        () =>
            communityRepository.getPostComments(topicId: any(named: 'topicId')),
      ).thenAnswer((_) async => []);
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('student_1'), findsOneWidget);
      await tester.pumpWidget(buildSubject(postId: 2));
      await tester.pumpAndSettle();
      expect(find.text('student_2'), findsOneWidget);
      expect(find.text('student_1'), findsNothing);
      verify(() => communityRepository.getPost(2)).called(1);
    });
  });
}
