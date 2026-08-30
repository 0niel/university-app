import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_item.freezed.dart';
part 'search_item.g.dart';

@freezed
abstract class SearchItem with _$SearchItem {
  const factory SearchItem({
    required int id,
    required String targetTitle,
    required String fullTitle,
    required int scheduleTarget,
    required String iCalLink,
  }) = _SearchItem;

  factory SearchItem.fromJson(Map<String, dynamic> json) =>
      _$SearchItemFromJson(json);
}
