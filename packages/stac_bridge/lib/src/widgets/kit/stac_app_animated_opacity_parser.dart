import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_motion_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppAnimatedOpacityParser extends StacParser<KitModel> {
  const StacAppAnimatedOpacityParser();

  @override
  String get type => 'appAnimatedOpacity';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final opacity = boundedKitMotionValue(doubleOf(model, 'opacity'), 1, 0, 1);
    return IgnorePointer(
      ignoring: opacity == 0 || !boolOf(model, 'enabled', fallback: true),
      child: ExcludeSemantics(
        excluding: opacity == 0,
        child: AnimatedOpacity(
          duration: kitMotionDuration(context, model),
          curve: kitMotionCurve(model),
          opacity: opacity,
          onEnd: actionOf(context, model, const ['onEnd']),
          child: childWidget(context, model['child']),
        ),
      ),
    );
  }
}
