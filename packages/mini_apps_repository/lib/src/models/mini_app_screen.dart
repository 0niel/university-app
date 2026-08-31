import 'package:freezed_annotation/freezed_annotation.dart';

part 'mini_app_screen.freezed.dart';
part 'mini_app_screen.g.dart';

@freezed
/// A remotely hosted mini-app screen and its widget JSON.
abstract class MiniAppScreen with _$MiniAppScreen {
  /// Creates a screen payload for the mini-app API.
  const factory MiniAppScreen({
    @JsonKey(includeToJson: false) String? id,
    @Default('/') String path,
    @JsonKey(includeIfNull: false) String? title,
    @Default(<String, dynamic>{}) Map<String, dynamic> json,
  }) = _MiniAppScreen;

  /// Deserializes an API screen payload.
  factory MiniAppScreen.fromJson(Map<String, dynamic> json) =>
      _$MiniAppScreenFromJson(json);
}
