part of 'poll_creator_sheet.dart';

class _AddOptionButton extends StatelessWidget {
  const _AddOptionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(NinjaRadius.control),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLineIconWidget(
                AppLineIcon.plus,
                size: 19,
                color: colors.brand,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: NinjaText.button.copyWith(color: colors.brand),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
