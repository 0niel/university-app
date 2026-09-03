part of 'mini_app_submit_page.dart';

class _SubmitSectionLabel extends StatelessWidget {
  const _SubmitSectionLabel({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    return Padding(
      padding: const .only(bottom: 10),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: AppText.title.copyWith(color: colors.ink),
          ),
          if (subtitleText != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitleText,
              style: AppText.subtext.copyWith(color: colors.muted),
            ),
          ],
        ],
      ),
    );
  }
}
