import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:app_ui/app_ui.dart';
import 'package:video_player/video_player.dart';

class NfcMediaPreview extends StatelessWidget {
  final String? filePath;
  final bool isVideo;

  const NfcMediaPreview({super.key, required this.filePath, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (filePath == null) {
      return _DefaultBackgroundPreview();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.visibility_outlined, color: colors.active, size: 22),
                const SizedBox(width: 12),
                Text('Предпросмотр', style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isVideo ? _VideoPreview(filePath: filePath!) : _ImagePreview(filePath: filePath!),
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultBackgroundPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(color: colors.background02, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.visibility_outlined, color: colors.active, size: 22),
              const SizedBox(width: 12),
              Text('Предпросмотр', style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                'Стандартный фон карточки',
                style: AppTextStyle.bodyL.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _ImagePreview extends StatelessWidget {
  final String filePath;

  const _ImagePreview({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(filePath), fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.6)],
              ),
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              'Пример карточки с изображением',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPreview extends StatefulWidget {
  final String filePath;

  const _VideoPreview({required this.filePath});

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.file(File(widget.filePath), videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
          ..setLooping(true)
          ..setVolume(0.0);

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown
      if (mounted) setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                VideoPlayer(_controller),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.6)],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    'Пример карточки с видео',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
