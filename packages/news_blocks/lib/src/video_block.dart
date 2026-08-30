import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'video_block.freezed.dart';
part 'video_block.g.dart';

/// A video embedded in article content.
@freezed
abstract class VideoBlock with _$VideoBlock implements NewsBlock {
  /// Creates a video block.
  const factory VideoBlock({
    required String videoUrl,
    @Default(VideoBlock.identifier) String type,
  }) = _VideoBlock;

  /// Deserializes a video block from [json].
  factory VideoBlock.fromJson(Map<String, dynamic> json) =>
      _$VideoBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__video__';
}
