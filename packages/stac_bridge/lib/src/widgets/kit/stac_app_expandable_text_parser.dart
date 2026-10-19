import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_text_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppExpandableTextParser extends StacParser<KitModel> {
  const StacAppExpandableTextParser();

  @override
  String get type => 'appExpandableText';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppExpandableText(
    text: stringOf(model, 'text', stringOf(model, 'data')),
    expandLabel: stringOf(
      model,
      'expandLabel',
      kitText(context, ru: 'Показать ещё', en: 'Show more'),
    ),
    collapseLabel: stringOf(
      model,
      'collapseLabel',
      kitText(context, ru: 'Свернуть', en: 'Show less'),
    ),
    collapsedMaxLines: intOf(model, 'maxLines') ?? 4,
    style: appTextStyleOf(stringOrNullOf(model, 'variant')).copyWith(
      color: colorOf(context, model, 'color') ?? context.colors.ink,
    ),
  );
}
