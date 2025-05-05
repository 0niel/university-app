import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/splash_video/bloc/splash_video_bloc.dart';
import 'package:video_player/video_player.dart';

class SplashVideoPage extends StatefulWidget {
  const SplashVideoPage({super.key, required this.videoPath});

  final String videoPath;

  @override
  State<SplashVideoPage> createState() => _SplashVideoPageState();
}

class _SplashVideoPageState extends State<SplashVideoPage> {
  late VideoPlayerController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
        // Use a file from the local device
        File(widget.videoPath),
      )
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });

    // Set a timer to ensure the video shows for at most 2 seconds
    _timer = Timer(const Duration(seconds: 2), () {
      _completeAndNavigate();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _completeAndNavigate() {
    if (mounted) {
      context.read<SplashVideoBloc>().add(const MarkSplashVideoShown());
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: _completeAndNavigate),
            ),
          ),
        ],
      ),
    );
  }
}
