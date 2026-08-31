import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_views.freezed.dart';

@freezed
abstract class ArticleViews with _$ArticleViews {
  const factory ArticleViews({
    required int views,
    required DateTime? resetAt,
  }) = _ArticleViews;
}
