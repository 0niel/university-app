import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:university_modules/university_modules.dart';

void main() {
  const supported = _Module(
    ModuleDescriptor(
      id: 'campus-services',
      title: 'Campus services',
      description: 'Institution services',
      organizationIds: {'university-a'},
    ),
  );

  test('only exposes compatible modules for the selected organization', () {
    const newer = _Module(
      ModuleDescriptor(
        id: 'future-services',
        title: 'Future services',
        description: '',
        organizationIds: {'university-a'},
        apiVersion: 2,
      ),
    );
    final registry = ModuleRegistry([supported, newer]);

    expect(registry.availableFor('university-a'), [supported]);
    expect(registry.availableFor('university-b'), isEmpty);
    expect(registry.availableFor(''), isEmpty);
    expect(
      registry.find('campus-services', organizationId: 'university-b'),
      isNull,
    );
    expect(
      registry.find('future-services', organizationId: 'university-a'),
      isNull,
    );
    expect(
      registry.find('campus-services', organizationId: 'university-a'),
      same(supported),
    );
  });

  test('rejects duplicate and route-unsafe module identifiers', () {
    expect(() => ModuleRegistry([supported, supported]), throwsArgumentError);
    expect(
      () => ModuleRegistry([
        const _Module(
          ModuleDescriptor(
            id: '../other',
            title: 'Other',
            description: '',
            organizationIds: {'university-a'},
          ),
        ),
      ]),
      throwsArgumentError,
    );
  });

  test('does not allow a caller to mutate the available module list', () {
    final available = ModuleRegistry([supported]).availableFor('university-a');
    expect(available.clear, throwsUnsupportedError);
  });

  test(
    'module presentation follows the host language with legacy fallback',
    () {
      expect(
        supported.descriptor.presentationFor('ru').title,
        'Campus services',
      );
      final descriptor = ModuleDescriptor(
        id: 'localized',
        title: 'Campus',
        description: '',
        organizationIds: {'university-a'},
        localize: (language) => ModulePresentation(
          title: language == 'ru' ? 'Кампус' : 'Campus',
          description: language,
        ),
      );
      expect(descriptor.presentationFor('ru').title, 'Кампус');
      expect(descriptor.presentationFor('en').title, 'Campus');
      expect(descriptor.id, 'localized');
    },
  );
}

class _Module implements UniversityModule {
  const _Module(this.descriptor);

  @override
  final ModuleDescriptor descriptor;

  @override
  Widget build(ModuleHost host) => const SizedBox.shrink();
}
