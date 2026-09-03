part of 'nfc_pass_card.dart';

class _NfcCardBackground extends StatefulWidget {
  const _NfcCardBackground({required this.filePath, required this.isVideo});

  final String filePath;
  final bool isVideo;

  @override
  State<_NfcCardBackground> createState() => _NfcCardBackgroundState();
}

class _NfcCardBackgroundState extends State<_NfcCardBackground> {
  VideoPlayerController? _controller;
  Future<void>? _initFuture;
  bool _reduceMotion = true;

  @override
  void initState() {
    super.initState();
    _setUpVideo();
  }

  @override
  void didUpdateWidget(_NfcCardBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath ||
        oldWidget.isVideo != widget.isVideo) {
      unawaited(_controller?.dispose());
      _controller = null;
      _initFuture = null;
      _setUpVideo();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      unawaited(_reduceMotion ? controller.pause() : controller.play());
    }
  }

  void _setUpVideo() {
    if (!widget.isVideo) return;
    final controller = VideoPlayerController.file(
      io.File(widget.filePath),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = controller;
    _initFuture = _initializeController(controller);
  }

  Future<void> _initializeController(VideoPlayerController controller) async {
    await controller.initialize();
    if (!mounted || !identical(_controller, controller)) return;
    await controller.setVolume(0);
    await controller.setLooping(true);
    if (!mounted || !identical(_controller, controller)) return;
    if (!_reduceMotion) await controller.play();
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMedia();
  }

  Widget _buildMedia() {
    if (!widget.isVideo) {
      final image = Image.file(
        io.File(widget.filePath),
        fit: .cover,
        semanticLabel: context.l10n.nfcPassPreviewImageHint,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      );
      return _reduceMotion ? image : image.animate().fadeIn(duration: 400.ms);
    }

    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != .done ||
            snapshot.hasError ||
            !controller.value.isInitialized ||
            controller.value.size.isEmpty) {
          return const SizedBox.shrink();
        }
        final video = FittedBox(
          fit: .cover,
          clipBehavior: .hardEdge,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        );
        return _reduceMotion ? video : video.animate().fadeIn(duration: 400.ms);
      },
    );
  }
}
