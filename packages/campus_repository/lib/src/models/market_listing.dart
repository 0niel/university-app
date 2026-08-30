import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_listing.freezed.dart';
part 'market_listing.g.dart';

@freezed
abstract class MarketListing with _$MarketListing {
  const factory MarketListing({
    required String id,
    required String title,
    required int price,
    @Default('') String description,
    @Default('other') String category,
    @Default('📦') String emoji,
    @Default(false) bool isSold,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @Default(false) bool isMine,
    @Default('') String sellerName,
    @Default(false) bool showContact,
    String? sellerHandle,
  }) = _MarketListing;

  const MarketListing._();

  factory MarketListing.fromJson(Map<String, Object?> json) =>
      _$MarketListingFromJson(json);

  bool get isFree => price == 0;
}
