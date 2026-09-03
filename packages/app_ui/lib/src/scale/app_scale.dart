import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScale extends StatelessWidget {
  const AppScale({required this.child, super.key});

  factory AppScale.create({required Widget child}) {
    return AppScale(child: child);
  }

  final Widget child;

  static AppUiScale of(BuildContext context) => Theme.of(context).scale;

  @override
  Widget build(BuildContext context) => child;
}

class AppUiScale {
  const AppUiScale({
    required this.spacingScale,
    required this.typographyScale,
    required this.iconScale,
    required this.radiusScale,
    required this.dimensionScale,
  });

  factory AppUiScale.screen() {
    double width = 1;
    double font = 1;
    try {
      final screen = ScreenUtil();
      width = screen.scaleWidth.clamp(.9, 1.08);
      font = screen.scaleText.clamp(.92, 1.05);
      // flutter_screenutil exposes no public initialization state. Widgets can
      // be rendered outside ScreenUtilInit in tests and embedded previews.
      // ignore: avoid_catching_errors
    } on Error catch (_) {}

    return AppUiScale(
      spacingScale: width,
      typographyScale: font,
      iconScale: width,
      radiusScale: width,
      dimensionScale: width,
    );
  }

  final double spacingScale;
  final double typographyScale;
  final double iconScale;
  final double radiusScale;
  final double dimensionScale;

  double size(num value) => value.toDouble() * dimensionScale;
  double space(num value) => value.toDouble() * spacingScale;
  double radius(num value) => value.toDouble() * radiusScale;
  double icon(num value) => value.toDouble() * iconScale;
  double font(num value) => value.toDouble() * typographyScale;

  TextStyle textStyle(TextStyle style) {
    final fontSize = style.fontSize;
    if (fontSize == null) return style;
    return style.copyWith(fontSize: font(fontSize));
  }

  SizedBox h(num value) => SizedBox(height: space(value));
  SizedBox w(num value) => SizedBox(width: size(value));
  SizedBox square(num value) => SizedBox.square(dimension: size(value));

  EdgeInsets insetsAll(num value) => EdgeInsets.all(space(value));

  EdgeInsets insetsSymmetric({num horizontal = 0, num vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: space(horizontal),
      vertical: space(vertical),
    );
  }

  EdgeInsets insetsOnly({
    num left = 0,
    num top = 0,
    num right = 0,
    num bottom = 0,
  }) {
    return EdgeInsets.only(
      left: space(left),
      top: space(top),
      right: space(right),
      bottom: space(bottom),
    );
  }
}

class AppScaledText {
  const AppScaledText(this._scale, this._colors);

  final AppUiScale _scale;
  final AppColors _colors;

  TextStyle get display => _style(AppText.display);
  TextStyle get displayHero => _style(AppText.displayHero);
  TextStyle get displayLarge => _style(AppText.displayLarge);
  TextStyle get displaySmall => _style(AppText.displaySmall);
  TextStyle get title => _style(AppText.title);
  TextStyle get heading => _style(AppText.heading);
  TextStyle get bodyLarge => _style(AppText.bodyLarge);
  TextStyle get body => _style(AppText.body);
  TextStyle get bodyStrong => _style(AppText.bodyStrong);
  TextStyle get bodyRegular => _style(AppText.bodyRegular);
  TextStyle get caption => _style(AppText.caption, color: _colors.muted);
  TextStyle get captionSmall =>
      _style(AppText.captionSmall, color: _colors.muted);
  TextStyle get button => _style(AppText.button);
  TextStyle get buttonLarge => _style(AppText.buttonLarge);
  TextStyle get tab => _style(AppText.tab);
  TextStyle get overline => _style(
        AppText.overline,
        color: _colors.deactiveDarker,
      );
  TextStyle get chip => _style(AppText.chip);
  TextStyle get tabular => AppText.tabular(bodyStrong);

  TextStyle muted(TextStyle style) => style.copyWith(color: _colors.muted);
  TextStyle subtle(TextStyle style) =>
      style.copyWith(color: _colors.deactiveDarker);
  TextStyle accent(TextStyle style) => style.copyWith(color: _colors.accent);
  TextStyle danger(TextStyle style) => style.copyWith(color: _colors.error);
  TextStyle success(TextStyle style) => style.copyWith(color: _colors.success);

  TextStyle _style(TextStyle style, {Color? color}) {
    return _scale.textStyle(style).copyWith(color: color ?? _colors.ink);
  }
}

extension ThemeDataScaleX on ThemeData {
  AppUiScale get scale => AppUiScale.screen();
}

extension AppUiContextX on BuildContext {
  AppUiScale get ui => Theme.of(this).scale;
  AppScaledText get text => AppScaledText(ui, colors);

  double space(num value) => ui.space(value);
  double radius(num value) => ui.radius(value);
  double iconSize(num value) => ui.icon(value);

  EdgeInsets insetsAll(num value) => ui.insetsAll(value);
  EdgeInsets insetsSymmetric({num horizontal = 0, num vertical = 0}) {
    return ui.insetsSymmetric(horizontal: horizontal, vertical: vertical);
  }

  BorderRadius borderRadius(num value) {
    return BorderRadius.circular(radius(value));
  }

  BorderRadius get radiusSm => borderRadius(AppRadius.sm);
  BorderRadius get radiusMd => borderRadius(AppRadius.md);
  BorderRadius get radiusLg => borderRadius(AppRadius.lg);
  BorderRadius get radiusXl => borderRadius(AppRadius.xl);
}
