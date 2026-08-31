part of '../view/onboarding_page.dart';

class _GroupResultRow extends StatelessWidget {
  const _GroupResultRow({
    required this.group,
    required this.selected,
    required this.onTap,
  });

  final Group group;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: group.name,
      semanticsButton: true,
      semanticsSelected: selected,
      child: AnimatedContainer(
        duration: NinjaMotion.of(context, NinjaMotion.fast),
        curve: NinjaMotion.enter,
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        padding: const .fromLTRB(18, 14, 18, 14),
        decoration: BoxDecoration(
          color: selected ? colors.brandTint : colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                group.name,
                style: NinjaText.headline.copyWith(
                  color: selected ? colors.brandInk : colors.ink,
                ),
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 12),
              NinjaCheckMark(size: 16, color: colors.brand),
            ],
          ],
        ),
      ),
    );
  }
}
