part of '../compare_page.dart';

class _SlotRow extends StatelessWidget {
  const _SlotRow({required this.slot});

  final ComparisonSlot slot;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;

    if (slot.bothFree) {
      final l10n = context.l10n;
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: .stretch,
          children: [
            SizedBox(
              width: 44,
              child: Padding(
                padding: const .only(top: 14),
                child: Text(
                  slot.time,
                  style: NinjaText.tabular(
                    NinjaText.subtext.copyWith(color: colors.muted),
                  ),
                ),
              ),
            ),
            Expanded(
              child: NinjaScheduleSurface(
                child: Center(
                  child: Text(
                    l10n.compareBothFree,
                    style: NinjaText.body.copyWith(
                      color: colors.brandInk,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final same = slot.isTogether;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            constraints.maxWidth < 340 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.4;
        final time = Text(
          slot.time,
          style: NinjaText.tabular(
            NinjaText.subtext.copyWith(color: colors.muted),
          ),
        );
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              time,
              const SizedBox(height: 8),
              _SlotCell(lesson: slot.mine, same: same),
              const SizedBox(height: 10),
              _SlotCell(lesson: slot.friend, same: same),
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 44,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: time,
                ),
              ),
              Expanded(
                child: _SlotCell(lesson: slot.mine, same: same),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SlotCell(lesson: slot.friend, same: same),
              ),
            ],
          ),
        );
      },
    );
  }
}
