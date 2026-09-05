import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_state_widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MediaImagePage extends StatefulWidget {
  const MediaImagePage({
    required this.url,
    required this.onDismissed,
    this.heroTag,
    this.onPrevious,
    this.onNext,
    this.onTap,
    this.onDismissProgress,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    super.key,
  });

  final String url;
  final Object? heroTag;
  final VoidCallback onDismissed;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onTap;
  final ValueChanged<double>? onDismissProgress;
  final VoidCallback? onHorizontalDragStart;
  final ValueChanged<double>? onHorizontalDragUpdate;
  final ValueChanged<double>? onHorizontalDragEnd;

  @override
  State<MediaImagePage> createState() => _MediaImagePageState();
}

class _MediaImagePageState extends State<MediaImagePage> {
  int _retryCount = 0;

  Future<void> _retry() async {
    await CachedNetworkImageProvider(widget.url).evict();
    if (mounted) setState(() => _retryCount++);
  }

  @override
  Widget build(BuildContext context) => AppZoomableImage(
    key: ValueKey((widget.url, _retryCount)),
    imageProvider: CachedNetworkImageProvider(widget.url),
    heroTag: widget.heroTag,
    onDismissed: widget.onDismissed,
    onPrevious: widget.onPrevious,
    onNext: widget.onNext,
    onTap: widget.onTap,
    onDismissProgress: widget.onDismissProgress,
    onHorizontalDragStart: widget.onHorizontalDragStart,
    onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
    onHorizontalDragEnd: widget.onHorizontalDragEnd,
    loadingBuilder: (context, event) {
      final total = event?.expectedTotalBytes;
      return MediaLoadingState(
        progress: total == null || total == 0
            ? null
            : event!.cumulativeBytesLoaded / total,
      );
    },
    errorBuilder: (context, error, stackTrace) => MediaErrorState(
      title: context.l10n.lessonDetailsOpenFailed,
      retryLabel: context.l10n.retry,
      onRetry: () => unawaited(_retry()),
    ),
  );
}
