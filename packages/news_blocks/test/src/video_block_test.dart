import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('VideoBlock', () {
    test('can be (de)serialized', () {
      const block = VideoBlock(videoUrl: 'videoUrl');
      expect(VideoBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
