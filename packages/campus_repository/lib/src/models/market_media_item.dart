import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_media_item.freezed.dart';
part 'market_media_item.g.dart';

enum MarketMediaKind { image, video }

@freezed
abstract class MarketMediaItem with _$MarketMediaItem {
  const factory MarketMediaItem({
    required String path,
    required MarketMediaKind kind,
    @Default(0) int width,
    @Default(0) int height,
    @Default(0) int duration,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String url,
  }) = _MarketMediaItem;

  const MarketMediaItem._();

  factory MarketMediaItem.fromJson(Map<String, Object?> json) =>
      _$MarketMediaItemFromJson(json);

  bool get isVideo => kind == MarketMediaKind.video;
}
