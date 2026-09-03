import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_state_widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:video_player/video_player.dart';

class MediaVideoPage extends StatefulWidget {
  const MediaVideoPage({required this.url, super.key});

  final String url;

  @override
  State<MediaVideoPage> createState() => _MediaVideoPageState();
}

class _MediaVideoPageState extends State<MediaVideoPage> {
  VideoPlayerController? _video;
  ChewieController? _chewie;
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      const dark = AppColors.dark;
      final chewie = ChewieController(
        videoPlayerController: controller,
        aspectRatio: controller.value.aspectRatio,
        autoPlay: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: dark.accent,
          handleColor: dark.accent,
          bufferedColor: dark.surface2,
          backgroundColor: dark.line,
        ),
      );
      setState(() {
        _video = controller;
        _chewie = chewie;
        _loading = false;
      });
    } on Object catch (error) {
      await controller.dispose();
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _chewie?.dispose();
    unawaited(_video?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const MediaLoadingState();
    final chewie = _chewie;
    if (_error != null || chewie == null) {
      return MediaErrorState(
        title: context.l10n.lessonDetailsOpenFailed,
        retryLabel: context.l10n.retry,
        onRetry: () => unawaited(_init()),
      );
    }
    return Center(child: Chewie(controller: chewie));
  }
}
