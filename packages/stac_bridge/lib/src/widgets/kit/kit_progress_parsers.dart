import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppProgressRingParser extends StacParser<KitModel> {
  const StacAppProgressRingParser();

  @override
  String get type => 'appProgressRing';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppProgressRing(
    value: doubleOr(model, 'value', doubleOr(model, 'progress', 0)),
    size: doubleOr(model, 'size', 56),
    strokeWidth: doubleOr(model, 'strokeWidth', 5),
    color: colorOf(context, model, 'color'),
    trackColor: colorOf(context, model, 'trackColor'),
    label: stringOrNullOf(model, 'label'),
    sublabel: stringOrNullOf(model, 'sublabel'),
  );
}

class StacAppProgressBarParser extends StacParser<KitModel> {
  const StacAppProgressBarParser();

  @override
  String get type => 'appProgressBar';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => NinjaProgressBar(
    value: doubleOr(model, 'value', 0).clamp(0, 1),
    height: doubleOr(model, 'height', 6),
    color: colorOf(context, model, 'color'),
    trackColor: colorOf(context, model, 'trackColor'),
    indeterminate: boolOf(model, 'indeterminate'),
  );
}

class StacAppSpinnerParser extends StacParser<KitModel> {
  const StacAppSpinnerParser();

  @override
  String get type => 'appSpinner';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => NinjaSpinner(
    size: doubleOr(model, 'size', 28),
    strokeWidth: doubleOr(model, 'strokeWidth', 3),
    color: colorOf(context, model, 'color'),
    trackColor: colorOf(context, model, 'trackColor'),
  );
}

class StacAppSkeletonParser extends StacParser<KitModel> {
  const StacAppSkeletonParser();

  @override
  String get type => 'appSkeleton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final width = doubleOf(model, 'width');
    final widthFactor = doubleOf(model, 'widthFactor');
    return switch (stringOf(model, 'variant')) {
      'avatar' => NinjaSkeleton.avatar(size: doubleOr(model, 'size', 44)),
      'bar' => NinjaSkeleton.bar(
        height: doubleOr(model, 'height', 12),
        widthFactor: widthFactor,
      ),
      'tile' => NinjaSkeleton.tile(
        height: doubleOr(model, 'height', 64),
        width: width,
      ),
      'row' => AppSkeletonRow(
        showTrailing: boolOf(model, 'showTrailing', fallback: true),
      ),
      'media' => NinjaSkeletonMedia(
        height: doubleOr(model, 'height', 160),
        width: width,
        radius: doubleOr(model, 'radius', AppRadius.field),
      ),
      _ => NinjaSkeleton(
        height: doubleOr(model, 'height', 16),
        width: width,
        widthFactor: widthFactor,
        radius: doubleOr(model, 'radius', AppRadius.sm),
      ),
    };
  }
}
