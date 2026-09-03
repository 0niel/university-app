part of '../schedule_details_page.dart';

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });
  final LessonMaterialType type;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppChip(
    label: _materialTypeLabel(context.l10n, type),
    selected: selected,
    onTap: onTap,
  );
}
