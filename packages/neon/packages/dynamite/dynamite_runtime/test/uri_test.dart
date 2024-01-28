import 'package:dynamite_runtime/src/utils/uri.dart';
import 'package:test/test.dart';

void main() {
  test('UriExtension', () {
    var uri = Uri(scheme: 'https', host: 'example.com', path: '/');
    expect(uri.normalizeEmptyPath().toString(), 'https://example.com');

    uri = Uri(scheme: 'https', host: 'example.com', path: '/slug');
    expect(uri.normalizeEmptyPath().toString(), 'https://example.com/slug');

    uri = Uri(scheme: 'https', host: 'example.com', path: '/slug/');
    expect(uri.normalizeEmptyPath().toString(), 'https://example.com/slug');
  });
}
