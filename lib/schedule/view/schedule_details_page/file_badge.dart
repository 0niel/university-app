part of '../schedule_details_page.dart';

class _FileBadge extends StatelessWidget {
  const _FileBadge({required this.material, required this.size});

  final LessonMaterial material;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = fileTypeBadge(material.fileName, material.mimeType);
    final color = label == 'PDF' ? colors.exam : colors.lecture;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.tintOf(color),
        borderRadius: BorderRadius.circular(AppRadius.iconTile),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppText.sans(10, FontWeight.w800).copyWith(color: color),
      ),
    );
  }
}
