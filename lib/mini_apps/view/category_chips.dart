part of 'mini_apps_page.dart';

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.category});

  final MiniAppCategory? category;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MiniAppsCatalogCubit>();
    return ClipRect(
      child: NinjaChipRow(
        key: const ValueKey('mini-apps-categories'),
        children: [
          for (final value in <MiniAppCategory?>[
            null,
            ...MiniAppCategory.values,
          ])
            NinjaChip(
              label: miniAppCategoryLabel(context, value),
              selected: category == value,
              onTap: () => cubit.categoryChanged(value),
            ),
        ],
      ),
    );
  }
}
