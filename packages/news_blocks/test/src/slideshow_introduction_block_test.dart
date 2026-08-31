import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SlideshowIntroductionBlock', () {
    test('can be (de)serialized', () {
      const block = SlideshowIntroductionBlock(
        title: 'title',
        coverImageUrl: 'coverImageUrl',
      );

      expect(
        SlideshowIntroductionBlock.fromJson(block.toJson()),
        equals(block),
      );
    });
  });
}
