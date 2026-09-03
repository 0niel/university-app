import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_quick_actions.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_trending_group.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';

import '../../gallery/gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);

  final services = [
    for (final (path, title) in [
      ('/services/map', 'Карта кампуса'),
      ('/services/free-rooms', 'Свободные аудитории'),
      ('/services/cowork', 'Коворкинг'),
      ('/services/nfc', 'Электронный пропуск'),
      ('/schedule/session', 'Расписание экзаменов'),
    ])
      ServiceEntry(
        model: ServiceModel(
          title: title,
          icon: AppLineIcon.map,
          color: Colors.blue,
          isExternal: false,
          routePath: path,
        ),
        subtitle: '',
      ),
  ];
  const topic = DiscourseTopic(
    id: 1,
    title: 'Кто был на консультации по матанализу? Что задали?',
    postsCount: 25,
    replyCount: 24,
    likeCount: 7,
    views: 120,
    posters: [],
  );

  void setView(WidgetTester tester, double width) {
    tester.view
      ..physicalSize = Size(width, 1200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Widget frame(Widget child) => Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: child,
    ),
  );

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    double width = 390,
    double scale = 1,
  }) async {
    setView(tester, width);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: frame(child),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('quick labels are compact while semantics and routes stay full', (
    tester,
  ) async {
    setView(tester, 390);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => frame(
            HomeQuickActions(services: services, onAll: () {}),
          ),
        ),
        GoRoute(
          path: '/services/map',
          builder: (context, state) => const Scaffold(body: Text('Map target')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();
    for (final label in [
      'Карта',
      'Аудитории',
      'Коворкинг',
      'Пропуск',
      'Экзамены',
    ]) {
      final text = tester.widget<Text>(find.text(label));
      expect(text.maxLines, 1);
      expect(text.style?.fontSize, 10.5);
      expect(tester.getSize(find.text(label)).height, closeTo(12.6, 1));
    }
    final semantics = tester.ensureSemantics();
    try {
      await tester.pump();
      expect(find.bySemanticsLabel('Карта кампуса'), findsOneWidget);
      expect(find.bySemanticsLabel('Свободные аудитории'), findsOneWidget);
    } finally {
      semantics.dispose();
    }
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Карта'));
    await tester.pumpAndSettle();
    expect(find.text('Map target'), findsOneWidget);
  });

  testWidgets('quick actions keep adaptive labels at 320px and 200% text', (
    tester,
  ) async {
    await pump(
      tester,
      HomeQuickActions(services: services, onAll: () {}),
      width: 320,
      scale: 2,
    );
    expect(tester.takeException(), isNull);
    expect(tester.widget<Text>(find.text('Аудитории')).maxLines, 3);
    expect(
      tester.getTopLeft(find.text('Пропуск')).dy,
      greaterThan(tester.getBottomLeft(find.text('Карта')).dy),
    );
  });

  for (final (width, scale) in [(390.0, 1.0), (320.0, 2.0)]) {
    testWidgets(
      'trending wraps full topic at $width and ${scale * 100}% text',
      (
        tester,
      ) async {
        DiscourseTopic? opened;
        await pump(
          tester,
          HomeTrendingGroup(
            state: const DiscourseState(
              status: DiscourseStatus.loaded,
              topTopics: TopTopicsResponse(topics: [topic], users: []),
            ),
            onAll: () {},
            onOpen: (topic) => opened = topic,
            onRetry: () {},
          ),
          width: width,
          scale: scale,
        );
        final title = tester.widget<Text>(find.text(topic.title));
        expect(title.maxLines, isNull);
        expect(title.style?.fontSize, 14.5);
        expect(title.style?.height, 1.3);
        expect(title.style?.fontWeight, FontWeight.w600);
        final meta = tester.widget<Text>(find.text('24 ответа'));
        expect(meta.style?.fontSize, 12.5);
        expect(meta.style?.fontWeight, FontWeight.w400);
        final paragraph = tester.renderObject<RenderParagraph>(
          find.descendant(
            of: find.text(topic.title),
            matching: find.byType(RichText),
          ),
        );
        expect(paragraph.didExceedMaxLines, isFalse);
        final lines = paragraph
            .getBoxesForSelection(
              TextSelection(baseOffset: 0, extentOffset: topic.title.length),
            )
            .map((box) => box.top)
            .toSet();
        expect(lines.length, greaterThan(1));
        expect(tester.takeException(), isNull);
        await tester.tap(find.text(topic.title));
        expect(opened, same(topic));
      },
    );
  }
}
