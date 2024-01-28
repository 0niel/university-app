import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/utils/image_utils.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:neon_framework/src/widgets/linear_progress_indicator.dart';
import 'package:nextcloud/nextcloud.dart';

/// The signature of a function reviving image data from the [cache].
typedef CacheReviver = FutureOr<Uint8List?> Function(CacheManager cache);

/// The signature of a function downloading image data.
typedef ImageDownloader = FutureOr<Uint8List> Function();

/// The signature of a function writing [image] data to the [cache].
typedef CacheWriter = Future<void> Function(CacheManager cache, Uint8List image);

/// The signature of a function building a widget displaying [error].
typedef ErrorWidgetBuilder = Widget? Function(BuildContext context, Object? error);

/// The signature of a function downloading image data from a the nextcloud api through [client].
typedef ApiImageDownloader = FutureOr<DynamiteResponse<Uint8List, dynamic>> Function(NextcloudClient client);

/// A widget painting an Image.
///
/// The image is cached in the [DefaultCacheManager] to avoid expensive
/// fetches.
///
/// See:
///  * [NeonApiImage] for an image widget from an Nextcloud API endpoint.
///  * [NeonUrlImage] for an image widget from an arbitrary URL.
///  * [NeonImageWrapper] for a wrapping widget for images
class NeonCachedImage extends StatefulWidget {
  /// Custom image implementation.
  ///
  /// It is possible to provide custom [reviver] and [writeCache] functions to
  /// adjust the caching.
  NeonCachedImage({
    required ImageDownloader getImage,
    required String cacheKey,
    CacheReviver? reviver,
    CacheWriter? writeCache,
    this.isSvgHint = false,
    this.size,
    this.fit,
    this.svgColorFilter,
    this.errorBuilder,
  })  : image = _customImageGetter(
          reviver,
          getImage,
          writeCache,
          cacheKey,
        ),
        super(key: Key(cacheKey));

  /// The image content.
  final Future<Uint8List> image;

  /// {@template NeonCachedImage.svgHint}
  /// Hint whether the image is an SVG.
  /// {@endtemplate}
  final bool isSvgHint;

  /// {@template NeonCachedImage.size}
  /// Dimensions for the painted image.
  /// {@endtemplate}
  final Size? size;

  /// {@template NeonCachedImage.fit}
  /// How to inscribe the image into the space allocated during layout.
  /// {@endtemplate}
  final BoxFit? fit;

  /// {@template NeonCachedImage.svgColorFilter}
  /// The color filter to use when drawing SVGs.
  /// {@endtemplate}
  final ColorFilter? svgColorFilter;

  /// {@template NeonCachedImage.errorBuilder}
  /// Builder function building the error widget.
  ///
  /// Defaults to a [NeonError] awaiting [image] again onRetry.
  /// {@endtemplate}
  final ErrorWidgetBuilder? errorBuilder;

  static Future<Uint8List> _customImageGetter(
    CacheReviver? checkCache,
    ImageDownloader getImage,
    CacheWriter? writeCache,
    String cacheKey,
  ) async {
    final cached = await checkCache?.call(cacheManager) ?? await _defaultCacheReviver(cacheKey);
    if (cached != null) {
      return cached;
    }

    var data = await getImage();
    try {
      data = utf8.encode(ImageUtils.rewriteSvgDimensions(utf8.decode(data)));
    } catch (_) {}

    unawaited(writeCache?.call(cacheManager, data) ?? _defaultCacheWriter(data, cacheKey));

    return data;
  }

  static Future<Uint8List?> _defaultCacheReviver(String cacheKey) async {
    final cacheFile = await cacheManager.getFileFromCache(cacheKey);
    if (cacheFile != null && cacheFile.validTill.isAfter(DateTime.now())) {
      return cacheFile.file.readAsBytes();
    }

    return null;
  }

  static Future<void> _defaultCacheWriter(
    Uint8List data,
    String cacheKey,
  ) async {
    await cacheManager.putFile(
      cacheKey,
      data,
      maxAge: const Duration(days: 7),
    );
  }

  /// The [CacheManager] instance.
  @visibleForTesting
  static DefaultCacheManager cacheManager = DefaultCacheManager();

  @override
  State<NeonCachedImage> createState() => _NeonCachedImageState();
}

class _NeonCachedImageState extends State<NeonCachedImage> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: widget.image,
        builder: (context, fileSnapshot) {
          if (fileSnapshot.hasError) {
            return _buildError(fileSnapshot.error);
          }

          if (!fileSnapshot.hasData) {
            return SizedBox(
              width: widget.size?.width,
              child: const NeonLinearProgressIndicator(),
            );
          }

          final content = fileSnapshot.requireData;

          try {
            // TODO: Is this safe enough?
            if (widget.isSvgHint || utf8.decode(content).contains('<svg')) {
              return SvgPicture.memory(
                content,
                height: widget.size?.height,
                width: widget.size?.width,
                fit: widget.fit ?? BoxFit.contain,
                colorFilter: widget.svgColorFilter,
              );
            }
          } catch (_) {
            // If the data is not UTF-8
          }

          return Image.memory(
            content,
            height: widget.size?.height,
            width: widget.size?.width,
            fit: widget.fit,
            gaplessPlayback: true,
            errorBuilder: (context, error, stacktrace) => _buildError(error),
          );
        },
      );

  Widget _buildError(Object? error) =>
      widget.errorBuilder?.call(context, error) ??
      NeonError(
        error,
        onRetry: () {
          setState(() {});
        },
        type: NeonErrorType.iconOnly,
        iconSize: widget.size?.shortestSide,
      );
}

/// A widget painting an Image fetched from the Nextcloud API.
///
/// See:
///  * [NeonCachedImage] for a customized image
///  * [NeonUrlImage] for an image widget from an arbitrary URL.
///  * [NeonImageWrapper] for a wrapping widget for images
class NeonApiImage extends StatelessWidget {
  /// Creates a new Neon API image fetching the image with the currently active account.
  ///
  /// See [NeonApiImage.withAccount] to fetch the image using a specific account.
  const NeonApiImage({
    required this.getImage,
    required this.cacheKey,
    this.reviver,
    this.writeCache,
    this.isSvgHint = false,
    this.size,
    this.fit,
    this.svgColorFilter,
    this.errorBuilder,
    super.key,
  }) : account = null;

  /// Creates a new Neon API image fetching the image with the given [account].
  ///
  /// See [NeonApiImage] to fetch the image using the currently active account.
  const NeonApiImage.withAccount({
    required this.getImage,
    required this.cacheKey,
    required Account this.account,
    this.reviver,
    this.writeCache,
    this.isSvgHint = false,
    this.size,
    this.fit,
    this.svgColorFilter,
    this.errorBuilder,
    super.key,
  });

  /// The account to use for the request.
  ///
  /// Defaults to the currently active account in [AccountsBloc.activeAccount].
  final Account? account;

  /// Image downloader.
  final ApiImageDownloader getImage;

  /// Cache key used for [NeonCachedImage.key].
  final String cacheKey;

  /// Custom cache reviver function.
  final CacheReviver? reviver;

  /// Custom cache writer function.
  final CacheWriter? writeCache;

  /// {@macro NeonCachedImage.svgHint}
  final bool isSvgHint;

  /// {@macro NeonCachedImage.size}
  final Size? size;

  /// {@macro NeonCachedImage.fit}
  final BoxFit? fit;

  /// {@macro NeonCachedImage.svgColorFilter}
  final ColorFilter? svgColorFilter;

  /// {@macro NeonCachedImage.errorBuilder}
  final ErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final account = this.account ?? NeonProvider.of<AccountsBloc>(context).activeAccount.value!;

    return NeonCachedImage(
      getImage: () async {
        final response = await getImage(account.client);
        return response.body;
      },
      cacheKey: '${account.id}-$cacheKey',
      reviver: reviver,
      writeCache: writeCache,
      isSvgHint: isSvgHint,
      size: size,
      fit: fit,
      svgColorFilter: svgColorFilter,
      errorBuilder: errorBuilder,
    );
  }
}

/// A widget painting an Image fetched from an arbitrary URL.
///
/// See:
///  * [NeonCachedImage] for a customized image
///  * [NeonApiImage] for an image widget from an Nextcloud API endpoint.
///  * [NeonImageWrapper] for a wrapping widget for images
class NeonUrlImage extends StatelessWidget {
  /// Creates a new Neon URL image with the active account.
  ///
  /// See [NeonUrlImage.withAccount] for using a specific account.
  const NeonUrlImage({
    required this.uri,
    this.reviver,
    this.writeCache,
    this.isSvgHint = false,
    this.size,
    this.fit,
    this.svgColorFilter,
    this.errorBuilder,
    super.key,
  }) : account = null;

  /// Creates a new Neon URL image with the given [account].
  ///
  /// See [NeonUrlImage] for using the active account.
  const NeonUrlImage.withAccount({
    required this.uri,
    required Account this.account,
    this.reviver,
    this.writeCache,
    this.isSvgHint = false,
    this.size,
    this.fit,
    this.svgColorFilter,
    this.errorBuilder,
    super.key,
  });

  /// The account to use for the request.
  ///
  /// Defaults to the currently active account in [AccountsBloc.activeAccount].
  final Account? account;

  /// Image URI.
  ///
  /// This can also be a data URI.
  final Uri uri;

  /// Custom cache reviver function.
  final CacheReviver? reviver;

  /// Custom cache writer function.
  final CacheWriter? writeCache;

  /// {@macro NeonCachedImage.svgHint}
  final bool isSvgHint;

  /// {@macro NeonCachedImage.size}
  final Size? size;

  /// {@macro NeonCachedImage.fit}
  final BoxFit? fit;

  /// {@macro NeonCachedImage.svgColorFilter}
  final ColorFilter? svgColorFilter;

  /// {@macro NeonCachedImage.errorBuilder}
  final ErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final account = this.account ?? NeonProvider.of<AccountsBloc>(context).activeAccount.value!;

    final dataUri = uri.data;

    return NeonCachedImage(
      getImage: () async {
        if (dataUri != null) {
          return dataUri.contentAsBytes();
        }

        final completedUri = account.completeUri(uri);

        final response = await account.client.executeRawRequest(
          'GET',
          completedUri,
          headers: account.getAuthorizationHeaders(completedUri),
          validStatuses: const {200, 201},
        );

        return response.stream.bytes;
      },
      cacheKey: '${account.id}-$uri',
      reviver: reviver,
      writeCache: writeCache,
      isSvgHint: isSvgHint || (dataUri?.mimeType.contains('svg') ?? false),
      size: size,
      fit: fit,
      svgColorFilter: svgColorFilter,
      errorBuilder: errorBuilder,
    );
  }
}

/// Nextcloud image wrapper widget.
///
/// Wraps a child (most commonly an image) into a uniformly styled container.
///
/// See:
///  * [NeonCachedImage] for a customized image
///  * [NeonApiImage] for an image widget from an Nextcloud API endpoint.
///  * [NeonUrlImage] for an image widget from an arbitrary URL.
class NeonImageWrapper extends StatelessWidget {
  /// Creates a new image wrapper.
  const NeonImageWrapper({
    required this.child,
    this.color = Colors.white,
    this.size,
    this.borderRadius,
    super.key,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The color to paint the background area with.
  final Color color;

  /// The size of the widget.
  final Size? size;

  /// The corners of this box are rounded by this [BorderRadius].
  ///
  /// If null defaults to `const BorderRadius.all(Radius.circular(8))`.
  ///
  /// The shape or the [borderRadius] won't clip the children of the decorated [Container].
  /// If the clip is required, insert a clip widget (e.g., [ClipRect], [ClipRRect], [ClipPath])
  /// as the child of the [Container]. Be aware that clipping may be costly in terms of performance.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) => Container(
        height: size?.height,
        width: size?.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(8)),
          color: color,
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
}
