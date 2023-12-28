import 'package:github/github.dart';
import 'package:test/test.dart';

void main() {
  group('Contributor', () {
    test('fromJson() should return a Contributor instance', () {
      final json = {
        'login': 'user1',
        'avatar_url': 'http://avatar.com',
        'html_url': 'http://html.com',
        'contributions': 10,
      };

      final contributor = Contributor.fromJson(json);

      expect(contributor, isA<Contributor>());
      expect(contributor.login, 'user1');
      expect(contributor.avatarUrl, 'http://avatar.com');
      expect(contributor.htmlUrl, 'http://html.com');
      expect(contributor.contributions, 10);
    });

    test('toJson() should return a Map<String, dynamic>', () {
      const contributor = Contributor(
        login: 'user1',
        avatarUrl: 'http://avatar.com',
        htmlUrl: 'http://html.com',
        contributions: 10,
      );

      final json = contributor.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['login'], 'user1');
      expect(json['avatar_url'], 'http://avatar.com');
      expect(json['html_url'], 'http://html.com');
      expect(json['contributions'], 10);
    });

    test('props should return a list of properties', () {
      const contributor = Contributor(
        login: 'user1',
        avatarUrl: 'http://avatar.com',
        htmlUrl: 'http://html.com',
        contributions: 10,
      );

      final props = contributor.props;

      expect(props, isA<List<Object?>>());
      expect(props, [
        contributor.login,
        contributor.avatarUrl,
        contributor.htmlUrl,
        contributor.contributions,
      ]);
    });
  });
}
