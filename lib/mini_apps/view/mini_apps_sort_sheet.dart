part of 'mini_apps_page.dart';

String _miniAppSortLabel(AppLocalizations l10n, MiniAppSort sort) =>
    switch (sort) {
      MiniAppSort.popular => l10n.miniAppsSortPopular,
      MiniAppSort.newest => l10n.miniAppsSortNew,
      MiniAppSort.top => l10n.miniAppsSortTop,
    };

class _MiniAppsSortSheet extends StatelessWidget {
  const _MiniAppsSortSheet({required this.selected});

  final MiniAppSort selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final sort in MiniAppSort.values)
          AppRadioRow(
            title: _miniAppSortLabel(l10n, sort),
            selected: sort == selected,
            leading: _SortIcon(sort: sort),
            onTap: sort == selected
                ? null
                : () => Navigator.of(context, rootNavigator: true).pop(sort),
          ),
      ],
    );
  }
}
