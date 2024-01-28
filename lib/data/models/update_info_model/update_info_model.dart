import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_info_model.freezed.dart';
part 'update_info_model.g.dart';

@freezed
class UpdateInfoModel with _$UpdateInfoModel {
  const factory UpdateInfoModel({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'description') required String? description,
    @JsonKey(name: 'text') required String text,
    @JsonKey(name: 'appVersion') required String appVersion,
    @JsonKey(name: 'buildNumber') required int buildNumber,
  }) = _UpdateInfoModel;

  factory UpdateInfoModel.fromJson(Map<String, dynamic> json) => _$UpdateInfoModelFromJson(json);
}
