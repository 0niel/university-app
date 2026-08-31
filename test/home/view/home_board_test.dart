import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/view/home_deadline_row.dart';
import 'package:rtu_mirea_app/home/view/home_section_header.dart';
import 'package:rtu_mirea_app/home/view/home_section_list.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/mocks/mock_schedule_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('HomeSectionHeader', () {
    testWidgets('prints a clear title and accent action', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: HomeSectionHeader(title: 'Новости', action: 'все'),
        ),
      );

      final title = tester.widget<Text>(find.text('Новости'));
      expect(
        title.style,
        NinjaText.title.copyWith(color: AppColors.light.active),
      );

      final action = tester.widget<Text>(find.text('все'));
      expect(action.style?.fontSize, NinjaText.buttonSmall.fontSize);
      expect(
        action.style?.color,
        tester.element(find.text('все')).ninja.brandInk,
      );
    });

    testWidgets('opens the first section at 14px', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: HomeSectionHeader(title: 'Сервисы', topPadding: 14),
        ),
      );

      final padding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Сервисы'), matching: find.byType(Padding))
            .last,
      );
      expect(padding.padding, const EdgeInsets.fromLTRB(20, 14, 20, 4));
    });
  });

  group('HomeSectionList', () {
    testWidgets('groups rows without another card surface', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: HomeSectionList(children: [Text('row')]),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(
        padding.padding,
        const EdgeInsets.fromLTRB(
          NinjaMetrics.screenPadding,
          0,
          NinjaMetrics.screenPadding,
          2,
        ),
      );

      expect(find.byType(NinjaCard), findsNothing);
      expect(find.byType(Column), findsOneWidget);
    });
  });

  testWidgets('trending card stays dense at 320px and 200 percent text', (
    tester,
  ) async {
    const topic = DiscourseTopic(
      id: 42,
      title: 'Очень длинный заголовок важной университетской новости',
      postsCount: 8,
      replyCount: 4,
      likeCount: 12,
      views: 300,
      posters: [],
    );
    await tester.pumpApp(
      RepositoryProvider<UniversityConfig>.value(
        value: const UniversityConfig(
          organizationId: 'test-university',
          appName: 'Campus App',
          universityName: 'Test University',
          universityShortName: 'TU',
          websiteUrl: 'https://example.edu',
          supportEmail: 'support@example.edu',
          deepLinkScheme: 'campus',
          webAppHost: 'example.edu',
          webAppPathPrefix: '/app',
        ),
        child: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 310,
              child: TopicNewsCard(topic: topic),
            ),
          ),
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();

    expect(find.text(topic.title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('personal deadline can be completed directly from home', (
    tester,
  ) async {
    final repository = MockScheduleRepository();
    final deadline = Deadline(
      id: 'home-deadline',
      title: 'Сдать лабораторную',
      subjectName: 'Физика',
      dueAt: DateTime(2099, 9),
      source: .me,
      isMine: true,
    );
    when(
      () => repository.setDeadlineState(id: deadline.id, done: true),
    ).thenAnswer((_) async {});

    await tester.pumpApp(
      RepositoryProvider<ScheduleRepository>.value(
        value: repository,
        child: Scaffold(body: HomeDeadlineRow(deadline: deadline)),
      ),
    );

    await tester.tap(
      find.byKey(const ValueKey('home-deadline-toggle-home-deadline')),
    );
    await tester.pumpAndSettle();

    verify(
      () => repository.setDeadlineState(id: deadline.id, done: true),
    ).called(1);
  });
}
