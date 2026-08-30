part of '../session_page.dart';

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 92, minHeight: 64),
      child: Container(
        padding: const .symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: .circular(NinjaRadius.control),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              value,
              style: NinjaText.tabular(
                NinjaText.headline.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: NinjaText.helper.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
