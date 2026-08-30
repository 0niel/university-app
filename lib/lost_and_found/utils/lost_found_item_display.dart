import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

extension LostFoundItemDisplay on LostFoundItem {
  String authorDisplayName(AppLocalizations l10n) =>
      authorName.isNotEmpty ? authorName : l10n.unknown;

  String actionLine(AppLocalizations l10n, String name) => status == .found
      ? l10n.lostFoundFoundBy(name)
      : l10n.lostFoundLostBy(name);
}
