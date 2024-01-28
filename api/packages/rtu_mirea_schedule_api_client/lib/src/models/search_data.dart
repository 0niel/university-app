import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rtu_mirea_schedule_api_client/src/models/search_item.dart';

part 'search_data.g.dart';

/// {@template search_data}
/// The search data.
/// {@endtemplate}
@JsonSerializable()
class SearchData extends Equatable {
  /// {@macro search_data}
  const SearchData({
    required this.data,
  });

  /// Converts a `Map<String, dynamic>` into a [SearchData] instance.
  factory SearchData.fromJson(Map<String, dynamic> json) => _$SearchDataFromJson(json);

  /// The search data results.
  final List<SearchItem> data;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$SearchDataToJson(this);

  @override
  List<Object> get props => [data];
}
