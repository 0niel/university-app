import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'section_header_block.freezed.dart';
part 'section_header_block.g.dart';

/// A section title with an optional navigation action.
@freezed
abstract class SectionHeaderBlock
    with _$SectionHeaderBlock
    implements NewsBlock {
  /// Creates a section-header block.
  const factory SectionHeaderBlock({
    required String title,
    @BlockActionConverter() BlockAction? action,
    @Default(SectionHeaderBlock.identifier) String type,
  }) = _SectionHeaderBlock;

  /// Deserializes a section-header block from [json].
  factory SectionHeaderBlock.fromJson(Map<String, dynamic> json) =>
      _$SectionHeaderBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__section_header__';
}
