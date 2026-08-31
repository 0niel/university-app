import 'dart:async';
import 'dart:io' as io;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:video_player/video_player.dart';

part 'nfc_card_background.dart';
part 'nfc_card_content.dart';
part 'nfc_card_field.dart';
part 'nfc_ready_indicator.dart';

class NfcPassCard extends StatelessWidget {
  const NfcPassCard({
    required this.passId,
    required this.deviceName,
    required this.localFilePath,
    required this.isVideo,
    super.key,
  });

  final String passId;
  final String deviceName;
  final String? localFilePath;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final filePath = localFilePath;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.ninja.accentSoft,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Stack(
        children: [
          if (filePath != null)
            Positioned.fill(
              child: _NfcCardBackground(
                filePath: filePath,
                isVideo: isVideo,
              ),
            ),
          _NfcCardContent(passId: passId, deviceName: deviceName),
        ],
      ),
    );
  }
}
