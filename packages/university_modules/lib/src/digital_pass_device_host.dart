import 'package:university_modules/src/module_host.dart';

abstract interface class DigitalPassDeviceHost implements ModuleHost {
  Future<void> clearDigitalPassBinding();
}
