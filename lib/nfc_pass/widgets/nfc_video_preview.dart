import 'dart:async';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:video_player/video_player.dart';

class NfcVideoPreview extends StatefulWidget {
  const NfcVideoPreview({required this.filePath, super.key});

  final String filePath;

  @override
  State<NfcVideoPreview> createState() => _NfcVideoPreviewState();
}

class _NfcVideoPreviewState extends State<NfcVideoPreview> {
  late VideoPlayerController _controller;
  late Future<void> _initFuture;
  bool _reduceMotion = true;

  @override
  void initState() {
    super.initState();
    _setUpVideo();
  }

  void _setUpVideo() {
    _controller = VideoPlayerController.file(
      File(widget.filePath),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _initFuture = _initializeController(_controller);
  }

  @override
  void didUpdateWidget(NfcVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath == widget.filePath) return;
    unawaited(_controller.dispose());
    _setUpVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (_controller.value.isInitialized) {
      unawaited(_reduceMotion ? _controller.pause() : _controller.play());
    }
  }

  Future<void> _initializeController(VideoPlayerController controller) async {
    await controller.initialize();
    if (!mounted || !identical(_controller, controller)) return;
    await controller.setLooping(true);
    await controller.setVolume(0);
    if (!mounted || !identical(_controller, controller)) return;
    if (!_reduceMotion) await controller.play();
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _initFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState != .done) {
        return ColoredBox(color: context.colors.surface);
      }
      if (snapshot.hasError ||
          !_controller.value.isInitialized ||
          _controller.value.size.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              context.l10n.nfcPassMediaUnavailable,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: context.colors.muted),
            ),
          ),
        );
      }
      return FittedBox(
        fit: .cover,
        clipBehavior: .hardEdge,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      );
    },
  );
}
