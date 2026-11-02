import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/feed/view/story_viewer/story_layout.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_image.dart';

abstract final class StoryImages {
  static FeedCoverImageProvider avatar(String url, double pixelRatio) {
    final pixels = (48 * pixelRatio).ceil();
    return FeedCoverImageProvider(
      source: CachedNetworkImageProvider(url),
      width: pixels,
      height: pixels,
    );
  }

  static ResizeImage media(
    CachedNetworkImageProvider source,
    Size size,
    double pixelRatio,
  ) => ResizeImage(
    source,
    width: math.max(1, (size.width * pixelRatio).ceil()),
    height: math.max(1, (size.height * pixelRatio).ceil()),
    policy: ResizeImagePolicy.fit,
  );

  static StoryBlurredImageProvider backdrop(
    String url,
    Size size,
    double pixelRatio,
  ) {
    const scale = 8.0;
    final previewSize = size / scale;
    return StoryBlurredImageProvider(
      source: media(CachedNetworkImageProvider(url), previewSize, pixelRatio),
      width: math.max(1, (previewSize.width * pixelRatio).ceil()),
      height: math.max(1, (previewSize.height * pixelRatio).ceil()),
      sigma: 30 * pixelRatio / scale,
    );
  }

  static Size stageSize(Size size) => size.width <= StoryLayout.wideBreakpoint
      ? size
      : applyBoxFit(BoxFit.contain, const Size(9, 16), size).destination;
}

@immutable
class StoryBlurredImageProvider
    extends ImageProvider<StoryBlurredImageProvider> {
  const StoryBlurredImageProvider({
    required this.source,
    required this.width,
    required this.height,
    required this.sigma,
  });

  final ResizeImage source;
  final int width;
  final int height;
  final double sigma;

  @override
  Future<StoryBlurredImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) => SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    StoryBlurredImageProvider key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(_render())
    ..addEphemeralErrorListener((exception, stackTrace) {
      scheduleMicrotask(() => PaintingBinding.instance.imageCache.evict(key));
    });

  Future<ImageInfo> _render() async {
    final ready = Completer<ImageInfo>();
    final stream = source.resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, synchronous) {
        stream.removeListener(listener);
        ready.complete(info);
      },
      onError: (error, stack) {
        stream.removeListener(listener);
        ready.completeError(error, stack);
      },
    );
    stream.addListener(listener);
    final info = await ready.future;
    try {
      final sourceSize = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
      final targetSize = Size(width.toDouble(), height.toDouble());
      final fitted = applyBoxFit(BoxFit.cover, sourceSize, targetSize);
      final recorder = ui.PictureRecorder();
      ui.Canvas(recorder).drawImageRect(
        info.image,
        Alignment.center.inscribe(fitted.source, Offset.zero & sourceSize),
        Offset.zero & targetSize,
        ui.Paint()
          ..filterQuality = FilterQuality.low
          ..imageFilter = ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      );
      final picture = recorder.endRecording();
      try {
        return ImageInfo(image: await picture.toImage(width, height));
      } finally {
        picture.dispose();
      }
    } finally {
      info.dispose();
    }
  }

  @override
  bool operator ==(Object other) =>
      other is StoryBlurredImageProvider &&
      source == other.source &&
      width == other.width &&
      height == other.height &&
      sigma == other.sigma;

  @override
  int get hashCode => Object.hash(source, width, height, sigma);
}
