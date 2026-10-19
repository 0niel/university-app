import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class KitNetworkImage extends StatefulWidget {
  const KitNetworkImage({
    required this.src,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = AppRadius.field,
    this.aspectRatio,
    this.semanticLabel,
    this.enablePreview = true,
    this.onTap,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final double? aspectRatio;
  final String? semanticLabel;
  final bool enablePreview;
  final VoidCallback? onTap;

  @override
  State<KitNetworkImage> createState() => _KitNetworkImageState();
}

class _KitNetworkImageState extends State<KitNetworkImage> {
  final _heroTag = Object();

  bool _hasParentAction(BuildContext context) {
    var interactive = false;
    context.visitAncestorElements((element) {
      final ancestor = element.widget;
      interactive = switch (ancestor) {
        GestureDetector(:final onTap, :final onDoubleTap, :final onLongPress) =>
          onTap != null || onDoubleTap != null || onLongPress != null,
        InkResponse(:final onTap, :final onLongPress) =>
          onTap != null || onLongPress != null,
        _ => false,
      };
      return !interactive;
    });
    return interactive;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.radius);
    Widget placeholder() => ImagePlaceholder(
      width: widget.width,
      height: widget.height ?? (widget.aspectRatio == null ? 160 : null),
      borderRadius: borderRadius,
    );
    final uri = Uri.tryParse(widget.src);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty) {
      return _framed(placeholder());
    }
    final image = Image.network(
      widget.src,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      semanticLabel: widget.semanticLabel,
      errorBuilder: (_, _, _) => placeholder(),
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : placeholder(),
    );
    final framed = _framed(ClipRRect(borderRadius: borderRadius, child: image));
    final preview = widget.enablePreview && !_hasParentAction(context);
    final onTap = widget.onTap;
    if (onTap == null && !preview) return framed;
    return AppPressable(
      semanticsLabel: widget.semanticLabel,
      onTap:
          onTap ??
          () => unawaited(
            Navigator.of(context, rootNavigator: true).push(
              ImagesViewGallery.route(
                imageUrls: [widget.src],
                initialIndex: 0,
                title: widget.semanticLabel,
                heroTags: {0: _heroTag},
                reducedMotion:
                    MediaQuery.disableAnimationsOf(context) ||
                    MediaQuery.accessibleNavigationOf(context),
              ),
            ),
          ),
      child: preview && onTap == null
          ? Hero(tag: _heroTag, child: framed)
          : framed,
    );
  }

  Widget _framed(Widget child) {
    final ratio = widget.aspectRatio;
    if (ratio == null) return child;
    return AspectRatio(aspectRatio: ratio, child: child);
  }
}
