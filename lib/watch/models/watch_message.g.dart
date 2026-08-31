// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchMessage _$WatchMessageFromJson(Map<String, dynamic> json) =>
    _WatchMessage(
      action: $enumDecode(
        _$WatchMessageActionEnumMap,
        json['action'],
        unknownValue: WatchMessageAction.unknown,
      ),
      data: json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$WatchMessageToJson(_WatchMessage instance) =>
    <String, dynamic>{
      'action': _$WatchMessageActionEnumMap[instance.action]!,
      'data': instance.data,
    };

const _$WatchMessageActionEnumMap = {
  WatchMessageAction.requestPassId: 'requestPassId',
  WatchMessageAction.requestSchedule: 'requestSchedule',
  WatchMessageAction.openPhoneAppForBinding: 'openPhoneAppForBinding',
  WatchMessageAction.unknown: 'unknown',
};
