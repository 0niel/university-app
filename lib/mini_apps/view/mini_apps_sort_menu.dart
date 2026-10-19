part of 'mini_apps_catalog.dart';

String _miniAppSortLabel(AppLocalizations l10n, MiniAppSort sort) =>
    switch (sort) {
      MiniAppSort.popular => l10n.miniAppsSortPopular,
      MiniAppSort.newest => l10n.miniAppsSortNew,
      MiniAppSort.top => l10n.miniAppsSortTop,
    };

class _MiniAppsSortMenu extends StatelessWidget {
  const _MiniAppsSortMenu({required this.selected});

  final MiniAppSort selected;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final sort in MiniAppSort.values)
        AppRadioRow(
          title: _miniAppSortLabel(context.l10n, sort),
          selected: sort == selected,
          leading: _SortIcon(sort: sort),
          onTap: () => Navigator.of(context).pop(sort),
        ),
    ],
  );
}
