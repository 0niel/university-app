part of 'tools_view.dart';

class _ToolsHeader extends StatelessWidget {
  const _ToolsHeader({required this.busy, required this.onRefresh});

  final bool busy;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        18,
        NinjaMetrics.screenPadding,
        18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.toolsTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.display.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(width: 12),
          NinjaIconButton(
            key: const ValueKey('tools-refresh-button'),
            icon: const AppLineIconWidget(AppLineIcon.refresh, size: 20),
            tooltip: l10n.refreshData,
            onPressed: busy ? null : onRefresh,
          ),
        ],
      ),
    );
  }
}
