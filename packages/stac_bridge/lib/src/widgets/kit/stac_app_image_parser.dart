import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac_bridge/src/widgets/kit/kit_image_parser.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppImageParser extends StacParser<KitModel> {
  const StacAppImageParser();

  @override
  String get type => 'appImage';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitNetworkImage(
    src: stringOf(model, 'src', stringOf(model, 'url')),
    width: doubleOf(model, 'width'),
    height: doubleOf(model, 'height'),
    fit: boxFitOf(stringOrNullOf(model, 'fit')),
    radius: doubleOr(model, 'radius', AppRadius.field),
    aspectRatio: doubleOf(model, 'aspectRatio'),
    semanticLabel: stringOrNullOf(model, 'semanticLabel'),
    enablePreview:
        boolOf(model, 'enablePreview', fallback: true) &&
        actionOf(context, model, const ['onTap', 'onPressed']) == null,
    onTap: actionOf(context, model, const ['onTap', 'onPressed']),
  );
}
