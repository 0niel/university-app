part of 'mini_apps_moderation_page.dart';

class _ModerationSectionLabel extends StatelessWidget {
  const _ModerationSectionLabel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        28,
        AppSpacing.screen,
        10,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: AppText.title.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}
