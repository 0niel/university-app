import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract final class FriendsLocationBackground {
  static const _channel = MethodChannel(
    'ninja.mirea/friends_location_background',
  );

  static Future<void> setEnabled({required bool enabled}) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    await _channel.invokeMethod<void>('setEnabled', enabled);
  }
}
