import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('TextHeadlineBlock', () {
    test('can be (de)serialized', () {
      const block = TextHeadlineBlock(text: 'Title');

      expect(TextHeadlineBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
