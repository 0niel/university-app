part of '../schedule_details_page.dart';

class _MaterialInlineRow extends StatelessWidget {
  const _MaterialInlineRow({
    required this.material,
    required this.onTap,
  });

  final LessonMaterial material;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            _FileBadge(material: material, size: 40),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _MaterialText(material: material, compact: true)),
            const SizedBox(width: AppSpacing.sm),
            AppLineIconWidget(
              AppLineIcon.download,
              size: 16,
              color: colors.muted2,
            ),
          ],
        ),
      ),
    );
  }
}
