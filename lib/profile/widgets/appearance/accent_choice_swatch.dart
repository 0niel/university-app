part of '../settings_appearance.dart';

class _AccentChoiceSwatch extends StatelessWidget {
  const _AccentChoiceSwatch({required this.scheme});

  final AppColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final accent = AppColorSchemes.getSchemePreviewColor(scheme);
    return SizedBox.square(
      dimension: 38,
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
