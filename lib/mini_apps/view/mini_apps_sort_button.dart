part of 'mini_apps_catalog.dart';

class _MiniAppsSortButton extends StatefulWidget {
  const _MiniAppsSortButton({required this.selected, required this.onChanged});

  final MiniAppSort selected;
  final ValueChanged<MiniAppSort> onChanged;

  @override
  State<_MiniAppsSortButton> createState() => _MiniAppsSortButtonState();
}

class _MiniAppsSortButtonState extends State<_MiniAppsSortButton> {
  Future<MiniAppSort?>? _selection;

  Future<void> _open(BuildContext anchorContext) async {
    if (_selection != null) return;
    final selection = showAppPopover<MiniAppSort>(
      context,
      anchorContext: anchorContext,
      semanticLabel: context.l10n.miniAppsSortTitle,
      maxWidth: 280,
      maxHeight: 280,
      builder: (_) => _MiniAppsSortMenu(selected: widget.selected),
    );
    setState(() {
      _selection = selection;
    });
    final MiniAppSort? selected;
    try {
      selected = await selection;
    } finally {
      if (mounted) setState(() => _selection = null);
    }
    if (!mounted || selected == null || selected == widget.selected) return;
    widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) => Builder(
    builder: (anchorContext) {
      final label = _miniAppSortLabel(anchorContext.l10n, widget.selected);
      return Semantics(
        expanded: _selection != null,
        child: AppButton.glass(
          key: const ValueKey('mini-apps-sort-button'),
          label: label,
          size: AppButtonSize.small,
          icon: const AppLineIconWidget(AppLineIcon.filter),
          trailingIcon: AnimatedRotation(
            turns: _selection == null ? 0 : .5,
            duration: NinjaMotion.of(anchorContext, NinjaMotion.fast),
            curve: NinjaMotion.enter,
            child: const AppLineIconWidget(AppLineIcon.chevronD),
          ),
          tooltip: '${anchorContext.l10n.miniAppsSortTitle}: $label',
          onPressed: () => unawaited(_open(anchorContext)),
        ),
      );
    },
  );
}
