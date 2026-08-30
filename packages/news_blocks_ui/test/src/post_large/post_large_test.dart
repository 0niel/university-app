import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  const id = '499305f6-5096-4051-afda-824dcfc7df23';
  const category = Category(id: 'technology', name: 'Technology');
  const author = 'Sean Hollister';
  final publishedAt = DateTime(2022, 3, 9);
  const imageUrl =
      'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg='
      '/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset'
      '/file/22049166/shollister_201117_4303_0003.0.jpg';
  const title =
      'Nvidia and AMD GPUs are returning to shelves '
      'and prices are finally falling';

  group('PostLarge', () {
    setUpAll(
      () => setUpTolerantComparator('test/src/post_large/post_large_test.dart'),
    );

    group('renders correctly overlaid ', () {
      testWidgets('showing LockIcon '
          'when isLocked is true', (tester) async {
        final technologyPostLarge = PostLargeBlock(
          id: id,
          categoryId: category.id,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
          isContentOverlaid: true,
        );
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            SingleChildScrollView(
              child: Column(
                children: [
                  PostLarge(
                    block: technologyPostLarge,
                    categoryName: category.name,
                    isLocked: true,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('postLarge_stack')), findsOneWidget);
        expect(find.byType(LockIcon), findsOneWidget);
      });

      testWidgets('not showing LockIcon '
          'when isLocked is false', (tester) async {
        final technologyPostLarge = PostLargeBlock(
          id: id,
          categoryId: category.id,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
          isContentOverlaid: true,
        );
        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            SingleChildScrollView(
              child: Column(
                children: [
                  PostLarge(
                    block: technologyPostLarge,
                    categoryName: category.name,
                    isLocked: false,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('postLarge_stack')), findsOneWidget);
        expect(find.byType(LockIcon), findsNothing);
      });
    });

    group('renders correctly in column ', () {
      testWidgets('showing LockIcon '
          'when isLocked is true', (tester) async {
        final technologyPostLarge = PostLargeBlock(
          id: id,
          categoryId: category.id,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
        );

        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            SingleChildScrollView(
              child: Column(
                children: [
                  PostLarge(
                    block: technologyPostLarge,
                    categoryName: category.name,
                    isLocked: true,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('postLarge_column')), findsOneWidget);
        expect(find.byType(LockIcon), findsOneWidget);
      });

      testWidgets('not showing LockIcon '
          'when isLocked is false', (tester) async {
        final technologyPostLarge = PostLargeBlock(
          id: id,
          categoryId: category.id,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
        );

        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            SingleChildScrollView(
              child: Column(
                children: [
                  PostLarge(
                    block: technologyPostLarge,
                    categoryName: category.name,
                    isLocked: false,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('postLarge_column')), findsOneWidget);
        expect(find.byType(LockIcon), findsNothing);
      });

      testWidgets('uses a neutral source title when metadata is unavailable', (
        tester,
      ) async {
        final post = PostLargeBlock(
          id: id,
          categoryId: category.id,
          author: '',
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
        );

        await mockNetworkImages(
          () => tester.pumpContentThemedApp(
            SingleChildScrollView(
              child: PostLarge(
                block: post,
                categoryName: null,
                isLocked: false,
              ),
            ),
          ),
        );

        expect(find.text('Новости'), findsOneWidget);
      });
    });
  });

  testWidgets('onPressed is called with action when tapped', (tester) async {
    const action = NavigateToArticleAction(articleId: id);
    final actions = <BlockAction>[];

    final technologyPostLarge = PostLargeBlock(
      id: id,
      categoryId: category.id,
      author: author,
      publishedAt: publishedAt,
      imageUrl: imageUrl,
      title: title,
      action: action,
      isContentOverlaid: true,
    );

    await mockNetworkImages(
      () async => tester.pumpContentThemedApp(
        ListView(
          children: [
            PostLarge(
              block: technologyPostLarge,
              categoryName: category.name,
              isLocked: false,
              onPressed: actions.add,
            ),
          ],
        ),
      ),
    );

    await tester.ensureVisible(find.byType(PostLarge));
    await tester.tap(find.byType(PostLarge));

    expect(actions, equals([action]));
  });
}
