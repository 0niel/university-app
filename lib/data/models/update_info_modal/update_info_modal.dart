import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_info_modal.freezed.dart';
part 'update_info_modal.g.dart';

@freezed
class UpdateInfoModal with _$UpdateInfoModal {
  const factory UpdateInfoModal({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'text') required String changeLog,
    @JsonKey(name: 'appVersion') required String serverVersion,
  }) = _UpdateInfoModal;

  factory UpdateInfoModal.fromJson(Map<String, dynamic> json) =>
      _$UpdateInfoModalFromJson(json);
}
