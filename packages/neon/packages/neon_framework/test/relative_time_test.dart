// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/l10n/localizations_en.dart';
import 'package:neon_framework/src/utils/relative_time.dart';

void main() {
  final localizations = NeonLocalizationsEn();

  final durations = <Duration, (String, String)>{
    const Duration(days: 730): ('2 years', 'in 2 years'),
    const Duration(days: 729): ('1 year', 'in 1 year'),
    const Duration(days: 365): ('1 year', 'in 1 year'),
    const Duration(days: 364): ('364 days', 'in 364 days'),
    const Duration(days: 1): ('1 day', 'in 1 day'),
    const Duration(hours: 23): ('23 hours', 'in 23 hours'),
    const Duration(hours: 1): ('1 hour', 'in 1 hour'),
    const Duration(minutes: 59): ('59 minutes', 'in 59 minutes'),
    const Duration(minutes: 1): ('1 minute', 'in 1 minute'),
    const Duration(seconds: 59): ('now', 'now'),
    const Duration(seconds: 1): ('now', 'now'),
    const Duration(seconds: -1): ('now', 'now'),
    const Duration(seconds: -59): ('now', 'now'),
    const Duration(minutes: -1): ('1 minute', '1 minute ago'),
    const Duration(minutes: -59): ('59 minutes', '59 minutes ago'),
    const Duration(hours: -1): ('1 hour', '1 hour ago'),
    const Duration(hours: -23): ('23 hours', '23 hours ago'),
    const Duration(days: -1): ('1 day', '1 day ago'),
    const Duration(days: -364): ('364 days', '364 days ago'),
    const Duration(days: -365): ('1 year', '1 year ago'),
    const Duration(days: -729): ('1 year', '1 year ago'),
    const Duration(days: -730): ('2 years', '2 years ago'),
  };

  test('Duration', () {
    for (final entry in durations.entries) {
      expect(entry.key.formatRelative(localizations, includeSign: false), entry.value.$1);
      expect(entry.key.formatRelative(localizations, includeSign: true), entry.value.$2);
    }
  });

  test('DateTime', () {
    final base = DateTime.now();

    expect(base.formatRelative(localizations), 'now');

    for (final entry in durations.entries) {
      expect(base.add(entry.key).formatRelative(localizations, to: base, includeSign: false), entry.value.$1);
      expect(base.add(entry.key).formatRelative(localizations, to: base, includeSign: true), entry.value.$2);
    }
  });
}
