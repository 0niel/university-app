// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi_access_point_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WifiAccessPointReading _$WifiAccessPointReadingFromJson(
  Map<String, dynamic> json,
) => _WifiAccessPointReading(
  bssid: json['bssid'] as String,
  rssi: (json['rssi'] as num).toInt(),
);

Map<String, dynamic> _$WifiAccessPointReadingToJson(
  _WifiAccessPointReading instance,
) => <String, dynamic>{'bssid': instance.bssid, 'rssi': instance.rssi};
