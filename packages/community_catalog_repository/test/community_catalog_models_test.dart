import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:test/test.dart';

void main() {
  group('CommunityCatalogEntry', () {
    test('decodes API fields and round-trips them to JSON', () {
      final entry = CommunityCatalogEntry.fromJson({
        'id': 'community-id',
        'slug': 'news',
        'title': 'News',
        'description': 'Official updates',
        'url': 'https://t.me/example_news',
        'platform': 'telegram',
        'membersCount': 42,
        'isFeatured': true,
        'isOfficial': true,
        'sortOrder': 10,
      });

      expect(entry.toJson(), containsPair('slug', 'news'));
      expect(entry.membersCount, 42);
      expect(entry.isFeatured, isTrue);
      expect(entry.safeUri, Uri.parse('https://t.me/example_news'));
    });

    test('rejects unsafe destinations', () {
      for (final url in [
        'http://t.me/example_news',
        'https://user@t.me/example_news',
        'not-a-url',
      ]) {
        final entry = CommunityCatalogEntry(
          id: 'community-id',
          slug: 'news',
          title: 'News',
          description: 'Official updates',
          url: url,
          platform: 'telegram',
        );

        expect(entry.safeUri, isNull, reason: url);
      }
    });
  });

  test('featured entries are ordered across sections', () {
    const catalog = CommunityCatalog(
      organizationId: 'example-university',
      sections: [
        CommunityCatalogSection(
          key: 'life',
          title: 'Life',
          emoji: '🏠',
          items: [
            CommunityCatalogEntry(
              id: 'later',
              slug: 'later',
              title: 'Later',
              description: '',
              url: 'https://example.com/later',
              platform: 'website',
              isFeatured: true,
              sortOrder: 20,
            ),
          ],
        ),
        CommunityCatalogSection(
          key: 'study',
          title: 'Study',
          emoji: '🎓',
          items: [
            CommunityCatalogEntry(
              id: 'first',
              slug: 'first',
              title: 'First',
              description: '',
              url: 'https://example.com/first',
              platform: 'website',
              isFeatured: true,
              sortOrder: 10,
            ),
          ],
        ),
      ],
    );

    expect(catalog.featured.map((entry) => entry.slug), ['first', 'later']);
  });
}
