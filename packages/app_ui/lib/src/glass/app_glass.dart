import 'package:liquid_glass_easy/liquid_glass_easy.dart';

abstract final class AppGlass {
  static Future<void> warmUp() => LiquidGlassShaders.ensureLoaded();
}
