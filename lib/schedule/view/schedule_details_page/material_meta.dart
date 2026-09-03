part of '../schedule_details_page.dart';

class _MaterialMeta extends StatelessWidget {
  const _MaterialMeta({required this.material});

  final LessonMaterial material;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = AppText.subtext.copyWith(
      fontSize: 11.5,
      color: colors.muted,
    );
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(_formatFileSize(context.l10n, material.fileSize), style: style),
        AppLineIconWidget(.download, size: 12, color: colors.muted),
        Text('${material.downloadCount}', style: AppText.tabular(style)),
        if (material.likeCount > 0) ...[
          AppLineIconWidget(.heart, size: 12, color: colors.muted),
          Text('${material.likeCount}', style: AppText.tabular(style)),
        ],
      ],
    );
  }
}
