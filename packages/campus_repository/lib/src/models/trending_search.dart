import 'package:freezed_annotation/freezed_annotation.dart';

part 'trending_search.freezed.dart';
part 'trending_search.g.dart';

@freezed
abstract class TrendingSearch with _$TrendingSearch {
  const factory TrendingSearch({
    @JsonKey(defaultValue: '') required String query,
    @Default(0) int count,
  }) = _TrendingSearch;

  factory TrendingSearch.fromJson(Map<String, Object?> json) =>
      _$TrendingSearchFromJson(json);
}
