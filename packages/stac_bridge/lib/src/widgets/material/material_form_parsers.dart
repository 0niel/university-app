import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_choice_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_input_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

KitModel normalizeMaterialField(KitModel model) {
  final rawDecoration = model['decoration'];
  final decoration = rawDecoration is Map<Object?, Object?>
      ? KitModel.from(rawDecoration)
      : <String, dynamic>{};
  final maxLines = intOf(model, 'maxLines') ?? 1;
  return <String, dynamic>{
    'id': model['id'],
    'initialValue': model['initialValue'],
    'label': decoration['labelText'],
    'placeholder': decoration['hintText'],
    'helperText': decoration['helperText'],
    'errorText': decoration['errorText'],
    'obscureText': model['obscureText'],
    'maxLines': maxLines,
    'minLines': model['minLines'],
    'maxLength': model['maxLength'],
    'multiline': maxLines > 1,
    'enabled': model['enabled'],
    'readOnly': model['readOnly'],
    'autofocus': model['autofocus'],
    'keyboardType': model['keyboardType'],
    'rules': model['validatorRules'],
    'onChanged': model['onChanged'],
    'onSubmitted': model['onSubmitted'],
  };
}

class StacTextFieldKitParser extends StacParser<KitModel> {
  const StacTextFieldKitParser();

  @override
  String get type => 'textField';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      KitInputField(model: normalizeMaterialField(model));
}

class StacTextFormFieldKitParser extends StacTextFieldKitParser {
  const StacTextFormFieldKitParser();

  @override
  String get type => 'textFormField';
}

class StacCheckBoxKitParser extends StacParser<KitModel> {
  const StacCheckBoxKitParser();

  @override
  String get type => 'checkBox';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitBoolControlView(
    model: model,
    kind: KitBoolControl.checkbox,
    initial: boolOf(model, 'value'),
  );
}

class StacSwitchKitParser extends StacParser<KitModel> {
  const StacSwitchKitParser();

  @override
  String get type => 'switch';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitBoolControlView(
    model: model,
    kind: KitBoolControl.toggle,
    initial: boolOf(model, 'value'),
  );
}

class StacRadioKitParser extends StacParser<KitModel> {
  const StacRadioKitParser();

  @override
  String get type => 'radio';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final registry = RadioGroup.maybeOf<dynamic>(context);
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
