import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SlideshowBlock', () {
    test('can be (de)serialized', () {
      const slide = SlideBlock(
        imageUrl: 'imageUrl',
        caption: 'caption',
        photoCredit: 'photoCredit',
        description: 'description',
      );
      const block = SlideshowBlock(title: 'title', slides: [slide, slide]);

      expect(SlideshowBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
