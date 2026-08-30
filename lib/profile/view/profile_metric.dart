part of 'profile_page.dart';

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.metric, this.stacked = false});

  final _ProfileMetricData metric;

  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final (icon, value, label, onTap) = metric;

    final well = Container(
      width: 34,
      height: 34,
      alignment: .center,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: .circular(11),
      ),
      child: AppLineIconWidget(icon, size: 18, color: colors.mutedDark),
    );
    final valueText = Text(
      value,
      maxLines: 1,
      overflow: .ellipsis,
      style: NinjaText.tabular(
        NinjaText.body.copyWith(fontWeight: .w700, color: colors.ink),
      ),
    );
    final labelText = Text(
      label,
      maxLines: 2,
      overflow: .ellipsis,
      style: NinjaText.helper.copyWith(color: colors.muted),
    );

    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: stacked
          ? Row(
              children: [
                well,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .start,
                    children: [valueText, labelText],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    well,
                    const SizedBox(width: 8),
                    Expanded(child: valueText),
                  ],
                ),
                const SizedBox(height: 6),
                labelText,
              ],
            ),
    );
    if (onTap == null) return content;
    return Semantics(
      button: true,
      child: AppPressable(onTap: onTap, child: content),
    );
  }
}
