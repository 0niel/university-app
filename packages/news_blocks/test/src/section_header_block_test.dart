import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SectionHeaderBlock', () {
    test('can be (de)serialized', () {
      const category = Category(id: 'sports', name: 'Sports');

      const action = NavigateToFeedCategoryAction(category: category);
      const block = SectionHeaderBlock(title: 'example_title', action: action);
      expect(SectionHeaderBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
