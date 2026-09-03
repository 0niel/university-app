import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';

void main() {
  group('parseCustomRoles', () {
    test('splits comma-separated roles and trims whitespace', () {
      expect(
        parseCustomRoles(' DevOps ,  Аналитик ,QA'),
        ['DevOps', 'Аналитик', 'QA'],
      );
    });

    test('drops empty segments and duplicates', () {
      expect(
        parseCustomRoles('DevOps,, DevOps ,  ,QA'),
        ['DevOps', 'QA'],
      );
    });

    test('returns an empty list for blank input', () {
      expect(parseCustomRoles('   '), isEmpty);
      expect(parseCustomRoles(''), isEmpty);
    });

    test('keeps a single role without a comma', () {
      expect(parseCustomRoles('DevOps'), ['DevOps']);
    });
  });
}
