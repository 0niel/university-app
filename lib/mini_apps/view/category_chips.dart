part of 'mini_apps_catalog.dart';

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.category, required this.onChanged});

  final MiniAppCategory? category;
  final ValueChanged<MiniAppCategory?> onChanged;

  @override
  Widget build(BuildContext context) => AppChipRow<MiniAppCategory?>(
    key: const ValueKey('mini-apps-categories'),
    value: category,
    onChanged: onChanged,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    items: [
      for (final value in <MiniAppCategory?>[null, ...MiniAppCategory.values])
        AppChipRowItem(
          value: value,
          label: miniAppCategoryLabel(context, value),
        ),
    ],
  );
}
