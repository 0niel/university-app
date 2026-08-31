import 'package:rtu_mirea_app/l10n/l10n.dart';

abstract final class LostFoundCategories {
  static String label(AppLocalizations l10n, String key) => switch (key) {
    'tech' => l10n.lostFoundCatTech,
    'docs' => l10n.lostFoundCatDocs,
    'keys' => l10n.lostFoundCatKeys,
    'cloth' => l10n.lostFoundCatCloth,
    'other' => l10n.lostFoundCatOther,
    _ => _humanize(key),
  };

  static String _humanize(String value) {
    final words = value.split('_').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return value;
    final text = words.join(' ');
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }
}
