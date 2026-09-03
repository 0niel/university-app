import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final roots = ['lib', 'packages/app_ui/lib'];
  Iterable<File> sources() sync* {
    for (final root in roots) {
      yield* Directory(root)
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where(
            (file) =>
                file.path.endsWith('.dart') &&
                !file.path.endsWith('.g.dart') &&
                !file.path.endsWith('.freezed.dart'),
          );
    }
  }

  test('visual radii use shared tokens', () {
    final raw = RegExp(
      r'\.(?:circular|elliptical)\(\s*\d|'
      r'\.(?:circular|elliptical)\([^;\n]*[?:]\s*\d|'
      r'\b(?:radius|borderRadius)\s*[:=]\s*\d',
    );
    for (final example in [
      'BorderRadius.circular(dense ? 12 : AppRadius.lg)',
      'BorderRadius.circular(dense ? AppRadius.sm : 18)',
    ]) {
      expect(raw.hasMatch(example), isTrue);
    }
    final violations = <String>[];
    for (final file in sources()) {
      final source = file.readAsStringSync();
      for (final match in raw.allMatches(source)) {
        final line =
            '\n'.allMatches(source.substring(0, match.start)).length + 1;
        violations.add('${file.path}:$line');
      }
    }
    expect(violations, isEmpty);
  });

  test('screens use kit controls and no obsolete color aliases', () {
    final old = RegExp(
      r'\b(?:AppBar|SliverAppBar|ElevatedButton|FilledButton|TextButton|'
      'OutlinedButton|AlertDialog|SnackBar|Switch|Checkbox|ChoiceChip|'
      r'FilterChip|ListTile|Card|FloatingActionButton)(?:\.\w+)?\s*\('
      r'|colors\.(?:primary|background01|background02|background03|'
      r'active|deactive|surfaceHigh)\b',
    );
    for (final example in [
      'FilledButton.tonal(',
      'Switch.adaptive(',
      'Card.filled (',
      'TextButton.icon(',
    ]) {
      expect(old.hasMatch(example), isTrue);
    }
    final violations = <String>[];
    for (final file in sources()) {
      final source = file.readAsStringSync();
      for (final match in old.allMatches(source)) {
        final line =
            '\n'.allMatches(source.substring(0, match.start)).length + 1;
        violations.add('${file.path}:$line');
      }
    }
    expect(violations, isEmpty);
  });
}
