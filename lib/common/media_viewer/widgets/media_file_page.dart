import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_item.dart';
import 'package:rtu_mirea_app/common/media_viewer/services/media_format.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MediaFilePage extends StatelessWidget {
  const MediaFilePage({
    required this.item,
    required this.onOpen,
    required this.onDownload,
    this.opening = false,
    this.downloading = false,
    super.key,
  });

  final MediaItem item;
  final VoidCallback onOpen;
  final VoidCallback onDownload;
  final bool opening;
  final bool downloading;

  @override
  Widget build(BuildContext context) {
    const dark = AppColors.dark;
    final l10n = context.l10n;
    final label = item.title?.trim().isNotEmpty == true
        ? item.title!
        : (item.fileName ?? '');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: dark.surface2,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              alignment: Alignment.center,
              child: AppLineIconWidget(
                AppLineIcon.clipboard,
                size: 36,
                color: dark.muted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.title.copyWith(color: dark.ink),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              formatMediaSize(l10n, item.sizeBytes),
              style: AppText.subtext.copyWith(color: dark.muted),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              label: l10n.open,
              loading: opening,
              expanded: true,
              onPressed: onOpen,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.secondary(
              label: l10n.knowledgeDownload,
              loading: downloading,
              expanded: true,
              onPressed: onDownload,
            ),
          ],
        ),
      ),
    );
  }
}
