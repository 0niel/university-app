part of '../schedule_details_page.dart';

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({required this.material, required this.onDownload});
  final LessonMaterial material;
  final VoidCallback onDownload;
  @override
  Widget build(BuildContext context) => Container(
    padding: const .all(16),
    decoration: BoxDecoration(
      color: context.ninja.surface,
      borderRadius: .circular(NinjaRadius.card),
    ),
    child: Row(
      children: [
        _FileBadge(material: material, size: 46),
        const SizedBox(width: 14),
        Expanded(child: _MaterialText(material: material)),
        const SizedBox(width: 10),
        _RoundIconButton(icon: .download, size: 34, onTap: onDownload),
      ],
    ),
  );
}
