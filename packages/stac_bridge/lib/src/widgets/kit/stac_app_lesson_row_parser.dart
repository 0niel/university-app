import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_calendar_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppLessonRowParser extends StacParser<KitModel> {
  const StacAppLessonRowParser();

  @override
  String get type => 'appLessonRow';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => NinjaLessonRow(
    title: stringOf(model, 'title'),
    time: stringOf(model, 'time'),
    endTime: stringOrNullOf(model, 'endTime'),
    meta: stringOrNullOf(model, 'meta'),
    color: colorOf(context, model, 'color'),
    typeLabel: stringOrNullOf(model, 'typeLabel'),
    chipLabel: stringOrNullOf(model, 'chipLabel'),
    chipColor: colorOf(context, model, 'chipColor'),
    state: lessonRowStateOf(stringOrNullOf(model, 'state')),
    progress: doubleOf(model, 'progress'),
    stateLabel: stringOrNullOf(model, 'stateLabel'),
    inset: doubleOr(model, 'inset', 0),
    onTap: actionOf(context, model, const ['onTap']),
    onMore: actionOf(context, model, const ['onMore']),
    actions: [
      for (final action in mapListOf(model, 'actions'))
        NinjaLessonAction(
          label: stringOf(action, 'label'),
          primary: boolOf(action, 'primary', fallback: true),
          onPressed: actionOf(context, action, const ['onPressed', 'onTap']),
        ),
    ],
  );
}
