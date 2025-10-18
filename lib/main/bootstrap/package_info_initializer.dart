import 'package:package_info_plus/package_info_plus.dart';
import 'package:yx_scope/yx_scope.dart';

class PackageInfoInitializer implements AsyncLifecycle {
  PackageInfo? _instance;

  PackageInfo get instance {
    final result = _instance;
    if (result == null) {
      throw StateError('PackageInfo not initialized');
    }
    return result;
  }

  @override
  Future<void> init() async {
    _instance = await PackageInfo.fromPlatform();
  }

  @override
  Future<void> dispose() async {
    _instance = null;
  }
}
