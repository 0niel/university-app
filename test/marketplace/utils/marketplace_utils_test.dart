import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:rtu_mirea_app/marketplace/utils/utils.dart';

void main() {
  final l10n = AppLocalizationsRu();
  final now = DateTime(2026, 7, 11, 12);

  test('formats relative time against an injected clock', () {
    expect(
      relativeTime(l10n, now.subtract(const Duration(minutes: 5)), now: now),
      '5 мин назад',
    );
    expect(
      relativeTime(l10n, now.subtract(const Duration(days: 1)), now: now),
      'вчера',
    );
  });

  test('formats free and configured currency prices', () {
    expect(marketplacePrice(l10n, 0, 'RUB'), 'Даром');
    expect(marketplacePrice(l10n, 500, 'RUB'), contains('500'));
    expect(marketplacePrice(l10n, 500, 'RUB'), contains('₽'));
  });
}
