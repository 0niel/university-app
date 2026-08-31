import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/generated/generated.dart';
import 'package:video_player/video_player.dart';

typedef VideoPlayerControllerBuilder =
    VideoPlayerController Function(Uri videoUrl);

class InlineVideo extends StatefulWidget {
  const InlineVideo({
    required this.videoUrl,
    required this.progressIndicator,
    this.videoPlayerControllerBuilder = VideoPlayerController.networkUrl,
    super.key,
  });

  static const double _aspectRatio = 3 / 2;

  final String videoUrl;
  final Widget progressIndicator;
  final VideoPlayerControllerBuilder videoPlayerControllerBuilder;

  @override
  State<InlineVideo> createState() => _InlineVideoState();
}

class _InlineVideoState extends State<InlineVideo> {
  late VideoPlayerController _controller;
  bool _initializationFailed = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPlayerControllerBuilder(
      Uri.parse(widget.videoUrl),
    )..addListener(_onVideoUpdated);
    unawaited(_initializeController());
  }

  Future<void> _initializeController() async {
    try {
      await _controller.initialize();
      if (mounted) {
        setState(() => _isPlaying = _controller.value.isPlaying);
      }
    } on Object {
      if (mounted) setState(() => _initializationFailed = true);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoUpdated);
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onVideoUpdated() {
    if (!mounted || _isPlaying == _controller.value.isPlaying) {
      return;
    }
    setState(() {
      _isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: InlineVideo._aspectRatio,
        child:
            !_initializationFailed && _controller.value.isInitialized
                ? Stack(
                  children: [
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        key: const Key('inlineVideo_gestureDetector'),
                        onTap:
                            _isPlaying
                                ? () => unawaited(_controller.pause())
                                : () => unawaited(_controller.play()),
                        splashColor: Colors.white.withValues(alpha: 0.12),
                        highlightColor: Colors.transparent,
                      ),
                    ),
                    IgnorePointer(
                      child: Center(
                        child: Visibility(
                          visible: !_isPlaying,
                          child: Assets.icons.playIcon.svg(),
                        ),
                      ),
                    ),
                  ],
                )
                : widget.progressIndicator,
      ),
    );
  }
}
