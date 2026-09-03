part of '../schedule_details_page.dart';

class _MaterialText extends StatelessWidget {
  const _MaterialText({required this.material, this.compact = false});

  final LessonMaterial material;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = compact
        ? '${_formatFileSize(context.l10n, material.fileSize)} · '
        : '';
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(
          material.title,
          maxLines: 1,
          overflow: .ellipsis,
          style: AppText.cell.copyWith(color: colors.ink),
        ),
        const SizedBox(height: ScheduleMetrics.compactGap),
        Text(
          '$size${material.authorName} · '
          '${_relativeWhen(context.l10n, material.createdAt)}',
          maxLines: 1,
          overflow: .ellipsis,
          style: AppText.subtext.copyWith(
            fontSize: 12,
            color: colors.muted,
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: AppSpacing.xsm),
          _MaterialMeta(material: material),
        ],
      ],
    );
  }
}
