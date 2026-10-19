import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:pdfx/pdfx.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_pdf_document.dart';
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
  MediaPdfDocument? _document;
  int _loadRevision = 0;
  Object? _error;
  bool _loading = true;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant MediaPdfPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) unawaited(_load());
  }

  Future<void> _load() async {
    final revision = ++_loadRevision;
    final previous = _document;
    setState(() {
      _document = null;
      _loading = true;
      _error = null;
      _progress = 0;
    });
    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(previous.close());
      });
    }
    try {
      final file = await downloadMediaFile(
        widget.url,
        onProgress: (value) {
          if (mounted && revision == _loadRevision) {
            setState(() => _progress = value);
          }
        },
      );
      if (!mounted || revision != _loadRevision) return;
      final document = await PdfDocument.openFile(file.path);
      if (!mounted || revision != _loadRevision) {
        await document.close();
        return;
      }
      setState(() {
        _document = MediaPdfDocument(document);
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted || revision != _loadRevision) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    unawaited(_document?.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_loading) return MediaLoadingState(progress: _progress);
    final document = _document;
    if (_error != null || document == null) {
      return MediaErrorState(
        title: l10n.lessonDetailsOpenFailed,
        retryLabel: l10n.retry,
        onRetry: () => unawaited(_load()),
      );
    }
    final controller = document.controller;
    const dark = AppColors.dark;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: PdfViewPinch(
            key: ValueKey(controller),
            controller: controller,
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
        ),
        if (document.document.pagesCount > 1)
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
                child: ValueListenableBuilder<int>(
                  valueListenable: controller.pageListenable,
                  builder: (context, page, _) => Text(
                    l10n.mediaViewerIndex(page, document.document.pagesCount),
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
          ),
      ],
    );
  }
}
