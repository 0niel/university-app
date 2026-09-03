import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_pass_card.dart';
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
    final colors = context.colors;
    final path = filePath;

    final Widget preview;
    final String caption;
    if (path == null) {
      preview = DecoratedBox(
        decoration: BoxDecoration(
          gradient: NfcPassCard.backgroundGradient(context),
        ),
      );
      caption = l10n.nfcPassDefaultBackground;
    } else if (isVideo) {
      preview = NfcVideoPreview(filePath: path);
      caption = l10n.nfcPassPreviewVideoHint;
    } else {
      preview = Image.file(
        File(path),
        fit: BoxFit.cover,
        semanticLabel: l10n.nfcPassPreviewImageHint,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.nfcPassMediaUnavailable,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: colors.muted),
            ),
          ),
        ),
      );
      caption = l10n.nfcPassPreviewImageHint;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.nfcPassPreviewTitle,
          style: AppText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.gap),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: NfcPassCard.previewWidth,
            ),
            child: AspectRatio(
              aspectRatio: NfcPassCard.aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: preview,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          caption,
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
