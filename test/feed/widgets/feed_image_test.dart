import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_image.dart';

import '../../helpers/pump_app.dart';

class _Cache extends Mock implements BaseCacheManager {}

class _ImageSource extends CachedNetworkImageProvider {
  const _ImageSource(this.width, this.height)
    : super('https://example.test/$width-$height.bmp');

  final int width;
  final int height;

  @override
  ImageStreamCompleter loadImage(
    CachedNetworkImageProvider key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(_decode(decode));

  Future<ImageInfo> _decode(ImageDecoderCallback decode) async {
    final stride = ((width * 3 + 3) ~/ 4) * 4;
    final pixels = Uint8List(54 + stride * height);
    pixels.buffer.asByteData()
      ..setUint16(0, 0x4d42, Endian.little)
      ..setUint32(2, pixels.length, Endian.little)
      ..setUint32(10, 54, Endian.little)
      ..setUint32(14, 40, Endian.little)
      ..setInt32(18, width, Endian.little)
      ..setInt32(22, height, Endian.little)
      ..setUint16(26, 1, Endian.little)
      ..setUint16(28, 24, Endian.little);
    final codec = await decode(await ui.ImmutableBuffer.fromUint8List(pixels));
    final frame = await codec.getNextFrame();
    codec.dispose();
    return ImageInfo(image: frame.image);
  }
}

class _RetryImageSource extends _ImageSource {
  const _RetryImageSource(this.failures) : super(1200, 300);

  final List<Object> failures;

  @override
  ImageStreamCompleter loadImage(
    CachedNetworkImageProvider key,
    ImageDecoderCallback decode,
  ) {
    if (failures.isEmpty) return super.loadImage(key, decode);
    return OneFrameImageStreamCompleter(
      Future.error(failures.removeAt(0)),
    );
  }
}

Future<ui.Image> _resolve(ImageProvider provider) async {
  final result = Completer<ui.Image>();
  final stream = provider.resolve(ImageConfiguration.empty);
  late ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, synchronous) {
      final image = info.image.clone();
      stream.removeListener(listener);
      result.complete(image);
      info.dispose();
    },
    onError: (error, stackTrace) {
      stream.removeListener(listener);
      result.completeError(error, stackTrace);
    },
  );
  stream.addListener(listener);
  return result.future;
}

void main() {
  setUp(() {
    final cache = _Cache();
    when(
      () => cache.getFileStream(
        any(),
        key: any(named: 'key'),
        headers: any(named: 'headers'),
        withProgress: any(named: 'withProgress'),
      ),
    ).thenAnswer((_) => const Stream.empty());
    CachedNetworkImageProvider.defaultCacheManager = cache;
    addTearDown(() {
      PaintingBinding.instance.imageCache
        ..clear()
        ..clearLiveImages();
    });
  });

  testWidgets('thumbnail decode respects physical bounds and source aspect', (
    tester,
  ) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(devicePixelRatio: 3),
          child: const Scaffold(
            body: Center(
              child: FeedImage(
                radius: 12,
                width: 72,
                height: 72,
                imageUrl: 'https://example.test/original.jpg',
              ),
            ),
          ),
        ),
      ),
    );
    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as FeedCoverImageProvider;
    expect(provider.width, 216);
    expect(provider.height, 216);
    expect(image.fit, BoxFit.cover);
    expect(
      provider.source.url,
      'https://example.test/original.jpg',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('hero decode uses its constrained width instead of infinity', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: FeedImage(
          radius: 0,
          width: double.infinity,
          height: 190,
          imageUrl: 'https://example.test/hero.jpg',
        ),
      ),
      size: const Size(390, 844),
    );
    final provider =
        tester.widget<Image>(find.byType(Image)).image
            as FeedCoverImageProvider;
    expect(provider.width, 390);
    expect(provider.height, 190);
    expect(tester.takeException(), isNull);
  });

  for (final (sourceWidth, sourceHeight, targetWidth, targetHeight) in [
    (1200, 300, 864, 216),
    (300, 1200, 216, 864),
    (1200, 1200, 216, 216),
    (80, 40, 80, 40),
  ]) {
    test(
      'cover decode preserves detail and aspect '
      'for $sourceWidth x $sourceHeight',
      () async {
        final image = await _resolve(
          FeedCoverImageProvider(
            source: _ImageSource(sourceWidth, sourceHeight),
            width: 216,
            height: 216,
          ),
        );
        addTearDown(image.dispose);
        expect(image.width, targetWidth);
        expect(image.height, targetHeight);
        expect(
          image.width * image.height,
          lessThanOrEqualTo(sourceWidth * sourceHeight),
        );
      },
    );
  }

  test(
    'portrait hero retains enough pixels for its full display width',
    () async {
      final image = await _resolve(
        const FeedCoverImageProvider(
          source: _ImageSource(1200, 2400),
          width: 390,
          height: 190,
        ),
      );
      addTearDown(image.dispose);
      expect(image.width, 390);
      expect(image.height, 780);
    },
  );

  test(
    'failed thumbnail is evicted so the same image can load on retry',
    () async {
      final provider = FeedCoverImageProvider(
        source: _RetryImageSource([StateError('Unavailable')]),
        width: 216,
        height: 216,
      );
      await expectLater(_resolve(provider), throwsStateError);
      await Future<void>.delayed(Duration.zero);
      final image = await _resolve(provider);
      addTearDown(image.dispose);
      expect(image.width, 864);
      expect(image.height, 216);
    },
  );

  test(
    'decoded cache shares identical targets and separates different targets',
    () async {
      const source = _ImageSource(1200, 300);
      FeedCoverImageProvider target(int size) => FeedCoverImageProvider(
        source: source,
        width: size,
        height: size,
      );
      final first = target(216);
      final same = target(216);
      final smaller = target(72);
      expect(identical(first, same), isFalse);
      final image = await _resolve(first);
      final reused = await _resolve(same);
      final resized = await _resolve(smaller);
      addTearDown(image.dispose);
      addTearDown(reused.dispose);
      addTearDown(resized.dispose);
      expect(image.isCloneOf(reused), isTrue);
      expect(image.isCloneOf(resized), isFalse);
      expect(resized.width, 288);
      expect(resized.height, 72);
    },
  );

  testWidgets('thumbnail opens original gallery URLs at the correct item', (
    tester,
  ) async {
    const original = 'https://example.test/original.jpg';
    const other = 'https://example.test/other.jpg';
    await tester.pumpApp(
      const Scaffold(
        body: Center(
          child: FeedImage(
            radius: 12,
            width: 72,
            height: 72,
            imageUrl: 'https://example.test/thumbnail.jpg',
            previewImageUrl: original,
            gallery: [other, original, original],
          ),
        ),
      ),
    );
    await tester.tap(find.byType(FeedImage));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final viewer = tester.widget<MediaViewerPage>(find.byType(MediaViewerPage));
    expect(viewer.items.map((item) => item.url), [other, original]);
    expect(viewer.initialIndex, 1);
    expect(tester.takeException(), isNull);
  });
}
