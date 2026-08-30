import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'video_introduction_block.freezed.dart';
part 'video_introduction_block.g.dart';

/// Introductory metadata for a video article.
@freezed
abstract class VideoIntroductionBlock
    with _$VideoIntroductionBlock
    implements NewsBlock {
  /// Creates a video-introduction block.
  const factory VideoIntroductionBlock({
    required String categoryId,
    required String title,
    required String videoUrl,
    @Default(VideoIntroductionBlock.identifier) String type,
  }) = _VideoIntroductionBlock;

  /// Deserializes a video-introduction block from [json].
  factory VideoIntroductionBlock.fromJson(Map<String, dynamic> json) =>
      _$VideoIntroductionBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__video_introduction__';
}
