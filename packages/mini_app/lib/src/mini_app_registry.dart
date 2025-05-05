import 'package:mini_app/src/mini_app.dart';

class MiniAppRegistry {
  MiniAppRegistry._privateConstructor();
  static final MiniAppRegistry instance = MiniAppRegistry._privateConstructor();

  final List<MiniApp> _miniApps = [];

  List<MiniApp> get miniApps => List.unmodifiable(_miniApps);

  /// Регистрирует мини‑приложение и вызывает его onInit()
  void register(MiniApp miniApp) {
    _miniApps.add(miniApp);
    miniApp.onInit();
  }
}
