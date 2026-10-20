import 'dart:async';
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:video_player/video_player.dart';

part 'nfc_card_background.dart';
part 'nfc_card_content.dart';
part 'nfc_card_decoration.dart';

class NfcPassCard extends StatelessWidget {
  const NfcPassCard({
    required this.passId,
    required this.localFilePath,
    required this.isVideo,
    this.emulationOff = false,
    super.key,
  });

  final String passId;
  final String? localFilePath;
  final bool isVideo;
  final bool emulationOff;

  static const double aspectRatio = 1.6;
  static const double maxWidth = 440;
  static const double previewWidth = 280;
  static const double textScrimOpacity = .72;

  static LinearGradient backgroundGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.alphaBlend(
          context.colors.accent.withValues(alpha: .16),
          AppColors.dark.surface2,
        ),
        AppColors.dark.surface,
        AppColors.dark.canvas,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filePath = localFilePath;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) => AppGlassSurface(
            key: const ValueKey('nfc-pass-wallet'),
            borderRadius: AppRadius.card,
            color: AppColors.dark.surface,
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card - 1.5),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: backgroundGradient(context),
                        ),
                        child: CustomPaint(
                          painter: _NfcCardDecoration(
                            accent: context.colors.accent,
                          ),
                        ),
                      ),
                    ),
                    if (filePath != null) ...[
                      Positioned.fill(
                        child: _NfcCardBackground(
                          filePath: filePath,
                          isVideo: isVideo,
                        ),
                      ),
                      const Positioned.fill(
                        child: ColoredBox(
                          key: ValueKey('nfc-pass-media-scrim'),
                          color: Color.fromRGBO(0, 0, 0, textScrimOpacity),
                        ),
                      ),
                    ],
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxWidth / aspectRatio - 3,
                      ),
                      child: _NfcCardContent(
                        passId: passId,
                        emulationOff: emulationOff,
                      ),
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
