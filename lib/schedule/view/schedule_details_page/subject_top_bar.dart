part of '../schedule_details_page.dart';

class _SubjectTopBar extends StatelessWidget {
  const _SubjectTopBar({
    required this.title,
    required this.onBack,
    required this.onShare,
  });
  final String title;
  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        math.max(56, MediaQuery.paddingOf(context).top + 12),
        20,
        12,
      ),
      child: Row(
        children: [
          AppBackButton(onPressed: onBack),
          const Spacer(),
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.share),
            tone: AppIconButtonTone.surface,
            shape: AppIconButtonShape.circle,
            tooltip: context.l10n.share,
            onPressed: onShare,
          ),
        ],
      ),
    ),
  );
}
