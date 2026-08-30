// Freezed applies json_serializable options to its factory constructor.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_schedule_api_client/src/models/search_item.dart';

part 'search_data.freezed.dart';
part 'search_data.g.dart';

@freezed
abstract class SearchData with _$SearchData {
  @JsonSerializable(explicitToJson: true)
  const factory SearchData({required List<SearchItem> data}) = _SearchData;

  factory SearchData.fromJson(Map<String, dynamic> json) =>
      _$SearchDataFromJson(json);
}
