import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/feed/view/story_viewer/story_images.dart';

class _ImageSource extends CachedNetworkImageProvider {
  const _ImageSource(
    this.width,
    this.height, {
    this.split = false,
    this.decodes,
  }) : super('https://example.test/$width-$height.bmp');

  final int width;
  final int height;
  final bool split;
  final List<Size>? decodes;

  @override
  ImageStreamCompleter loadImage(
    CachedNetworkImageProvider key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(_decode(decode));

  Future<ImageInfo> _decode(ImageDecoderCallback decode) async {
    final stride = ((width * 3 + 3) ~/ 4) * 4;
    final bytes = Uint8List(54 + stride * height);
    bytes.buffer.asByteData()
      ..setUint16(0, 0x4d42, Endian.little)
      ..setUint32(2, bytes.length, Endian.little)
      ..setUint32(10, 54, Endian.little)
      ..setUint32(14, 40, Endian.little)
      ..setInt32(18, width, Endian.little)
      ..setInt32(22, height, Endian.little)
      ..setUint16(26, 1, Endian.little)
      ..setUint16(28, 24, Endian.little);
    if (split) {
      for (var y = 0; y < height; y++) {
        bytes.fillRange(
          54 + y * stride + (width ~/ 2) * 3,
          54 + y * stride + width * 3,
          255,
        );
      }
    }
    final codec = await decode(await ui.ImmutableBuffer.fromUint8List(bytes));
    final frame = await codec.getNextFrame();
    codec.dispose();
    decodes?.add(
      Size(frame.image.width.toDouble(), frame.image.height.toDouble()),
    );
    return ImageInfo(image: frame.image);
  }
}

class _RetryImageSource extends _ImageSource {
  const _RetryImageSource(this.failures) : super(800, 1600);

  final List<Object> failures;

  @override
  ImageStreamCompleter loadImage(
    CachedNetworkImageProvider key,
    ImageDecoderCallback decode,
  ) => failures.isEmpty
      ? super.loadImage(key, decode)
      : OneFrameImageStreamCompleter(Future.error(failures.removeAt(0)));
}

Future<ui.Image> _resolve(ImageProvider<Object> provider) async {
  final ready = Completer<ui.Image>();
  final stream = provider.resolve(ImageConfiguration.empty);
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, synchronous) {
      stream.removeListener(listener);
      ready.complete(info.image.clone());
      info.dispose();
    },
    onError: (error, stack) {
      stream.removeListener(listener);
      ready.completeError(error, stack);
    },
  );
  stream.addListener(listener);
  return ready.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
  });

  for (final (source, ratio, expected) in [
    (const Size(1200, 300), 1.0, const Size(390, 97)),
    (const Size(1200, 2400), 1.0, const Size(390, 780)),
    (const Size(1200, 2400), 3.0, const Size(1170, 2340)),
    (const Size(300, 3000), 1.0, const Size(84, 844)),
    (const Size(80, 40), 3.0, const Size(80, 40)),
  ]) {
    test(
      'contained decode preserves detail at $ratio DPR for $source',
      () async {
        final image = await _resolve(
          StoryImages.media(
            _ImageSource(source.width.toInt(), source.height.toInt()),
            const Size(390, 844),
            ratio,
          ),
        );
        addTearDown(image.dispose);
        expect(Size(image.width.toDouble(), image.height.toDouble()), expected);
        expect(image.width, lessThanOrEqualTo(source.width));
        expect(image.height, lessThanOrEqualTo(source.height));
      },
    );
  }

  test(
    'blur output and source codec stay at one eighth viewport dimensions',
    () async {
      final decodes = <Size>[];
      final provider = StoryBlurredImageProvider(
        source: StoryImages.media(
          _ImageSource(800, 1600, split: true, decodes: decodes),
          const Size(100, 200),
          1,
        ),
        width: 100,
        height: 200,
        sigma: 3.75,
      );
      final image = await _resolve(provider);
      addTearDown(image.dispose);
      expect(
        Size(image.width.toDouble(), image.height.toDouble()),
        const Size(100, 200),
      );
      expect(decodes, [const Size(100, 200)]);
      final pixels = (await image.toByteData())!;
      final left = pixels.getUint8((100 * image.width + 48) * 4);
      final right = pixels.getUint8((100 * image.width + 52) * 4);
      expect(left, inExclusiveRange(0, 255));
      expect(right, inExclusiveRange(0, 255));
      expect(left, lessThan(right));
      final cached = await _resolve(provider);
      addTearDown(cached.dispose);
      expect(decodes, hasLength(1));
      expect(cached.isCloneOf(image), isTrue);
    },
  );

  test(
    'high density backdrop has a bounded cached raster '
    'with matching blur scale',
    () {
      final provider = StoryImages.backdrop(
        'https://example.test/photo.jpg',
        const Size(390, 844),
        3,
      );
      expect(provider.width, 147);
      expect(provider.height, 317);
      expect(provider.sigma, 11.25);
      expect(provider.source.width, provider.width);
      expect(provider.source.height, provider.height);
    },
  );

  test(
    'panoramic blur source cannot expand into an oversized cover decode',
    () async {
      final decodes = <Size>[];
      final image = await _resolve(
        StoryBlurredImageProvider(
          source: StoryImages.media(
            _ImageSource(12000, 400, decodes: decodes),
            const Size(135, 292),
            1,
          ),
          width: 135,
          height: 292,
          sigma: 10.5,
        ),
      );
      addTearDown(image.dispose);
      expect(decodes, [const Size(135, 4)]);
      expect(image.width, 135);
      expect(image.height, 292);
    },
  );

  test(
    'failed blur can load again after the source becomes available',
    () async {
      final provider = StoryBlurredImageProvider(
        source: StoryImages.media(
          _RetryImageSource([StateError('Unavailable')]),
          const Size(100, 200),
          1,
        ),
        width: 100,
        height: 200,
        sigma: 3.75,
      );
      await expectLater(_resolve(provider), throwsStateError);
      await Future<void>.delayed(Duration.zero);
      final image = await _resolve(provider);
      addTearDown(image.dispose);
      expect(image.width, 100);
      expect(image.height, 200);
    },
  );

  test(
    'wide stage prefetch and visible media resolve to the same cache entry',
    () async {
      const source = CachedNetworkImageProvider(
        'https://example.test/photo.jpg',
      );
      final prefetched = StoryImages.media(
        source,
        StoryImages.stageSize(const Size(900, 700)),
        3,
      );
      final visible = StoryImages.media(source, const Size(393.75, 700), 3);
      expect(
        await prefetched.obtainKey(ImageConfiguration.empty),
        await visible.obtainKey(ImageConfiguration.empty),
      );
      expect(visible.width, 1182);
      expect(visible.height, 2100);
    },
  );
}
