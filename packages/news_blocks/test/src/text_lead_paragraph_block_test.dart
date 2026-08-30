import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('TextLeadParagraphBlock', () {
    test('can be (de)serialized', () {
      const block = TextLeadParagraphBlock(text: 'Text Lead Paragraph');

      expect(TextLeadParagraphBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
