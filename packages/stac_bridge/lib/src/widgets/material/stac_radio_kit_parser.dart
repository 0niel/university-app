import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacRadioKitParser extends StacParser<KitModel> {
  const StacRadioKitParser();

  @override
  String get type => 'radio';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final registry = RadioGroup.maybeOf<Object?>(context);
    final enabled = boolOf(model, 'enabled', fallback: true);
    final action = actionCallback(context, model['onChanged']);
    return AppRadio<Object?>(
      value: model['value'],
      groupValue: registry?.groupValue ?? model['groupValue'],
      label: stringOrNullOf(model, 'label'),
      onChanged: !enabled
          ? null
          : (selected) {
              registry?.onChanged(selected);
              action?.call();
            },
    );
  }
}
