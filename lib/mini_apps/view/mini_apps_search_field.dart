part of 'mini_apps_page.dart';

class _MiniAppsSearchField extends StatelessWidget {
  const _MiniAppsSearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        4,
        AppSpacing.screen,
        0,
      ),
      child: NinjaInput(
        controller: controller,
        autofocus: true,
        placeholder: l10n.miniAppsSearchHint,
        leadingIcon: AppLineIconWidget(
          .search,
          size: 17,
          color: colors.muted,
        ),
        onChanged: (query) =>
            context.read<MiniAppsCatalogCubit>().queryChanged(query),
      ),
    );
  }
}
