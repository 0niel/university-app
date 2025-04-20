import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lost_and_found_item.g.dart';

enum LostFoundItemStatus { lost, found }

@JsonSerializable()
class LostFoundItem extends Equatable {
  const LostFoundItem({
    required this.authorId,
    required this.itemName,
    required this.authorEmail,
    required this.createdAt,
    required this.status,
    this.id,
    this.description,
    this.telegramContactInfo,
    this.phoneNumberContactInfo,
    this.updatedAt,
    this.images,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) => _$LostFoundItemFromJson(json);

  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'author_id')
  final String authorId;

  @JsonKey(name: 'item_name')
  final String itemName;

  @JsonKey(name: 'author_email')
  final String authorEmail;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final LostFoundItemStatus status;

  final String? description;

  @JsonKey(name: 'telegram_contact_info')
  final String? telegramContactInfo;

  @JsonKey(name: 'phone_number_contact_info')
  final String? phoneNumberContactInfo;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  final List<String>? images;

  Map<String, dynamic> toJson() => _$LostFoundItemToJson(this);

  @override
  List<Object?> get props => [
        id,
        authorId,
        itemName,
        authorEmail,
        createdAt,
        status,
        description,
        telegramContactInfo,
        phoneNumberContactInfo,
        updatedAt,
        images,
      ];
}

LostFoundItemStatus _statusFromJson(String status) {
  return LostFoundItemStatus.values.firstWhere((e) => e.toString().split('.').last == status);
}

String _statusToJson(LostFoundItemStatus status) {
  return status.toString().split('.').last;
}
