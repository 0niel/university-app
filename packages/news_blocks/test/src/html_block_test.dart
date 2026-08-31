import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('HtmlBlock', () {
    test('can be (de)serialized', () {
      const block = HtmlBlock(content: '<p>hello world</p>');

      expect(HtmlBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
