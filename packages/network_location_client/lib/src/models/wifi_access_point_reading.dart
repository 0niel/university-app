import 'package:freezed_annotation/freezed_annotation.dart';

part 'wifi_access_point_reading.freezed.dart';
part 'wifi_access_point_reading.g.dart';

@freezed
abstract class WifiAccessPointReading with _$WifiAccessPointReading {
  const factory WifiAccessPointReading({
    required String bssid,
    required int rssi,
  }) = _WifiAccessPointReading;

  const WifiAccessPointReading._();

  factory WifiAccessPointReading.fromJson(Map<String, dynamic> json) =>
      _$WifiAccessPointReadingFromJson(json);

  static final _bssidPattern = RegExp(r'^[0-9a-f]{2}(:[0-9a-f]{2}){5}$');

  bool get isValidBssid => _bssidPattern.hasMatch(bssid);

  bool get isLocallyAdministered =>
      bssid.length >= 2 && const {'2', '6', 'a', 'e'}.contains(bssid[1]);
}
