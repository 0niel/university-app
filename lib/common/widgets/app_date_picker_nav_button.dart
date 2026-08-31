part of 'app_date_picker.dart';

class AppDatePickerNavButton extends StatelessWidget {
  const AppDatePickerNavButton({
    required this.icon,
    required this.onTap,
    super.key,
  });

  final AppLineIcon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      button: true,
      child: AppPressable(
        onTap: onTap,
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: .circle,
              ),
              child: Center(
                child: AppLineIconWidget(icon, size: 18, color: colors.ink),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
