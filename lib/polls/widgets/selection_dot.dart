part of 'poll_card.dart';

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected, required this.multi});

  final bool selected;
  final bool multi;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? colors.brand : colors.surface,
        shape: multi ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: multi ? BorderRadius.circular(6) : null,
      ),
      child: selected
          ? AppLineIconWidget(
              AppLineIcon.check,
              size: 14,
              color: colors.onBrand,
            )
          : null,
    );
  }
}
