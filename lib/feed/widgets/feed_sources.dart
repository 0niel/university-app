import 'package:collection/collection.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/categories/categories.dart';

const feedAllCategoryId = 'all';

String feedSourceKey(NewsSourceItem source) =>
    newsCategoryKey(source.sourceType, source.sourceId);

String feedSourceName(NewsSourceItem source) =>
    source.sourceName.trim().isEmpty ? source.sourceId : source.sourceName;

NewsSourceItem? feedSourceById(List<NewsSourceItem> sources, String id) =>
    sources.firstWhereOrNull(
      (source) => source.sourceId == id || feedSourceKey(source) == id,
    );

NewsSourceItem? feedSourceByKey(List<NewsSourceItem> sources, String key) =>
    sources.firstWhereOrNull((source) => feedSourceKey(source) == key);

Category feedCategoryFor(
  CategoriesState state, {
  required String id,
  required String name,
}) =>
    state.categories?.firstWhereOrNull((category) => category.id == id) ??
    Category(id: id, name: name);

List<PostBlock> feedPosts(Iterable<NewsBlock>? blocks) =>
    blocks?.whereType<PostBlock>().toList() ?? const <PostBlock>[];
