import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_image_parser.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacImageKitParser extends StacParser<KitModel> {
  const StacImageKitParser();

  @override
  String get type => 'image';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final imageType = stringOf(model, 'imageType', 'network');
    if (imageType != 'network') {
      return const StacImageParser().parse(
        context,
        StacImage.fromJson(model),
      );
    }
    return KitNetworkImage(
      src: stringOf(model, 'src'),
      width: doubleOf(model, 'width'),
      height: doubleOf(model, 'height'),
      fit: boxFitOf(stringOrNullOf(model, 'fit')),
      radius: 0,
      semanticLabel: stringOrNullOf(model, 'semanticLabel'),
      enablePreview:
          boolOf(model, 'enablePreview', fallback: true) &&
          actionOf(context, model, const ['onTap', 'onPressed']) == null,
      onTap: actionOf(context, model, const ['onTap', 'onPressed']),
    );
  }
}
