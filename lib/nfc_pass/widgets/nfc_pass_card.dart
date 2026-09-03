import 'dart:async';
import 'dart:io' as io;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:video_player/video_player.dart';

part 'nfc_card_background.dart';
part 'nfc_card_content.dart';

class NfcPassCard extends StatelessWidget {
  const NfcPassCard({
    required this.passId,
    required this.localFilePath,
    required this.isVideo,
    super.key,
  });

  final String passId;
  final String? localFilePath;
  final bool isVideo;

  static const double aspectRatio = 5 / 8;
  static const double maxWidth = 390;
  static const double previewWidth = 180;
  static const double textScrimOpacity = .68;

  static LinearGradient backgroundGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        context.colors.accent,
        context.colors.practice,
        context.colors.lab,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filePath = localFilePath;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: AspectRatio(
          key: const ValueKey('nfc-pass-portrait'),
          aspectRatio: aspectRatio,
          child: AppCard(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: backgroundGradient(context),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (filePath != null)
                      _NfcCardBackground(
                        filePath: filePath,
                        isVideo: isVideo,
                      ),
                    _NfcCardContent(
                      passId: passId,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
