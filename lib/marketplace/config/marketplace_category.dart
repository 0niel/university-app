import 'package:rtu_mirea_app/l10n/l10n.dart';

final class MarketplaceCategory {
  const MarketplaceCategory(this.emoji);

  final String emoji;
}

abstract final class MarketplaceCategories {
  static const Map<String, MarketplaceCategory> values = {
    'books': MarketplaceCategory('📚'),
    'tech': MarketplaceCategory('💻'),
    'cloth': MarketplaceCategory('🧥'),
    'free': MarketplaceCategory('🎁'),
    'other': MarketplaceCategory('📦'),
  };

  static MarketplaceCategory presentation(String key) =>
      values[key] ?? const MarketplaceCategory('📦');

  static String label(AppLocalizations l10n, String key) => switch (key) {
    'all' => l10n.marketCatAll,
    'books' => l10n.marketCatBooks,
    'tech' => l10n.marketCatTech,
    'cloth' => l10n.marketCatCloth,
    'free' => l10n.marketCatFree,
    'other' => l10n.marketCatOther,
    _ => _humanize(key),
  };

  static String _humanize(String value) {
    final words = value.split('_').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return value;
    final text = words.join(' ');
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }
}
