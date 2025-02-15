import 'package:mini_app/src/mini_app.dart';

class MiniAppRegistry {
  MiniAppRegistry._();
  static final MiniAppRegistry instance = MiniAppRegistry._();

  final List<MiniApp> _registeredApps = [];

  void register(MiniApp miniApp) {
    _registeredApps.add(miniApp);
  }

  List<MiniApp> get miniApps => List.unmodifiable(_registeredApps);

  Future<void> initAllApps() async {
    for (final app in _registeredApps) {
      if (app.enabled) {
        await app.registerDependencies();
      }
    }
  }
}
