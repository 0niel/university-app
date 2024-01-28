import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/src/utils/image_utils.dart';

void main() {
  group('Rewrite SVG dimensions', () {
    test('100%', () {
      expect(
        ImageUtils.rewriteSvgDimensions(
          '<svg height="32" width="32" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><rect width="100%" height="100%" fill="#ffffff"/></svg>',
        ),
        '<svg height="32" width="32" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><rect width="32.0" height="32.0" fill="#ffffff"/></svg>',
      );
    });

    test('66.6%', () {
      expect(
        ImageUtils.rewriteSvgDimensions(
          '<svg height="32" width="32" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><rect width="66.6%" height="66.6%" fill="#ffffff"/></svg>',
        ),
        '<svg height="32" width="32" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><rect width="21.311999999999998" height="21.311999999999998" fill="#ffffff"/></svg>',
      );
    });

    test('viewBox', () {
      expect(
        ImageUtils.rewriteSvgDimensions(
          '<svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><rect width="100%" height="100%" fill="#ffffff"/></svg>',
        ),
        '<svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><rect width="32.0" height="32.0" fill="#ffffff"/></svg>',
      );
    });

    test('viewbox', () {
      expect(
        ImageUtils.rewriteSvgDimensions(
          '<svg viewbox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><rect width="100%" height="100%" fill="#ffffff"/></svg>',
        ),
        '<svg viewbox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><rect width="32.0" height="32.0" fill="#ffffff"/></svg>',
      );
    });
  });
}
