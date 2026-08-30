import 'package:collection/collection.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';
import 'package:test/test.dart';

void main() {
  test('parses a catalog returned by the public RPC', () {
    final catalog = ServiceCatalog.fromJson({
      'organizationId': 'university',
      'sections': [
        {
          'key': 'student-life',
          'title': 'Student life',
          'sortOrder': 10,
          'items': [
            {
              'id': '8e8ddc55-48e2-4f0a-b11b-1c11bc8a0ad7',
              'slug': 'career-center',
              'title': 'Career center',
              'description': '',
              'url': 'https://career.university.example/',
              'iconKey': 'work',
              'colorKey': 'colorful04',
              'emoji': '💼',
              'sortOrder': 0,
            },
          ],
        },
      ],
    });

    expect(catalog.organizationId, 'university');
    expect(
      catalog.sections.singleOrNull?.items.singleOrNull?.slug,
      'career-center',
    );
  });
}
