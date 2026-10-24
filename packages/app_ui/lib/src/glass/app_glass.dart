import 'package:app_ui/src/glass/app_glass_backend.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

abstract final class AppGlass {
  static Future<void> warmUp() {
    AppGlassBackend.initialize();
    return AppGlassBackend.useGpu
        ? LiquidGlass.precache()
        : LiquidGlassShaders.ensureLoaded();
  }
}
