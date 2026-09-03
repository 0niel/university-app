import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/community.dart';

void main() {
  group('deltaFromPlainText', () {
    test('wraps plain text into a single insert op with trailing newline', () {
      final delta = deltaFromPlainText('Hello world');

      expect(delta.toJson(), [
        {'insert': 'Hello world\n'},
      ]);
    });

    test('produces just a newline for empty text', () {
      final delta = deltaFromPlainText('');

      expect(delta.toJson(), [
        {'insert': '\n'},
      ]);
    });

    test('trims trailing whitespace before the newline', () {
      final delta = deltaFromPlainText('Text   \n\n  ');

      expect(delta.toJson(), [
        {'insert': 'Text\n'},
      ]);
    });
  });

  group('plainTextFromDelta', () {
    test('concatenates string insert ops', () {
      final text = plainTextFromDelta([
        {'insert': 'Hello '},
        {'insert': 'world'},
        {'insert': '\n'},
      ]);

      expect(text, 'Hello world\n');
    });

    test('skips embeds', () {
      final text = plainTextFromDelta([
        {'insert': 'before '},
        {
          'insert': {'image': 'https://example.com/x.png'},
        },
        {'insert': ' after\n'},
      ]);

      expect(text, 'before  after\n');
    });

    test('returns empty string for an empty document', () {
      expect(plainTextFromDelta(const []), '');
    });
  });
}
