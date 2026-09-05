import 'dart:ui' as ui;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppScale extends StatelessWidget {
  const AppScale({required this.child, super.key});

  factory AppScale.create({required Widget child}) {
    return AppScale(child: child);
  }

  final Widget child;

  static const designWidth = 390.0;
  static const mobileMaxWidth = 650.0;

  static AppUiScale of(BuildContext context) => Theme.of(context).scale;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final mobile = switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      _ => false,
    };
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
          return child;
        }
        final size = constraints.biggest;
        if (size.isEmpty) return child;
        final hasHinge = media.displayFeatures.any(
          (feature) =>
              feature.type == ui.DisplayFeatureType.hinge ||
              feature.type == ui.DisplayFeatureType.fold,
        );
        final scale = mobile && size.shortestSide < mobileMaxWidth && !hasHinge
            ? size.shortestSide / designWidth
            : 1.0;
        final layoutSize = size / scale;
        return FittedBox(
          alignment: Alignment.topLeft,
          child: SizedBox.fromSize(
            size: layoutSize,
            child: MediaQuery(
              data: media.copyWith(
                size: layoutSize,
                devicePixelRatio: media.devicePixelRatio * scale,
                padding: media.padding / scale,
                viewPadding: media.viewPadding / scale,
                viewInsets: media.viewInsets / scale,
                systemGestureInsets: media.systemGestureInsets / scale,
                displayFeatures: [
                  for (final feature in media.displayFeatures)
                    ui.DisplayFeature(
                      bounds: Rect.fromLTRB(
                        feature.bounds.left / scale,
                        feature.bounds.top / scale,
                        feature.bounds.right / scale,
                        feature.bounds.bottom / scale,
                      ),
                      type: feature.type,
                      state: feature.state,
                    ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
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
    return const AppUiScale(
      spacingScale: 1,
      typographyScale: 1,
      iconScale: 1,
      radiusScale: 1,
      dimensionScale: 1,
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
