import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

String marketplacePrice(
  AppLocalizations l10n,
  int price,
  String currencyCode,
) {
  if (price == 0) return l10n.marketFree;
  return NumberFormat.simpleCurrency(
    locale: l10n.localeName,
    name: currencyCode,
    decimalDigits: 0,
  ).format(price);
}
