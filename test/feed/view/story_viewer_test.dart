import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/bloc/feed_bloc.dart';
import 'package:rtu_mirea_app/feed/view/story_viewer/story_viewer_page.dart';

import '../../helpers/pump_app.dart';

class _Feed extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

class _Categories extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  late FeedBloc feed;
  late CategoriesBloc categories;

  setUpAll(() {
    registerFallbackValue(
      const FeedRequested(
        category: Category(id: 'science', name: 'science'),
      ),
    );
  });

  setUp(() {
    feed = _Feed();
    categories = _Categories();
    when(() => categories.state).thenReturn(const CategoriesState());
  });

  Widget subject({bool reducedMotion = false}) => MultiBlocProvider(
    providers: [
      BlocProvider<FeedBloc>.value(value: feed),
      BlocProvider<CategoriesBloc>.value(value: categories),
    ],
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: reducedMotion,
        ),
        child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => unawaited(
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const StoryViewerPage(
                        sourceId: 'science',
                        slideDuration: Duration(seconds: 1),
                      ),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('pending stories remain closable and request the source once', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(const FeedState(status: .loading));
    await tester.pumpApp(subject());
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const Key('storyViewer_pending')), findsOneWidget);
    expect(find.byType(NinjaSpinner), findsNothing);
    verify(() => feed.add(any(that: isA<FeedRequested>()))).called(1);
    await tester.tap(find.byKey(const Key('storyViewer_close')));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Open'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed stories show retry instead of reporting empty content', (
    tester,
  ) async {
    when(
      () => feed.state,
    ).thenReturn(const FeedState(status: .failure, feed: {'science': []}));
    await tester.pumpApp(subject());
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const Key('storyViewer_failure')), findsOneWidget);
    expect(find.byKey(const Key('storyViewer_empty')), findsNothing);
    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.byKey(const Key('storyViewer_close')), findsOneWidget);
    await tester.tap(find.text('Повторить'));
    verify(() => feed.add(any(that: isA<FeedRequested>()))).called(1);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const Key('storyViewer_close')));
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('reduced motion keeps stories manual at 320px and 200 percent', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(
      FeedState(
        status: .populated,
        feed: {
          'science': [
            for (final id in ['first', 'second'])
              PostMediumBlock(
                id: id,
                categoryId: 'science',
                author: 'Наука',
                publishedAt: DateTime(2026),
                imageUrl: '',
                title: id,
              ),
          ],
        },
      ),
    );
    await tester.pumpApp(
      subject(reducedMotion: true),
      size: const Size(320, 800),
      textScaler: const TextScaler.linear(2),
    );
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 3));
    expect(
      find.byKey(const ValueKey('storyViewer_slide_first')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('storyViewer_nextZone')));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('storyViewer_slide_second')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('story uses a continuous scrim and a forty pixel close surface', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(
      FeedState(
        status: .populated,
        feed: {
          'science': [
            PostMediumBlock(
              id: 'one',
              categoryId: 'science',
              author: 'Наука',
              publishedAt: DateTime(2026),
              imageUrl: '',
              title: 'Новый коворкинг для студентов',
            ),
          ],
        },
      ),
    );
    await tester.pumpApp(
      subject(reducedMotion: true),
      size: const Size(390, 844),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final scrim = tester.widget<DecoratedBox>(
      find.byKey(const Key('storyViewer_scrim')),
    );
    final gradient =
        (scrim.decoration as BoxDecoration).gradient! as LinearGradient;
    expect(gradient.stops, [0, .3, .55, 1]);
    final stripes = tester.widget<AppStripePlaceholder>(
      find.byType(AppStripePlaceholder),
    );
    expect(stripes.stripe, AppColors.dark.surface);
    expect(stripes.base, AppColors.dark.surface2);
    expect(stripes.stripeWidth, 12);
    expect(
      gradient.colors.map((color) => color.a),
      orderedEquals([140 / 255, 0, 0, 191 / 255]),
    );
    expect(
      tester.getSize(find.byKey(const Key('storyViewer_closeSurface'))),
      const Size(40, 40),
    );
    expect(
      tester.getSize(find.byKey(const Key('storyViewer_close'))),
      const Size(44, 44),
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('storyViewer_closeSurface'))).dy,
      69,
    );
    expect(find.byType(AppBalancedText), findsOneWidget);
    await tester.tap(find.byKey(const Key('storyViewer_close')));
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('long story copy scrolls without hiding the read action', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(
      FeedState(
        status: .populated,
        feed: {
          'science': [
            PostMediumBlock(
              id: 'long',
              categoryId: 'science',
              author: 'Наука',
              publishedAt: DateTime(2026),
              imageUrl: '',
              title: List.filled(12, 'Длинный заголовок истории').join(' '),
              description: List.filled(
                20,
                'Подробности университетского события.',
              ).join(' '),
            ),
          ],
        },
      ),
    );
    await tester.pumpApp(
      subject(reducedMotion: true),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 400));
    final scroll = find.descendant(
      of: find.byKey(const Key('storyViewer_content')),
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(scroll).position;
    expect(position.maxScrollExtent, greaterThan(0));
    await tester.drag(
      find.byKey(const Key('storyViewer_content')),
      const Offset(0, -100),
    );
    await tester.pump();
    expect(position.pixels, greaterThan(0));
    expect(
      tester.getRect(find.byKey(const Key('storyViewer_read'))).bottom,
      lessThanOrEqualTo(528),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const Key('storyViewer_read')));
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('dragging down dismisses the story without advancing it', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(
      FeedState(
        status: .populated,
        feed: {
          'science': [
            PostMediumBlock(
              id: 'drag',
              categoryId: 'science',
              author: 'Наука',
              publishedAt: DateTime(2026),
              imageUrl: '',
              title: 'Story',
            ),
          ],
        },
      ),
    );
    await tester.pumpApp(subject(reducedMotion: true));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.dragFrom(const Offset(200, 150), const Offset(0, 180));
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
    expect(find.byKey(const Key('storyViewer_dismiss')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('holding a story pauses its timer', (tester) async {
    when(() => feed.state).thenReturn(
      FeedState(
        status: .populated,
        feed: {
          'science': [
            for (final id in ['hold', 'next'])
              PostMediumBlock(
                id: id,
                categoryId: 'science',
                author: 'Наука',
                publishedAt: DateTime(2026),
                imageUrl: '',
                title: id,
              ),
          ],
        },
      ),
    );
    await tester.pumpApp(subject());
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 400));
    final gesture = await tester.startGesture(const Offset(200, 150));
    await tester.pump(const Duration(seconds: 2));
    expect(
      find.byKey(const ValueKey('storyViewer_slide_hold')),
      findsOneWidget,
    );
    await gesture.cancel();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump(const Duration(milliseconds: 200));
    expect(
      find.byKey(const ValueKey('storyViewer_slide_next')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('story header shows the source name next to a relative time', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(
      FeedState(
        status: .populated,
        feed: {
          'science': [
            PostMediumBlock(
              id: 'meta',
              categoryId: 'science',
              author: 'Наука',
              publishedAt: DateTime(2026),
              imageUrl: '',
              title: 'Событие',
            ),
          ],
        },
      ),
    );
    await tester.pumpApp(subject(reducedMotion: true));
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 400));
    final header = tester.widget<Text>(
      find.byKey(const Key('storyViewer_headerName')),
    );
    final span = header.textSpan! as TextSpan;
    expect(span.children, hasLength(2));
    expect((span.children!.first as TextSpan).text, 'Наука');
    expect((span.children!.last as TextSpan).text, contains('·'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a story without an image renders only the striped backdrop', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(
      FeedState(
        status: .populated,
        feed: {
          'science': [
            PostMediumBlock(
              id: 'no-image',
              categoryId: 'science',
              author: 'Наука',
              publishedAt: DateTime(2026),
              imageUrl: '',
              title: 'Story',
            ),
          ],
        },
      ),
    );
    await tester.pumpApp(subject(reducedMotion: true));
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(ImageFiltered), findsNothing);
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(find.byType(AppStripePlaceholder), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide viewports show a centered nine by sixteen column', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(
      FeedState(
        status: .populated,
        feed: {
          'science': [
            PostMediumBlock(
              id: 'desktop',
              categoryId: 'science',
              author: 'Наука',
              publishedAt: DateTime(2026),
              imageUrl: '',
              title: 'Desktop story',
            ),
          ],
        },
      ),
    );
    await tester.pumpApp(
      subject(reducedMotion: true),
      size: const Size(900, 700),
    );
    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 400));
    final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
    expect(aspectRatio.aspectRatio, 9 / 16);
    expect(tester.takeException(), isNull);
  });
}
