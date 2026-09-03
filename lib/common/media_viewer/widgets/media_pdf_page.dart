import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:pdfx/pdfx.dart';
import 'package:rtu_mirea_app/common/media_viewer/services/media_download.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_state_widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MediaPdfPage extends StatefulWidget {
  const MediaPdfPage({required this.url, super.key});

  final String url;

  @override
  State<MediaPdfPage> createState() => _MediaPdfPageState();
}

class _MediaPdfPageState extends State<MediaPdfPage> {
  PdfControllerPinch? _controller;
  int _page = 1;
  int _pageCount = 0;
  Object? _error;
  bool _loading = true;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _progress = 0;
    });
    try {
      final file = await downloadMediaFile(
        widget.url,
        onProgress: (value) {
          if (mounted) setState(() => _progress = value);
        },
      );
      final documentFuture = PdfDocument.openFile(file.path);
      final controller = PdfControllerPinch(document: documentFuture);
      controller.pageListenable.addListener(_onPageChanged);
      final document = await documentFuture;
      if (!mounted) {
        await document.close();
        return;
      }
      setState(() {
        _controller = controller;
        _pageCount = document.pagesCount;
        _page = controller.pageListenable.value;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  void _onPageChanged() {
    final controller = _controller;
    if (controller == null || !mounted) return;
    setState(() => _page = controller.pageListenable.value);
  }

  @override
  void dispose() {
    _controller
      ?..pageListenable.removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_loading) return MediaLoadingState(progress: _progress);
    final controller = _controller;
    if (_error != null || controller == null) {
      return MediaErrorState(
        title: l10n.lessonDetailsOpenFailed,
        retryLabel: l10n.retry,
        onRetry: () => unawaited(_load()),
      );
    }
    const dark = AppColors.dark;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: PdfViewPinch(
            controller: controller,
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
        ),
        if (_pageCount > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: dark.surface2,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  l10n.mediaViewerIndex(_page, _pageCount),
                  style: AppText.tabular(
                    AppText.subtext.copyWith(
                      color: dark.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
