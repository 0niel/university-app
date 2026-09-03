import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_listing_draft.freezed.dart';

final RegExp marketTelegramPattern = RegExp(r'^[A-Za-z0-9_]{5,32}$');

@freezed
abstract class MarketListingDraft with _$MarketListingDraft {
  const factory MarketListingDraft({
    @Default('') String title,
    @Default(-1) int price,
    @Default('other') String category,
    @Default('') String description,
    @Default(false) bool showContact,
    @Default(false) bool isFree,
    @Default('') String telegramHandle,
    @Default(<MarketMediaItem>[]) List<MarketMediaItem> media,
  }) = _MarketListingDraft;

  const MarketListingDraft._();

  String get normalizedTelegramHandle =>
      telegramHandle.trim().replaceFirst(RegExp('^@'), '');

  bool get isTelegramValid =>
      marketTelegramPattern.hasMatch(normalizedTelegramHandle);

  bool get isMediaValid {
    if (media.length > 7) return false;
    return media.where((item) => item.isVideo).length <= 1;
  }

  bool get isValid {
    final normalizedTitle = title.trim();
    final normalizedCategory = category.trim();
    return normalizedTitle.isNotEmpty &&
        normalizedTitle.length <= 120 &&
        description.trim().length <= 4000 &&
        RegExp(r'^[a-z][a-z0-9_]{0,39}$').hasMatch(normalizedCategory) &&
        price >= 0 &&
        price <= 100000000 &&
        (!isFree || price == 0) &&
        isTelegramValid &&
        isMediaValid;
  }
}
