part of '../schedule_details_page.dart';

class _SubjectTopBar extends StatelessWidget {
  const _SubjectTopBar({
    required this.title,
    required this.onBack,
    required this.onShare,
    required this.onMore,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colors.canvas.withValues(alpha: 0.96),
      surfaceTintColor: Colors.transparent,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8),
        child: NinjaIconButton(
          icon: NinjaGlyphIcon(
            NinjaGlyph.arrowLeft,
            size: 20,
            color: colors.ink,
          ),
          tooltip: context.l10n.back,
          onPressed: onBack,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: NinjaText.headline.copyWith(color: colors.ink),
      ),
      actions: [
        NinjaIconButton(
          icon: AppLineIconWidget(.share, size: 20, color: colors.ink),
          tooltip: context.l10n.share,
          onPressed: onShare,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: NinjaIconButton(
            icon: AppLineIconWidget(.more, size: 20, color: colors.ink),
            tooltip: context.l10n.more,
            onPressed: onMore,
          ),
        ),
      ],
    );
  }
}
