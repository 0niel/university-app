import 'dart:math';
import 'dart:io' as io;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:app_ui/app_ui.dart';
import 'package:video_player/video_player.dart';

class NfcPassCard extends StatelessWidget {
  const NfcPassCard({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.onClick,
    required this.localFilePath,
    required this.isVideo,
    required this.videoController,
    required this.initializeVideoFuture,
  });

  final String deviceId;
  final String deviceName;
  final VoidCallback onClick;

  final String? localFilePath;

  final bool isVideo;

  final VideoPlayerController? videoController;
  final Future<void>? initializeVideoFuture;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Приложите телефон\nк турникету",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        _AnimatedRainbowBorder(
          borderWidth: 4,
          borderRadius: 16,
          child: Container(
            width: 200,
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: localFilePath == null ? Colors.blueAccent : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildCardBackground(),
                  ),
                  Positioned.fill(
                    child: _buildCardContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: onClick,
          child: const Text("Отвязать устройство"),
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCardBackground() {
    if (localFilePath == null) {
      return const SizedBox.shrink();
    }

    if (isVideo) {
      if (videoController == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return FutureBuilder(
        future: videoController!.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            videoController!.play();
            return Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: videoController!.value.size.width,
                      height: videoController!.value.size.height,
                      child: VideoPlayer(videoController!),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ).animate().fadeIn(duration: 500.ms),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ).animate().fadeIn(duration: 500.ms);
    } else {
      return Stack(
        children: [
          Image.file(
            io.File(localFilePath!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ).animate().fadeIn(duration: 500.ms),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
          ).animate().fadeIn(duration: 500.ms),
        ],
      );
    }
  }

  Widget _buildCardContent() {
    String displayId = deviceId;

    displayId = displayId.split('').mapIndexed((index, char) {
      if (index < displayId.length / 2) {
        return char;
      }
      return '*';
    }).join();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Image.network(
              'https://attendance-app.mirea.ru/static/media/logo.93dc935b283358249632.png',
              width: 32,
            ).animate().fadeIn(duration: 500.ms),
          ),
          Positioned(
            top: 64,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: pi / 2,
                child: const Icon(Icons.wifi, size: 80, color: Colors.white).animate().fadeIn(duration: 500.ms),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID", style: AppTextStyle.bodyBold.copyWith(color: Colors.white))
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms),
                const SizedBox(height: 4),
                Text(displayId, style: AppTextStyle.body.copyWith(color: Colors.white))
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 500.ms),
                const SizedBox(height: 16),
                Text("Устройство", style: AppTextStyle.bodyBold.copyWith(color: Colors.white))
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms),
                const SizedBox(height: 4),
                Text(deviceName, style: AppTextStyle.body.copyWith(color: Colors.white))
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedRainbowBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final double borderRadius;

  const _AnimatedRainbowBorder({
    required this.child,
    this.borderWidth = 4,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      onPlay: (controller) => controller.repeat(),
      effects: [
        CustomEffect(
          begin: 0,
          end: 1,
          duration: const Duration(seconds: 4),
          curve: Curves.linear,
          builder: (context, value, child) {
            final angle = value * 2 * pi;
            return Container(
              padding: EdgeInsets.all(borderWidth),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius + borderWidth),
                gradient: SweepGradient(
                  startAngle: 0,
                  endAngle: 2 * pi,
                  transform: GradientRotation(angle),
                  colors: const [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                    Colors.red,
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: child,
              ),
            );
          },
        ),
      ],
      child: child,
    );
  }
}
