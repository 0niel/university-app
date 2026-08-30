import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_listing_draft.freezed.dart';

@freezed
abstract class MarketListingDraft with _$MarketListingDraft {
  const factory MarketListingDraft({
    @Default('') String title,
    @Default(-1) int price,
    @Default('other') String category,
    @Default('') String description,
    @Default(false) bool showContact,
  }) = _MarketListingDraft;

  const MarketListingDraft._();

  bool get isValid {
    final normalizedTitle = title.trim();
    final normalizedCategory = category.trim();
    return normalizedTitle.isNotEmpty &&
        normalizedTitle.length <= 120 &&
        description.trim().length <= 4000 &&
        RegExp(r'^[a-z][a-z0-9_]{0,39}$').hasMatch(normalizedCategory) &&
        price >= 0 &&
        price <= 100000000 &&
        ((normalizedCategory == 'free') == (price == 0));
  }
}
