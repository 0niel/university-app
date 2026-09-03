part of 'debug_overlay.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(16, 14, 16, 8),
      child: Text(
        text.toUpperCase(),
        style: AppText.captionSmall.copyWith(color: context.colors.muted),
      ),
    );
  }
}
