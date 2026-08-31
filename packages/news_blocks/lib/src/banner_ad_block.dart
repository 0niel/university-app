import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'banner_ad_block.freezed.dart';
part 'banner_ad_block.g.dart';

/// The size of a [BannerAdBlock].
enum BannerSize {
  /// The normal size of a banner ad.
  normal,

  /// The large size of a banner ad.
  large,

  /// The extra large size of a banner ad.
  extraLarge,

  /// The anchored adaptive size of a banner ad.
  anchoredAdaptive,
}

/// An advertisement slot in article content.
@freezed
abstract class BannerAdBlock with _$BannerAdBlock implements NewsBlock {
  /// Creates a banner-ad block.
  const factory BannerAdBlock({
    required BannerSize size,
    @Default(BannerAdBlock.identifier) String type,
  }) = _BannerAdBlock;

  /// Deserializes a banner-ad block from [json].
  factory BannerAdBlock.fromJson(Map<String, dynamic> json) =>
      _$BannerAdBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__banner_ad__';
}
