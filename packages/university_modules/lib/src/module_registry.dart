import 'package:university_modules/src/university_module.dart';

final class ModuleRegistry {
  ModuleRegistry(Iterable<UniversityModule> modules) {
    final registered = <String, UniversityModule>{};
    for (final module in modules) {
      final descriptor = module.descriptor;
      if (!descriptor.isValid) {
        throw ArgumentError('Invalid university module descriptor.');
      }
      if (registered.containsKey(descriptor.id)) {
        throw ArgumentError('Duplicate university module identifier.');
      }
      registered[descriptor.id] = module;
    }
    _modules = Map.unmodifiable(registered);
  }

  late final Map<String, UniversityModule> _modules;

  List<UniversityModule> availableFor(String organizationId) =>
      List.unmodifiable(
        _modules.values.where(
          (module) => module.descriptor.supports(organizationId),
        ),
      );

  UniversityModule? find(String id, {required String organizationId}) {
    final module = _modules[id];
    return module != null && module.descriptor.supports(organizationId)
        ? module
        : null;
  }
}
