import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_item.dart';
import 'package:rtu_mirea_app/common/media_viewer/services/media_download.dart';
import 'package:rtu_mirea_app/common/media_viewer/services/media_format.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_file_page.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_image_page.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_pdf_page.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_top_bar.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_video_page.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

export 'media_item.dart';

Future<void> showMediaViewer(
  BuildContext context, {
  required List<MediaItem> items,
  int initialIndex = 0,
  ValueChanged<MediaItem>? onDownload,
}) {
  if (items.isEmpty) return Future<void>.value();
  return Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: const Color(0x00000000),
      transitionDuration:
          MediaQuery.disableAnimationsOf(context) ||
              MediaQuery.accessibleNavigationOf(context)
          ? Duration.zero
          : NinjaMotion.base,
      reverseTransitionDuration:
          MediaQuery.disableAnimationsOf(context) ||
              MediaQuery.accessibleNavigationOf(context)
          ? Duration.zero
          : NinjaMotion.fast,
      pageBuilder: (_, _, _) => MediaViewerPage(
        items: items,
        initialIndex: initialIndex.clamp(0, items.length - 1),
        onDownload: onDownload,
      ),
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: NinjaMotion.enter),
        child: child,
      ),
    ),
  );
}

class MediaViewerPage extends StatefulWidget {
  const MediaViewerPage({
    required this.items,
    required this.initialIndex,
    this.onDownload,
    super.key,
  });

  final List<MediaItem> items;
  final int initialIndex;
  final ValueChanged<MediaItem>? onDownload;

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;
  bool _downloading = false;
  bool _sharing = false;
  bool _opening = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  MediaItem get _current => widget.items[_index];

  void _close() {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  void _fail() {
    if (!mounted) return;
    showNinjaToast(
      context,
      showCheck: false,
      message: context.l10n.mediaViewerDownloadFailed,
    );
  }

  Future<void> _download() async {
    final item = _current;
    final onDownload = widget.onDownload;
    setState(() => _downloading = true);
    try {
      if (onDownload != null) {
        onDownload(item);
      } else {
        await saveMediaItem(item);
      }
      if (mounted) {
        showNinjaToast(context, message: context.l10n.mediaViewerSaved);
      }
    } on Object {
      _fail();
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      await shareMediaItem(_current);
    } on Object {
      _fail();
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _openExternally() async {
    setState(() => _opening = true);
    try {
      final opened = await launchUrl(
        Uri.parse(_current.url),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) _fail();
    } on Object {
      _fail();
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  Widget _buildPage(MediaItem item) {
    return switch (item.kind) {
      MediaKind.image => MediaImagePage(url: item.url, onDismissed: _close),
      MediaKind.video => MediaVideoPage(url: item.url),
      MediaKind.pdf => MediaPdfPage(url: item.url),
      MediaKind.file => MediaFilePage(
        item: item,
        opening: _opening,
        downloading: _downloading,
        onOpen: () => unawaited(_openExternally()),
        onDownload: () => unawaited(_download()),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final item = _current;
    final sizeLabel = formatMediaSize(l10n, item.sizeBytes);
    final subtitle = [
      if (item.sizeBytes != null) sizeLabel,
      if (widget.items.length > 1)
        l10n.mediaViewerIndex(_index + 1, widget.items.length),
    ].join(' · ');
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        extensions: const [AppColors.dark],
      ),
      child: ColoredBox(
        color: AppColors.amoledCanvas,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.items.length,
                  onPageChanged: (index) => setState(() => _index = index),
                  itemBuilder: (context, index) =>
                      _buildPage(widget.items[index]),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: MediaTopBar(
                  title: item.title?.trim().isNotEmpty == true
                      ? item.title!
                      : (item.fileName ?? ''),
                  subtitle: subtitle,
                  onClose: _close,
                  closeSemanticsLabel: l10n.storyClose,
                  actions: [
                    MediaTopBarAction(
                      icon: AppLineIcon.download,
                      tooltip: l10n.knowledgeDownload,
                      busy: _downloading,
                      onPressed: () => unawaited(_download()),
                    ),
                    MediaTopBarAction(
                      icon: AppLineIcon.share,
                      tooltip: l10n.share,
                      busy: _sharing,
                      onPressed: () => unawaited(_share()),
                    ),
                    MediaTopBarAction(
                      icon: AppLineIcon.external,
                      tooltip: l10n.mediaViewerOpenExternally,
                      busy: _opening,
                      onPressed: () => unawaited(_openExternally()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
