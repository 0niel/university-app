import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

void configureTouchInput({
  required GestureBinding binding,
  required TargetPlatform platform,
  required double refreshRate,
}) {
  if (kIsWeb ||
      platform != TargetPlatform.android ||
      !refreshRate.isFinite ||
      refreshRate < 90) {
    return;
  }
  binding
    ..samplingOffset = const Duration(milliseconds: -12)
    ..resamplingEnabled = true;
}
