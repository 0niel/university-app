import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_motion_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppAnimatedContainerParser extends StacParser<KitModel> {
  const StacAppAnimatedContainerParser();

  @override
  String get type => 'appAnimatedContainer';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    double? dimension(String key) {
      final value = doubleOf(model, key);
      return value == null || !value.isFinite ? null : value.clamp(0, 10000);
    }

    EdgeInsets? padding(String key) {
      if (!model.containsKey(key)) return null;
      final value = insetsOf(model, key, 0);
      return EdgeInsets.fromLTRB(
        boundedKitMotionValue(value.left, 0, 0, 1000),
        boundedKitMotionValue(value.top, 0, 0, 1000),
        boundedKitMotionValue(value.right, 0, 0, 1000),
        boundedKitMotionValue(value.bottom, 0, 0, 1000),
      );
    }

    return AnimatedContainer(
      duration: kitMotionDuration(context, model),
      curve: kitMotionCurve(model),
      width: dimension('width'),
      height: dimension('height'),
      padding: padding('padding'),
      margin: padding('margin'),
      alignment: switch (stringOf(model, 'alignment')) {
        'topLeft' => Alignment.topLeft,
        'topCenter' => Alignment.topCenter,
        'topRight' => Alignment.topRight,
        'centerLeft' => Alignment.centerLeft,
        'center' => Alignment.center,
        'centerRight' => Alignment.centerRight,
        'bottomLeft' => Alignment.bottomLeft,
        'bottomCenter' => Alignment.bottomCenter,
        'bottomRight' => Alignment.bottomRight,
        _ => null,
      },
      decoration: BoxDecoration(
        color: colorOf(context, model, 'color'),
        borderRadius: .circular(
          boundedKitMotionValue(doubleOf(model, 'radius'), 0, 0, 1000),
        ),
        border: model.containsKey('borderColor')
            ? .all(
                color:
                    colorOf(context, model, 'borderColor') ??
                    context.colors.line,
                width: boundedKitMotionValue(
                  doubleOf(model, 'borderWidth'),
                  1,
                  0,
                  20,
                ),
              )
            : null,
      ),
      onEnd: actionOf(context, model, const ['onEnd']),
      child: childWidget(context, model['child']),
    );
  }
}
