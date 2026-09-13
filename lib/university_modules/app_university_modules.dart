import 'package:university_modules/university_modules.dart';
import 'package:university_provider/university_provider.dart';

abstract final class AppUniversityModules {
  static final registry = ModuleRegistry(createUniversityModules());
}
