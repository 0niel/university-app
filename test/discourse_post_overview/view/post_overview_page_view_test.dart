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

    Widget buildSubject({double textScale = 1}) {
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
          home: const DiscoursePostOverviewPageView(postId: 1),
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
  });
}
