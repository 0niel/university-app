part of 'settings_theme_row.dart';

class _ThemeModeIcon extends StatelessWidget {
  const _ThemeModeIcon({required this.mode});

  final AdaptiveThemeMode mode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: 38,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.compact),
        ),
        child: Center(
          child: AppLineIconWidget(
            _themeIcon(mode),
            size: 19,
            color: colors.muted,
          ),
        ),
      ),
    );
  }
}
