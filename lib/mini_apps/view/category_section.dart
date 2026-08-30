part of 'mini_app_submit_page.dart';

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.onChanged});

  final MiniAppCategory category;
  final ValueChanged<MiniAppCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        _SubmitSectionLabel(title: context.l10n.miniAppsSubmitCategory),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in MiniAppCategory.values)
              NinjaChip(
                label: miniAppCategoryLabel(context, value),
                selected: category == value,
                onTap: () => onChanged(value),
              ),
          ],
        ),
      ],
    );
  }
}
