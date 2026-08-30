import 'package:app_links/app_links.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAppLinks extends Mock implements AppLinks {}

void main() {
  test('reads the initial link from the platform API', () async {
    final appLinks = MockAppLinks();
    final expectedLink = Uri.https('university.example', '/welcome');
    when(appLinks.getInitialLink).thenAnswer((_) async => expectedLink);

    final client = DeepLinkClient(appLinks: appLinks);

    expect(await client.getInitialLink(), expectedLink);
    verify(appLinks.getInitialLink).called(1);
  });
}
