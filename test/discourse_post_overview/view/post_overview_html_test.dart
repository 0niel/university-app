import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_html.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_image.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Widget _wrap(String data) => MaterialApp(
  theme: AppTheme.lightTheme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SingleChildScrollView(
      child: PostOverviewHtml(
        data: data,
        sourceUri: Uri.parse('https://forum.example.edu/t/42'),
      ),
    ),
  ),
);

void main() {
  testWidgets('lightbox opens originals while rendering optimized thumbnails', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        '<a class="lightbox" href="/uploads/original.jpg"><img src="/uploads/optimized.jpg"></a> '
        '<a href="/uploads/second.PNG?size=full"><img src="/uploads/second-small.png"></a>',
      ),
    );
    await tester.pump();
    expect(
      tester
          .widget<CachedNetworkImage>(find.byType(CachedNetworkImage).first)
          .imageUrl,
      'https://forum.example.edu/uploads/optimized.jpg',
    );
    await tester.tap(find.byType(FeedImage).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final viewer = tester.widget<MediaViewerPage>(find.byType(MediaViewerPage));
    expect(viewer.items.map((item) => item.url), [
      'https://forum.example.edu/uploads/original.jpg',
      'https://forum.example.edu/uploads/second.PNG?size=full',
    ]);
    expect(viewer.initialIndex, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a thumbnail linking to a page keeps its author link action', (
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
      _wrap('<a href="/t/100"><img src="/uploads/thumbnail.png"></a>'),
    );
    await tester.pump();
    await tester.tap(find.byType(FeedImage));
    await tester.pump();
    expect(
      launched?.arguments,
      containsPair('url', 'https://forum.example.edu/t/100'),
    );
    expect(find.byType(MediaViewerPage), findsNothing);
  });

  testWidgets('forum HTML retains tables and opens relative links', (
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
        '<table><tr><td>Schedule</td></tr></table><a href="../other#reply">Open topic</a>',
      ),
    );
    expect(find.text('Schedule', findRichText: true), findsOneWidget);
    await tester.tapOnText(find.textRange.ofSubstring('Open topic'));
    await tester.pump();
    expect(launched?.method, 'launch');
    expect(
      launched?.arguments,
      containsPair('url', 'https://forum.example.edu/other#reply'),
    );
  });

  testWidgets('forum photos open together at the selected attachment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap('<img src="/uploads/a.png"><img src="/uploads/b.png">'),
    );
    await tester.pump();
    final image = find.byType(FeedImage).at(1);
    await tester.ensureVisible(image);
    await tester.tap(image);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final viewer = tester.widget<MediaViewerPage>(find.byType(MediaViewerPage));
    expect(viewer.initialIndex, 1);
    expect(viewer.items.map((item) => item.url), [
      'https://forum.example.edu/uploads/a.png',
      'https://forum.example.edu/uploads/b.png',
    ]);
    expect(tester.takeException(), isNull);
  });
}
