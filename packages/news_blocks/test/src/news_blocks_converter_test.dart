import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('NewsBlocksConverter', () {
    test('can (de)serialize List<NewsBlock>', () {
      const converter = NewsBlocksConverter();
      const category = Category(id: 'health', name: 'Health');
      final newsBlocks = <NewsBlock>[
        const SectionHeaderBlock(title: 'title'),
        const DividerHorizontalBlock(),
        const SpacerBlock(spacing: Spacing.medium),
        PostSmallBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 11),
          imageUrl: 'imageUrl',
          title: 'title',
          description: 'description',
        ),
      ];

      expect(
        converter.fromJson(converter.toJson(newsBlocks)),
        equals(newsBlocks),
      );
    });
  });
}
