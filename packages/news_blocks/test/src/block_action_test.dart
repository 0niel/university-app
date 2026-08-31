import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

class CustomBlockAction extends BlockAction {
  CustomBlockAction()
    : super(type: '__custom_block__', actionType: BlockActionType.navigation);

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'type': type};
}

void main() {
  group('BlockAction', () {
    test('can be extended', () {
      expect(CustomBlockAction.new, returnsNormally);
    });

    group('fromJson', () {
      test('returns UnknownBlockAction when type is missing', () {
        expect(
          BlockAction.fromJson(<String, dynamic>{}),
          equals(const UnknownBlockAction()),
        );
      });

      test('returns UnknownBlockAction when type is unrecognized', () {
        expect(
          BlockAction.fromJson(<String, dynamic>{'type': 'unrecognized'}),
          equals(const UnknownBlockAction()),
        );
      });

      test('returns NavigateToArticleAction', () {
        const action = NavigateToArticleAction(articleId: 'articleId');
        expect(BlockAction.fromJson(action.toJson()), equals(action));
      });

      test('returns NavigateToVideoArticleAction', () {
        const action = NavigateToVideoArticleAction(articleId: 'articleId');
        expect(BlockAction.fromJson(action.toJson()), equals(action));
      });

      test('returns NavigateToFeedCategoryAction', () {
        const category = Category(id: 'sports', name: 'Sports');

        const action = NavigateToFeedCategoryAction(category: category);
        expect(BlockAction.fromJson(action.toJson()), equals(action));
      });

      test('returns NavigateToSlideshowAction', () {
        const action = NavigateToSlideshowAction(
          articleId: 'articleId',
          slideshow: SlideshowBlock(title: 'title', slides: []),
        );
        expect(BlockAction.fromJson(action.toJson()), equals(action));
      });
    });

    group('UnknownBlockAction', () {
      test('can be (de)serialized', () {
        const action = UnknownBlockAction();
        expect(UnknownBlockAction.fromJson(action.toJson()), equals(action));
      });
    });

    group('NavigateToArticleAction', () {
      test('can be (de)serialized', () {
        const action = NavigateToArticleAction(articleId: 'articleId');
        expect(
          NavigateToArticleAction.fromJson(action.toJson()),
          equals(action),
        );
      });
    });

    group('NavigateToVideoArticleAction', () {
      test('can be (de)serialized', () {
        const action = NavigateToVideoArticleAction(articleId: 'articleId');
        expect(
          NavigateToVideoArticleAction.fromJson(action.toJson()),
          equals(action),
        );
      });
    });

    group('NavigateToFeedCategoryAction', () {
      test('can be (de)serialized', () {
        const category = Category(id: 'sports', name: 'Sports');

        const action = NavigateToFeedCategoryAction(category: category);
        expect(
          NavigateToFeedCategoryAction.fromJson(action.toJson()),
          equals(action),
        );
      });
    });

    group('NavigateToSlideshowAction', () {
      test('can be (de)serialized', () {
        const action = NavigateToSlideshowAction(
          articleId: 'articleId',
          slideshow: SlideshowBlock(title: 'title', slides: []),
        );
        expect(
          NavigateToSlideshowAction.fromJson(action.toJson()),
          equals(action),
        );
      });
    });
  });
}
