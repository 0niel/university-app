import 'package:news_blocks/src/divider_horizontal_block.dart';
import 'package:test/test.dart';

void main() {
  group('DividerHorizontalBlock', () {
    test('can be (de)serialized', () {
      const block = DividerHorizontalBlock();

      expect(DividerHorizontalBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
