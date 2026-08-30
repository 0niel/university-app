part of 'marketplace_body.dart';

class _MarketplaceHeader extends StatelessWidget {
  const _MarketplaceHeader({required this.busy});

  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.marketTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.display.copyWith(color: colors.ink),
          ),
        ),
        const SizedBox(width: 12),
        NinjaIconButton(
          key: const ValueKey('marketplace-refresh-button'),
          icon: const AppLineIconWidget(AppLineIcon.refresh, size: 20),
          tooltip: l10n.refreshData,
          onPressed: busy
              ? null
              : () => unawaited(context.read<MarketplaceCubit>().load()),
        ),
      ],
    );
  }
}
