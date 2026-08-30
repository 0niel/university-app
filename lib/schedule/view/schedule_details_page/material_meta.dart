part of '../schedule_details_page.dart';

class _MaterialMeta extends StatelessWidget {
  const _MaterialMeta({required this.material});

  final LessonMaterial material;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final style = NinjaText.subtext.copyWith(
      fontSize: 11.5,
      color: colors.muted,
    );
    return Row(
      children: [
        Text(_formatFileSize(context.l10n, material.fileSize), style: style),
        const SizedBox(width: 12),
        AppLineIconWidget(.download, size: 12, color: colors.muted),
        const SizedBox(width: 4),
        Text('${material.downloadCount}', style: NinjaText.tabular(style)),
        if (material.likeCount > 0) ...[
          const SizedBox(width: 12),
          AppLineIconWidget(.heart, size: 12, color: colors.muted),
          const SizedBox(width: 4),
          Text('${material.likeCount}', style: NinjaText.tabular(style)),
        ],
      ],
    );
  }
}
