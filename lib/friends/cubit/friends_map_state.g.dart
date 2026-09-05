// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_map_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoSharingSettings _$GeoSharingSettingsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GeoSharingSettings', json, ($checkedConvert) {
      final val = _GeoSharingSettings(
        sharing: $checkedConvert('sharing', (v) => v as bool? ?? false),
        visibility: $checkedConvert(
          'visibility',
          (v) =>
              $enumDecodeNullable(
                _$GeoVisibilityEnumMap,
                v,
                unknownValue: GeoVisibility.none,
              ) ??
              GeoVisibility.all,
        ),
        precision: $checkedConvert(
          'precision',
          (v) =>
              $enumDecodeNullable(
                _$GeoPrecisionEnumMap,
                v,
                unknownValue: GeoPrecision.exact,
              ) ??
              GeoPrecision.exact,
        ),
        privacyForcedGhost: $checkedConvert(
          'privacyForcedGhost',
          (v) => v as bool? ?? false,
        ),
      );
      return val;
    });

Map<String, dynamic> _$GeoSharingSettingsToJson(_GeoSharingSettings instance) =>
    <String, dynamic>{
      'sharing': instance.sharing,
      'visibility': _$GeoVisibilityEnumMap[instance.visibility]!,
      'precision': _$GeoPrecisionEnumMap[instance.precision]!,
      'privacyForcedGhost': instance.privacyForcedGhost,
    };

const _$GeoVisibilityEnumMap = {
  GeoVisibility.all: 'all',
  GeoVisibility.students: 'students',
  GeoVisibility.none: 'none',
};

const _$GeoPrecisionEnumMap = {
  GeoPrecision.exact: 'exact',
  GeoPrecision.campus: 'campus',
  GeoPrecision.city: 'city',
};
