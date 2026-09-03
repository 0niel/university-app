import 'package:campus_repository/src/models/json_converters.dart';
import 'package:campus_repository/src/models/market_media_item.dart';
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
    @Default(false) bool isFree,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @Default(false) bool isMine,
    @Default('') String sellerName,
    @Default(false) bool showContact,
    @JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson)
    @Default(<MarketMediaItem>[])
    List<MarketMediaItem> media,
    String? telegramHandle,
  }) = _MarketListing;

  const MarketListing._();

  factory MarketListing.fromJson(Map<String, Object?> json) =>
      _$MarketListingFromJson(json);

  MarketMediaItem? get cover => media.isEmpty ? null : media.first;
}

List<MarketMediaItem> _mediaFromJson(Object? value) => value is List
    ? value
          .whereType<Map<Object?, Object?>>()
          .map((item) => MarketMediaItem.fromJson(item.cast()))
          .toList()
    : const [];

List<Map<String, Object?>> _mediaToJson(List<MarketMediaItem> value) =>
    value.map((item) => item.toJson()).toList();
