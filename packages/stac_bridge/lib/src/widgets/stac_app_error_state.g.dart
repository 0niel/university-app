// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_error_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppErrorState _$StacAppErrorStateFromJson(Map<String, dynamic> json) =>
    _StacAppErrorState(
      title: stringOrEmpty(json['title']),
      message: stringOrEmpty(json['message']),
      primaryLabel: json['primaryLabel'] == null
          ? 'Повторить'
          : _retryWhenNotString(json['primaryLabel']),
      primaryActionJson: json['onPrimary'],
    );

Map<String, dynamic> _$StacAppErrorStateToJson(_StacAppErrorState instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
      'primaryLabel': instance.primaryLabel,
      'onPrimary': instance.primaryActionJson,
    };
