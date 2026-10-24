import 'package:app_ui/src/glass/app_glass_gpu_capability_stub.dart'
    if (dart.library.io) 'app_glass_gpu_capability_native.dart'
    as capability;
import 'package:flutter/foundation.dart';

abstract final class AppGlassBackend {
  static bool _initialized = false;
  static bool _useGpu = true;

  static bool get useGpu => _useGpu;

  @visibleForTesting
  static bool Function()? capabilityProbeOverride;

  static void initialize() {
    if (_initialized) return;
    _useGpu = (capabilityProbeOverride ?? capability.supportsFlutterGpu)();
    _initialized = true;
  }

  @visibleForTesting
  static void reset() {
    _initialized = false;
    _useGpu = true;
    capabilityProbeOverride = null;
  }
}
