import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

class CustomBlock extends NewsBlock {
  const CustomBlock({super.type = '__custom_block__'});

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'type': type};
}

void main() {
  group('NewsBlock', () {
    test('can be extended', () {
      expect(CustomBlock.new, returnsNormally);
    });

    group('fromJson', () {
      test('returns UnknownBlock when type is missing', () {
        expect(
          NewsBlock.fromJson(<String, dynamic>{}),
          equals(const UnknownBlock()),
        );
      });

      test('returns UnknownBlock when type is unrecognized', () {
        final block = NewsBlock.fromJson(<String, dynamic>{
          'type': 'unrecognized',
          'version': 2,
        });

        expect(block, isA<UnknownBlock>());
        expect(block.toJson(), {'type': 'unrecognized', 'version': 2});
      });

      test('returns SectionHeaderBlock', () {
        const block = SectionHeaderBlock(title: 'Example');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns DividerHorizontalBlock', () {
        const block = DividerHorizontalBlock();
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns SpacerBlock', () {
        const block = SpacerBlock(spacing: Spacing.medium);
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TextCaptionBlock', () {
        const block = TextCaptionBlock(
          text: 'Text caption',
          color: TextCaptionColor.light,
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TextHeadlineBlock', () {
        const block = TextHeadlineBlock(text: 'Text Headline');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TextLeadParagraphBlock', () {
        const block = TextLeadParagraphBlock(text: 'Text Lead Paragraph');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TextParagraphBlock', () {
        const block = TextParagraphBlock(text: 'Text Paragraph');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns ImageBlock', () {
        const block = ImageBlock(imageUrl: 'imageUrl');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns VideoBlock', () {
        const block = VideoBlock(videoUrl: 'videoUrl');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns VideoIntroductionBlock', () {
        const category = Category(id: 'technology', name: 'Technology');
        final block = VideoIntroductionBlock(
          categoryId: category.id,
          title: 'title',
          videoUrl: 'videoUrl',
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns ArticleIntroductionBlock', () {
        const category = Category(id: 'technology', name: 'Technology');
        final block = ArticleIntroductionBlock(
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 9),
          imageUrl: 'imageUrl',
          title: 'title',
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostLargeBlock', () {
        const category = Category(id: 'technology', name: 'Technology');
        final block = PostLargeBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 9),
          imageUrl: 'imageUrl',
          title: 'title',
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostMediumBlock', () {
        const category = Category(id: 'sports', name: 'Sports');
        final block = PostMediumBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 10),
          imageUrl: 'imageUrl',
          title: 'title',
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostSmallBlock', () {
        const category = Category(id: 'health', name: 'Health');
        final block = PostSmallBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 11),
          imageUrl: 'imageUrl',
          title: 'title',
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostGridGroupBlock', () {
        const category = Category(id: 'science', name: 'Science');
        final block = PostGridGroupBlock(
          categoryId: category.id,
          tiles: [
            PostGridTileBlock(
              id: 'id',
              categoryId: category.id,
              author: 'author',
              publishedAt: DateTime(2022, 3, 12),
              imageUrl: 'imageUrl',
              title: 'title',
            ),
          ],
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostGridTileBlock', () {
        const category = Category(id: 'science', name: 'Science');
        final block = PostGridTileBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 12),
          imageUrl: 'imageUrl',
          title: 'title',
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns NewsletterBlock', () {
        const block = NewsletterBlock();

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns BannerAdBlock', () {
        const block = BannerAdBlock(size: BannerSize.normal);
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns HtmlBlock', () {
        const block = HtmlBlock(content: '<p>hello</p>');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns SlideBlock', () {
        const block = SlideBlock(
          imageUrl: 'imageUrl',
          caption: 'caption',
          photoCredit: 'photoCredit',
          description: 'description',
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns SlideshowBlock', () {
        const slide = SlideBlock(
          imageUrl: 'imageUrl',
          caption: 'caption',
          photoCredit: 'photoCredit',
          description: 'description',
        );
        const block = SlideshowBlock(title: 'title', slides: [slide]);
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns SlideshowIntroductionBlock', () {
        const block = SlideshowIntroductionBlock(
          title: 'title',
          coverImageUrl: 'coverImageUrl',
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TrendingStoryBlock', () {
        const category = Category(id: 'health', name: 'Health');
        final content = PostSmallBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 11),
          imageUrl: 'imageUrl',
          title: 'title',
        );
        final block = TrendingStoryBlock(content: content);
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });
    });
  });
}
