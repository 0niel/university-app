import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:university_app_server_api/src/data/lost_and_found/models/lost_and_found_item.dart';

part 'lost_found_items_response.g.dart';

@JsonSerializable()
class LostFoundItemsResponse extends Equatable {
  const LostFoundItemsResponse({
    required this.items,
  });

  factory LostFoundItemsResponse.fromJson(Map<String, dynamic> json) => _$LostFoundItemsResponseFromJson(json);

  final List<LostFoundItem> items;

  Map<String, dynamic> toJson() => _$LostFoundItemsResponseToJson(this);

  @override
  List<Object> get props => [items];
}
