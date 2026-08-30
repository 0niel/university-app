part of '../schedule_details_page.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.subtitle,
    this.action,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final subtitle = this.subtitle;
    final action = this.action;

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        28,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: Row(
        crossAxisAlignment: .end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: NinjaText.subtext.copyWith(color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 10),
            NinjaButton.text(
              label: action,
              size: NinjaButtonSize.small,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
