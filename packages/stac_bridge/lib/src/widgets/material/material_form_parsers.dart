import 'package:stac_bridge/src/widgets/parse_utils.dart';

export 'stac_check_box_kit_parser.dart';
export 'stac_radio_kit_parser.dart';
export 'stac_switch_kit_parser.dart';
export 'stac_text_field_kit_parser.dart';
export 'stac_text_form_field_kit_parser.dart';

KitModel normalizeMaterialField(KitModel model) {
  final rawDecoration = model['decoration'];
  final decoration = rawDecoration is Map<Object?, Object?>
      ? KitModel.from(rawDecoration)
      : <String, dynamic>{};
  final maxLines = intOf(model, 'maxLines') ?? 1;
  return {
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
