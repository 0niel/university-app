// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_media_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketMediaItem _$MarketMediaItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MarketMediaItem', json, ($checkedConvert) {
      final val = _MarketMediaItem(
        path: $checkedConvert('path', (v) => v as String),
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(_$MarketMediaKindEnumMap, v),
        ),
        width: $checkedConvert('width', (v) => (v as num?)?.toInt() ?? 0),
        height: $checkedConvert('height', (v) => (v as num?)?.toInt() ?? 0),
        duration: $checkedConvert('duration', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$MarketMediaItemToJson(_MarketMediaItem instance) =>
    <String, dynamic>{
      'path': instance.path,
      'kind': _$MarketMediaKindEnumMap[instance.kind]!,
      'width': instance.width,
      'height': instance.height,
      'duration': instance.duration,
    };

const _$MarketMediaKindEnumMap = {
  MarketMediaKind.image: 'image',
  MarketMediaKind.video: 'video',
};
