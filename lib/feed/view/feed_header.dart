part of 'news_feed_page.dart';

class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        AppSpacing.md,
        NinjaMetrics.screenPadding,
        6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.feedTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  (MediaQuery.textScalerOf(context).scale(1) >= 1.6
                          ? NinjaText.title
                          : NinjaText.display)
                      .copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(width: 12),
          NinjaIconButton(
            icon: const AppLineIconWidget(AppLineIcon.search, size: 20),
            tooltip: context.l10n.search,
            onPressed: () => openGlobalSearch(context),
          ),
        ],
      ),
    );
  }
}
