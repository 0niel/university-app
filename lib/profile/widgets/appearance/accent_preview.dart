part of '../settings_appearance.dart';

class _AccentPreview extends StatelessWidget {
  const _AccentPreview({required this.scheme});

  final AppColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final color = AppColorSchemes.getSchemePreviewColor(scheme);
    return SizedBox.square(
      dimension: NinjaMetrics.minTouchTarget,
      child: Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          alignment: .center,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: context.ninja.contrastForeground(color),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
