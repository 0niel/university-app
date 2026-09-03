import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NfcMediaSelector extends StatelessWidget {
  const NfcMediaSelector({
    required this.onSelectMedia,
    required this.hasMedia,
    required this.isVideo,
    this.onRemoveMedia,
    super.key,
  });

  final VoidCallback onSelectMedia;
  final VoidCallback? onRemoveMedia;
  final bool hasMedia;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final onRemove = onRemoveMedia;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.nfcPassMediaTitle,
          style: AppText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.nfcPassMediaDescription,
          style: AppText.subtext.copyWith(
            height: 1.45,
            color: colors.muted,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          children: [
            Expanded(
              child: NinjaButton.secondary(
                label: hasMedia
                    ? l10n.nfcPassMediaChange
                    : l10n.nfcPassMediaSelect,
                size: NinjaButtonSize.medium,
                expanded: true,
                icon: AppLineIconWidget(
                  isVideo ? AppLineIcon.video : AppLineIcon.image,
                ),
                onPressed: onSelectMedia,
              ),
            ),
            if (hasMedia && onRemove != null) ...[
              const SizedBox(width: AppSpacing.gap),
              Expanded(
                child: NinjaButton.destructiveOutline(
                  label: l10n.nfcPassMediaRemove,
                  size: NinjaButtonSize.medium,
                  expanded: true,
                  onPressed: onRemove,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
