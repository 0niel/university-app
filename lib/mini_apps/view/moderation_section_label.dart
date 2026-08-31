part of 'mini_apps_moderation_page.dart';

class _ModerationSectionLabel extends StatelessWidget {
  const _ModerationSectionLabel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        28,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: NinjaText.title.copyWith(color: colors.ink),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: NinjaText.subtext.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}
