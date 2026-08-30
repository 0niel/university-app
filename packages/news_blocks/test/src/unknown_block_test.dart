import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('UnknownBlock', () {
    test('can be (de)serialized', () {
      const block = UnknownBlock();
      expect(UnknownBlock.fromJson(block.toJson()), equals(block));
    });

    test('preserves a future block payload', () {
      final block = UnknownBlock.fromJson({
        'type': '__future_block__',
        'payload': {'title': 'New university content'},
      });

      expect(block.type, '__future_block__');
      expect(block.toJson(), {
        'type': '__future_block__',
        'payload': {'title': 'New university content'},
      });
    });
  });
}
