part of '../schedule_page.dart';

class _GapRow extends StatelessWidget {
  const _GapRow({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final gap = l10n.windowMinutes(minutes);
    final hint = minutes >= 45 ? ' · ${l10n.gapCoffeeHint}' : '';

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        6,
      ),
      child: AppPressable(
        onTap: () => context.go('/services/free-rooms'),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const .symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: .circular(NinjaRadius.pill),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$gap$hint',
                  style: NinjaText.subtext.copyWith(color: colors.mutedDark),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  l10n.freeClassrooms,
                  maxLines: 2,
                  overflow: .ellipsis,
                  textAlign: .right,
                  style: NinjaText.buttonSmall.copyWith(color: colors.ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
