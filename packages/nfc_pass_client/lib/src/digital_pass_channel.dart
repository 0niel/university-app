import 'package:flutter/services.dart';

class DigitalPassChannel {
  const DigitalPassChannel({MethodChannel? channel})
      : _channel = channel ?? _defaultChannel;

  static const _defaultChannel = MethodChannel('university_app/digital_pass');

  final MethodChannel _channel;

  Future<void> savePassId(int passId) async {
    try {
      await _channel.invokeMethod<void>('savePassId', {
        'passId': passId.toString(),
      });
    } on MissingPluginException {
      return Future.value();
    }
  }

  Future<void> clearPassId() async {
    try {
      await _channel.invokeMethod<void>('clearPassId');
    } on MissingPluginException {
      return Future.value();
    }
  }

  Future<bool> isHceAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isHceAvailable') ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<bool> isHceEnabled() async {
    try {
      return await _channel.invokeMethod<bool>('isHceEnabled') ?? true;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> setHceEnabled({required bool enabled}) async {
    try {
      await _channel.invokeMethod<void>('setHceEnabled', {'enabled': enabled});
    } on MissingPluginException {
      return Future.value();
    }
  }

  Future<void> setForegroundPreference({required bool enabled}) async {
    try {
      await _channel.invokeMethod<void>('setForegroundPreference', {
        'enabled': enabled,
      });
    } on MissingPluginException {
      return Future.value();
    }
  }
}
