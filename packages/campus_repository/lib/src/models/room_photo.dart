import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_photo.freezed.dart';
part 'room_photo.g.dart';

@freezed
abstract class RoomPhoto with _$RoomPhoto {
  const factory RoomPhoto({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String path,
    @JsonKey(defaultValue: '') required String createdBy,
    @JsonKey(
      fromJson: requiredDateTimeFromJson,
      toJson: requiredDateTimeToJson,
    )
    required DateTime createdAt,
    int? width,
    int? height,
    @Default('') String authorName,
    @Default(false) bool isMine,
    @Default('') String url,
  }) = _RoomPhoto;

  factory RoomPhoto.fromJson(Map<String, Object?> json) =>
      _$RoomPhotoFromJson(json);
}
