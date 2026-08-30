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
    final colors = context.ninja;
    return NinjaScheduleSurface(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          _FileBadge(material: material, size: 40),
          const SizedBox(width: 12),
          Expanded(child: _MaterialText(material: material, compact: true)),
          const SizedBox(width: 8),
          NinjaGlyphIcon(
            NinjaGlyph.chevronRight,
            size: 14,
            color: colors.chevron,
            strokeWidth: 2.5,
          ),
        ],
      ),
    );
  }
}
