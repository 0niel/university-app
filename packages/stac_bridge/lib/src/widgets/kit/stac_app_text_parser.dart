import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_text_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppTextParser extends StacParser<KitModel> {
  const StacAppTextParser();

  @override
  String get type => 'appText';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final variant = stringOrNullOf(model, 'variant');
    final data = stringOf(model, 'data', stringOf(model, 'text'));
    final maxLines = intOf(model, 'maxLines');
    return Text(
      variant == 'overline' || boolOf(model, 'uppercase')
          ? data.toUpperCase()
          : data,
      style: appTextStyleOf(variant).copyWith(
        color:
            colorOf(context, model, 'color') ??
            (variant == 'overline' || variant == 'caption'
                ? context.colors.muted
                : context.colors.ink),
      ),
      textAlign: textAlignOf(stringOrNullOf(model, 'align')),
      maxLines: maxLines,
      overflow: maxLines == null ? null : .ellipsis,
    );
  }
}
