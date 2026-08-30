import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lost_and_found_repository/src/models/lost_found_item_status.dart';

part 'lost_found_item.freezed.dart';
part 'lost_found_item.g.dart';

@freezed
abstract class LostFoundItem with _$LostFoundItem {
  const factory LostFoundItem({
    required String id,
    required String authorId,
    required String itemName,
    required LostFoundItemStatus status,
    required DateTime createdAt,
    @Default('') String authorName,
    String? description,
    @Default('other') String category,
    @Default('') String location,
    @JsonKey(name: 'images') @Default(<String>[]) List<String> imagePaths,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(<String>[])
    List<String> imageUrls,
    @Default(false) bool showContact,
    String? telegramContactInfo,
    String? phoneNumberContactInfo,
    @Default(false) bool isMine,
  }) = _LostFoundItem;

  const LostFoundItem._();

  factory LostFoundItem.fromJson(Map<String, Object?> json) =>
      _$LostFoundItemFromJson(json);

  List<String> get images => imageUrls.isEmpty ? imagePaths : imageUrls;
}
