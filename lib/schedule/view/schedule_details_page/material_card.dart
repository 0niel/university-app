part of '../schedule_details_page.dart';

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({
    required this.material,
    required this.onOpen,
    required this.onDownload,
  });
  final LessonMaterial material;
  final VoidCallback onOpen;
  final VoidCallback onDownload;
  @override
  Widget build(BuildContext context) => AppPressable(
    onTap: onOpen,
    child: Container(
      padding: const .all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        children: [
          _FileBadge(material: material, size: 46),
          const SizedBox(width: AppSpacing.sectionGap),
          Expanded(child: _MaterialText(material: material)),
          const SizedBox(width: AppSpacing.gap),
          _RoundIconButton(icon: .download, size: 34, onTap: onDownload),
        ],
      ),
    ),
  );
}
