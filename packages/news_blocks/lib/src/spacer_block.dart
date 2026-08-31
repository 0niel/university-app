import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'spacer_block.freezed.dart';
part 'spacer_block.g.dart';

/// The spacing of [SpacerBlock].
enum Spacing {
  /// The extra small spacing.
  extraSmall,

  /// The small spacing.
  small,

  /// The medium spacing.
  medium,

  /// The large spacing.
  large,

  /// The very large spacing.
  veryLarge,

  /// The extra large spacing.
  extraLarge,
}

/// A configurable vertical spacer in article content.
@freezed
abstract class SpacerBlock with _$SpacerBlock implements NewsBlock {
  /// Creates a spacer block.
  const factory SpacerBlock({
    required Spacing spacing,
    @Default(SpacerBlock.identifier) String type,
  }) = _SpacerBlock;

  /// Deserializes a spacer block from [json].
  factory SpacerBlock.fromJson(Map<String, dynamic> json) =>
      _$SpacerBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__spacer__';
}
