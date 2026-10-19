import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAppRadioParser extends StacParser<KitModel> {
  const StacAppRadioParser();

  @override
  String get type => 'appRadio';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final value = stringOf(model, 'value');
    final registry = RadioGroup.maybeOf<Object?>(context);
    final groupValue =
        registry?.groupValue?.toString() ??
        stringStateOf(context, model, 'groupValue');
    final enabled = boolOf(model, 'enabled', fallback: true);
    return AppRadio<String>(
      value: value,
      groupValue: groupValue.isEmpty ? null : groupValue,
      label: stringOrNullOf(model, 'label'),
      semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
      onChanged: !enabled
          ? null
          : (selected) {
              registry?.onChanged(selected);
              writeStateValue(context, model, selected);
              actionOf(context, model, const ['onChanged', 'onChange'])?.call();
            },
    );
  }
}
