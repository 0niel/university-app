import 'package:shared_preferences/shared_preferences.dart';
import 'package:yx_scope/yx_scope.dart';

class SharedPreferencesInitializer implements AsyncLifecycle {
  SharedPreferences? _instance;

  SharedPreferences get instance {
    final result = _instance;
    if (result == null) {
      throw StateError('SharedPreferences not initialized');
    }
    return result;
  }

  @override
  Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  @override
  Future<void> dispose() async {}
}
