part of 'article_view.dart';

class _ArticleBar extends StatelessWidget implements PreferredSizeWidget {
  const _ArticleBar({
    required this.title,
    required this.backLabel,
    required this.shareLabel,
    required this.canShare,
    required this.onBack,
    this.onShare,
  });

  final String title;
  final String backLabel;
  final String shareLabel;
  final bool canShare;
  final VoidCallback onBack;
  final VoidCallback? onShare;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              NinjaIconButton(
                icon: const AppLineIconWidget(AppLineIcon.chevronL, size: 20),
                tooltip: backLabel,
                onPressed: onBack,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
              ),
              if (canShare) ...[
                const SizedBox(width: 8),
                NinjaIconButton(
                  key: const Key('articlePage_shareButton'),
                  icon: const AppLineIconWidget(AppLineIcon.share, size: 19),
                  tooltip: shareLabel,
                  onPressed: onShare,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
