import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AmbientModeListener extends ValueNotifier<bool> {
  AmbientModeListener._(MethodChannel channel) : super(false) {
    channel.setMethodCallHandler(_onMethodCallHandler);
  }

  static const channel = MethodChannel('ambient_mode');

  static final instance = AmbientModeListener._(channel);

  bool get isAmbientModeActive => value;

  @override
  @visibleForTesting
  set value(bool newValue) {
    super.value = newValue;
  }

  Future<void> _onMethodCallHandler(MethodCall call) {
    value = switch (call.method) {
      'onEnterAmbient' || 'onUpdateAmbient' => true,
      'onExitAmbient' => false,
      _ => value,
    };
    return Future.value();
  }
}
