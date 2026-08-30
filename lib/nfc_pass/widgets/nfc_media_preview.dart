import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_video_preview.dart';

class NfcMediaPreview extends StatelessWidget {
  const NfcMediaPreview({
    required this.filePath,
    required this.isVideo,
    super.key,
  });

  final String? filePath;

  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;
    final path = filePath;

    final Widget preview;
    final String caption;
    if (path == null) {
      preview = ColoredBox(color: colors.surface);
      caption = l10n.nfcPassDefaultBackground;
    } else if (isVideo) {
      preview = NfcVideoPreview(filePath: path);
      caption = l10n.nfcPassPreviewVideoHint;
    } else {
      preview = Image.file(
        File(path),
        fit: BoxFit.cover,
        semanticLabel: l10n.nfcPassPreviewImageHint,
      );
      caption = l10n.nfcPassPreviewImageHint;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.nfcPassPreviewTitle,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(NinjaRadius.card),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: preview,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          style: NinjaText.subtext.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
