import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/src/models/news_feed_item.dart';

part 'categories_response.freezed.dart';

@freezed
abstract class CategoriesResponse with _$CategoriesResponse {
  const factory CategoriesResponse({
    required List<Category> categories,
    @Default(<NewsSourceItem>[]) List<NewsSourceItem> sources,
  }) = _CategoriesResponse;
}
