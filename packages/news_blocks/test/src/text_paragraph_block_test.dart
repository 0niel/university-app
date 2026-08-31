import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('TextParagraphBlock', () {
    test('can be (de)serialized', () {
      const block = TextParagraphBlock(text: 'Paragraph text');

      expect(TextParagraphBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
