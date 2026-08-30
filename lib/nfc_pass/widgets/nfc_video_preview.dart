import 'dart:async';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NfcVideoPreview extends StatefulWidget {
  const NfcVideoPreview({required this.filePath, super.key});

  final String filePath;

  @override
  State<NfcVideoPreview> createState() => _NfcVideoPreviewState();
}

class _NfcVideoPreviewState extends State<NfcVideoPreview> {
  late final VideoPlayerController _controller;
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(widget.filePath),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _initFuture = _initializeController();
  }

  Future<void> _initializeController() async {
    await _controller.initialize();
    if (!mounted) return;
    await _controller.setLooping(true);
    await _controller.setVolume(0);
    if (mounted) await _controller.play();
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
        return ColoredBox(color: context.ninja.surface);
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
