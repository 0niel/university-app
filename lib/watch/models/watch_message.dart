import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/watch/models/watch_message_action.dart';

part 'watch_message.freezed.dart';
part 'watch_message.g.dart';

@freezed
abstract class WatchMessage with _$WatchMessage {
  const factory WatchMessage({
    @JsonKey(unknownEnumValue: WatchMessageAction.unknown)
    required WatchMessageAction action,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
  }) = _WatchMessage;

  const WatchMessage._();

  factory WatchMessage.fromJson(Map<String, dynamic> json) =>
      _$WatchMessageFromJson(json);

  factory WatchMessage.fromMap(Map<String, dynamic> map) => WatchMessage(
    action: WatchMessageAction.fromString(map['action'] as String?),
    data: Map.unmodifiable(map),
  );
}
