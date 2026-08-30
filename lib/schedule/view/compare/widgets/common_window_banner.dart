part of '../compare_page.dart';

class _CommonWindowBanner extends StatelessWidget {
  const _CommonWindowBanner({required this.window});

  final ComparisonSlot window;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.brandTint,
              shape: .circle,
            ),
            child: AppLineIconWidget(
              AppLineIcon.clock,
              size: 19,
              color: colors.brandInk,
            ),
          ),
          Expanded(
            child: Text(
              context.l10n.compareCommonWindow(window.time, window.untilTime),
              style: NinjaText.subtext.copyWith(
                color: colors.ink,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
