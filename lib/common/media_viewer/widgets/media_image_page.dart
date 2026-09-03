import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_state_widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MediaImagePage extends StatefulWidget {
  const MediaImagePage({
    required this.url,
    required this.onDismissed,
    super.key,
  });

  final String url;
  final VoidCallback onDismissed;

  @override
  State<MediaImagePage> createState() => _MediaImagePageState();
}

class _MediaImagePageState extends State<MediaImagePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dismiss = AnimationController.unbounded(
    vsync: this,
  );

  bool get _reducedMotion =>
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);

  @override
  void dispose() {
    _dismiss.dispose();
    super.dispose();
  }

  Future<void> _retry() async {
    await CachedNetworkImageProvider(widget.url).evict();
    if (mounted) setState(() {});
  }

  void _dragStart(DragStartDetails _) => _dismiss.stop();

  void _dragUpdate(DragUpdateDetails details) {
    _dismiss.value = (_dismiss.value + details.delta.dy).clamp(
      0,
      MediaQuery.sizeOf(context).height,
    );
  }

  Future<void> _dragEnd(DragEndDetails details) async {
    final close =
        _dismiss.value > 110 ||
        (_dismiss.value > 24 && (details.primaryVelocity ?? 0) > 900);
    await _dismiss.animateTo(
      close ? MediaQuery.sizeOf(context).height : 0,
      duration: _reducedMotion
          ? Duration.zero
          : Duration(milliseconds: close ? 180 : 220),
      curve: Curves.easeOutCubic,
    );
    if (close && mounted) widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onVerticalDragStart: _dragStart,
      onVerticalDragUpdate: _dragUpdate,
      onVerticalDragEnd: (details) => unawaited(_dragEnd(details)),
      onVerticalDragCancel: () => unawaited(_dragEnd(DragEndDetails())),
      child: AnimatedBuilder(
        animation: _dismiss,
        builder: (context, child) {
          final height = MediaQuery.sizeOf(context).height;
          final ratio = height == 0
              ? 0.0
              : (_dismiss.value / height).clamp(
                  0.0,
                  1.0,
                );
          return Opacity(
            opacity: 1 - ratio * 0.7,
            child: Transform.translate(
              offset: Offset(0, _dismiss.value),
              child: child,
            ),
          );
        },
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.url),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          loadingBuilder: (context, event) {
            final total = event?.expectedTotalBytes;
            final downloaded = event?.cumulativeBytesLoaded;
            final progress = total == null || total == 0 || downloaded == null
                ? null
                : downloaded / total;
            return MediaLoadingState(progress: progress);
          },
          errorBuilder: (context, error, stackTrace) => MediaErrorState(
            title: l10n.lessonDetailsOpenFailed,
            retryLabel: l10n.retry,
            onRetry: () => unawaited(_retry()),
          ),
        ),
      ),
    );
  }
}
