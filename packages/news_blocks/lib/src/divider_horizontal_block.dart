import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'divider_horizontal_block.freezed.dart';
part 'divider_horizontal_block.g.dart';

/// A horizontal divider in article content.
@freezed
abstract class DividerHorizontalBlock
    with _$DividerHorizontalBlock
    implements NewsBlock {
  /// Creates a horizontal-divider block.
  const factory DividerHorizontalBlock({
    @Default(DividerHorizontalBlock.identifier) String type,
  }) = _DividerHorizontalBlock;

  /// Deserializes a horizontal-divider block from [json].
  factory DividerHorizontalBlock.fromJson(Map<String, dynamic> json) =>
      _$DividerHorizontalBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__divider_horizontal__';
}
