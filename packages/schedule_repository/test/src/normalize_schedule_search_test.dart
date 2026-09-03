import 'package:schedule_repository/schedule_repository.dart';
import 'package:test/test.dart';

void main() {
  test('group search ignores case, separators and whitespace', () {
    for (final query in ['ХЕБО-06-24', 'хебо0624', ' ХЕБО – 06 / 24 ']) {
      expect(normalizeScheduleSearch(query), 'хебо0624');
    }
  });

  test('teacher search treats dots and yo consistently', () {
    expect(normalizeScheduleSearch(' Семёнов И. А. '), 'семеновиа');
    expect(normalizeScheduleSearch('семеновиа'), 'семеновиа');
  });

  test('empty and punctuation-only queries normalize to empty', () {
    expect(normalizeScheduleSearch(''), isEmpty);
    expect(normalizeScheduleSearch(' — / '), isEmpty);
  });
}
