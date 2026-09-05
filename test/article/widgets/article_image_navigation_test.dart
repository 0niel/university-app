import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/article/widgets/article_html.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_image.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: NinjaToastHost(
    child: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

void main() {
  testWidgets('article link taps launch resolved URLs externally', (
    tester,
  ) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    MethodCall? launched;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      launched = call;
      return true;
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    await tester.pumpWidget(
      _wrap(
        ArticleHtml(
          sourceUri: Uri.parse('https://example.com/news/article'),
          content: '<a href="../other#section">Read more</a>',
        ),
      ),
    );
    await tester.tapOnText(find.textRange.ofSubstring('Read more'));
    await tester.pump();
    expect(launched?.method, 'launch');
    expect(
      launched?.arguments,
      containsPair('url', 'https://example.com/other#section'),
    );
    expect(launched?.arguments, containsPair('useWebView', false));
  });

  testWidgets('failed links show feedback instead of silently doing nothing', (
    tester,
  ) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => false,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    await tester.pumpWidget(
      _wrap(
        const ArticleHtml(
          content: '<a href="https://example.com">Read more</a>',
        ),
      ),
    );
    await tester.tapOnText(find.textRange.ofSubstring('Read more'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final l10n = tester.element(find.byType(ArticleHtml)).l10n;
    expect(find.text(l10n.error), findsOneWidget);
  });

  testWidgets('HTML image opens the full gallery at the tapped image', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        ArticleHtml(
          sourceUri: Uri.parse('https://example.com/news/article'),
          content: '<img src="/a.png"><img src="/b.png">',
        ),
      ),
    );
    await tester.pump();
    final images = find.byType(FeedImage);
    expect(images, findsNWidgets(2));
    await tester.tap(images.at(1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final viewer = tester.widget<MediaViewerPage>(find.byType(MediaViewerPage));
    expect(viewer.initialIndex, 1);
    expect(viewer.items.map((item) => item.url), [
      'https://example.com/a.png',
      'https://example.com/b.png',
    ]);
    expect(viewer.items[1].heroTag, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('duplicate feed image URLs use distinct Hero tags', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Column(
          children: [
            FeedImage(
              imageUrl: 'https://example.com/a.png',
              radius: 12,
              height: 120,
            ),
            FeedImage(
              imageUrl: 'https://example.com/a.png',
              radius: 12,
              height: 120,
            ),
          ],
        ),
      ),
    );
    final heroes = tester.widgetList<Hero>(find.byType(Hero)).toList();
    expect(heroes, hasLength(2));
    expect(heroes[0].tag, isNot(heroes[1].tag));
    await tester.tap(find.byType(FeedImage).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(MediaViewerPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
