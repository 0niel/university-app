import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SpacerBlock', () {
    test('can be (de)serialized', () {
      const block = SpacerBlock(spacing: Spacing.medium);

      expect(SpacerBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
