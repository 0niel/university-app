@Tags(['gallery'])
library;

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:rtu_mirea_app/notifications/view/notifications_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'gallery_fonts.dart';

class _Community extends Mock implements CommunityRepository {}

enum _Scene { history, historyEmpty, discussion, discussionCommentsFailure }

const _config = UniversityConfig(
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
);

void main() {
  setUpAll(loadGalleryFonts);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    HydratedBloc.storage = CustomHydratedStorage(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  });
  for (final dark in [false, true]) {
    for (final scene in _Scene.values) {
      testWidgets('${scene.name} ${dark ? 'dark' : 'light'}', (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final now = DateTime(2026, 9, 2, 12);
        final notifications = NotificationsCubit(userId: 'student');
        addTearDown(notifications.close);
        if (scene == _Scene.history) {
          for (final (index, kind) in AppNotificationKind.values.indexed) {
            notifications.recordPush(
              id: 'notice-$index',
              title: [
                'Перенос пары',
                'Приближается дедлайн',
                'Ответ на публикацию',
                'Обновление расписания',
                'Новое сообщение',
              ][index],
              body: [
                'Математика · 13:00',
                'Лабораторная работа · завтра',
                'В вашей теме появился ответ',
                'Изменения доступны в расписании',
                'Откройте уведомление для просмотра',
              ][index],
              at: now.subtract(Duration(minutes: index * 10 + 5)),
              kind: kind,
            );
          }
        }
        final community = _Community();
        when(() => community.getPost(1)).thenAnswer(
          (_) async => DiscoursePost(
            id: 1,
            topicId: 10,
            username: 'student',
            avatarTemplate: '',
            cooked:
                '<h2>Подготовка к экзамену</h2><p>Собрали материалы, которые помогут повторить основные темы перед экзаменом.</p><p><a href="https://example.edu">Материалы курса</a></p>',
            createdAt: DateTime(2026, 9, 2, 10),
          ),
        );
        when(() => community.getPostComments(topicId: 10)).thenAnswer((
          _,
        ) async {
          if (scene == _Scene.discussionCommentsFailure) {
            throw Exception('offline');
          }
          return [
            DiscoursePostComment(
              id: 2,
              username: 'reader',
              avatarTemplate: '',
              cooked: '<p>Спасибо за полезные материалы!</p>',
              createdAt: DateTime(2026, 9, 2, 11),
              likeCount: 2,
            ),
          ];
        });
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<CommunityRepository>.value(value: community),
              RepositoryProvider<UniversityConfig>.value(value: _config),
            ],
            child: BlocProvider<NotificationsCubit>.value(
              value: notifications,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(disableAnimations: true),
                  child: child!,
                ),
                home: switch (scene) {
                  _Scene.discussion || _Scene.discussionCommentsFailure =>
                    const DiscoursePostOverviewPageView(postId: 1),
                  _ => Builder(
                    builder: (context) => Scaffold(
                      backgroundColor: context.colors.canvas,
                      body: Center(
                        child: AppButton.primary(
                          label: 'Открыть',
                          onPressed: () => unawaited(
                            showAppSheet<void>(
                              context,
                              showClose: false,
                              contentPadding: EdgeInsets.zero,
                              child: BlocProvider<NotificationsCubit>.value(
                                value: notifications,
                                child: NotificationsSheet(
                                  changes: const [],
                                  now: now,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                },
              ),
            ),
          ),
        );
        if (scene == _Scene.history || scene == _Scene.historyEmpty) {
          await tester.tap(find.text('Открыть'));
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/${scene.name}_${dark ? 'dark' : 'light'}.png',
          ),
        );
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
