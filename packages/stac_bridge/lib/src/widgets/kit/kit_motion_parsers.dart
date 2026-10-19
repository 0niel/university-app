import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

export 'stac_app_animated_container_parser.dart';
export 'stac_app_animated_opacity_parser.dart';
export 'stac_app_animated_switcher_parser.dart';

double boundedKitMotionValue(
  double? value,
  double fallback,
  double min,
  double max,
) => value == null || !value.isFinite ? fallback : value.clamp(min, max);

Duration kitMotionDuration(BuildContext context, KitModel model) {
  if (boolOf(model, 'reduceMotion')) return .zero;
  return NinjaMotion.of(
    context,
    Duration(
      milliseconds: boundedKitMotionValue(
        doubleOf(model, 'duration') ?? doubleOf(model, 'durationMs'),
        220,
        0,
        2000,
      ).round(),
    ),
  );
}

Curve kitMotionCurve(KitModel model) => switch (stringOf(model, 'curve')) {
  'linear' => Curves.linear,
  'easeIn' => Curves.easeIn,
  'easeOut' => Curves.easeOut,
  'easeInOut' => Curves.easeInOut,
  'easeInCubic' => Curves.easeInCubic,
  'easeInOutCubic' => Curves.easeInOutCubic,
  'fastOutSlowIn' => Curves.fastOutSlowIn,
  _ => Curves.easeOutCubic,
};
