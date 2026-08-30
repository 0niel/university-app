import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostContent', () {
    testWidgets('renders correctly with title', (tester) async {
      const testPostContent = PostContent(title: 'title');

      await tester.pumpContentThemedApp(testPostContent);

      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('renders category when content is overlaid', (tester) async {
      const testPostContent = PostContent(
        title: 'title',
        categoryName: 'categoryName',
        isContentOverlaid: true,
      );

      await tester.pumpContentThemedApp(testPostContent);

      expect(find.byType(PostContentCategory), findsOneWidget);
    });

    testWidgets('does not render category when content is not overlaid', (
      tester,
    ) async {
      const testPostContent = PostContent(
        title: 'title',
        categoryName: 'categoryName',
      );

      await tester.pumpContentThemedApp(testPostContent);

      expect(find.byType(PostContentCategory), findsNothing);
    });

    group('renders PostTimestamp', () {
      testWidgets('when author provided', (tester) async {
        const testPostContent = PostContent(title: 'title', author: 'author');

        await tester.pumpContentThemedApp(testPostContent);

        expect(find.byType(PostTimestamp), findsOneWidget);
      });

      testWidgets('when publishedAt provided', (tester) async {
        final testPostContent = PostContent(
          title: 'title',
          publishedAt: DateTime(2000, 12, 31),
        );

        await tester.pumpContentThemedApp(testPostContent);

        expect(find.byType(PostTimestamp), findsOneWidget);
      });

      testWidgets('when onShare provided', (tester) async {
        final testPostContent = PostContent(
          title: 'title',
          publishedAt: DateTime(2000, 12, 31),
          onShare: () {},
        );

        await tester.pumpContentThemedApp(testPostContent);

        expect(find.byType(PostTimestamp), findsOneWidget);
      });
    });
  });
}
