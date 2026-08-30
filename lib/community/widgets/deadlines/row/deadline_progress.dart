part of '../deadline_row.dart';

class _DeadlineProgress extends StatelessWidget {
  const _DeadlineProgress({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
            child: SizedBox(
              height: 5,
              child: Stack(
                children: [
                  Positioned.fill(child: ColoredBox(color: colors.surfaceAlt)),
                  FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: (value / 100).clamp(0, 1),
                    child: ColoredBox(color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$value%',
          style: NinjaText.tabular(
            NinjaText.helper.copyWith(
              color: colors.mutedDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
