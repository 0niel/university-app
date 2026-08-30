part of '../schedule_details_page.dart';

class _FileBadge extends StatelessWidget {
  const _FileBadge({required this.material, required this.size});

  final LessonMaterial material;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.brandTint,
        shape: .circle,
      ),
      alignment: Alignment.center,
      child: Text(
        fileTypeBadge(material.fileName, material.mimeType),
        style: NinjaText.badge.copyWith(color: colors.brandInk),
      ),
    );
  }
}
