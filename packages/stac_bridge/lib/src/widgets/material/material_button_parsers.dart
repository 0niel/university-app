import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/async_action_builder.dart';
import 'package:stac_bridge/src/widgets/material/material_icon_names.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

export 'stac_elevated_button_kit_parser.dart';
export 'stac_filled_button_kit_parser.dart';
export 'stac_floating_action_button_kit_parser.dart';
export 'stac_icon_button_kit_parser.dart';
export 'stac_outlined_button_kit_parser.dart';
export 'stac_text_button_kit_parser.dart';

Widget kitButtonFromMaterial(
  BuildContext _,
  KitModel model,
  AppButtonVariant variant,
) {
  final child = model['child'];
  final icon = lineIconOfNode(child);
  return AsyncActionBuilder(
    action: model['onPressed'],
    enabled: boolOf(model, 'enabled', fallback: true),
    loading: boolOf(model, 'loading'),
    builder: (context, onPressed, {required loading}) => AppButton(
      label: labelOf(child),
      variant: variant,
      icon: icon == null ? null : AppLineIconWidget(icon),
      loading: loading,
      onPressed: onPressed,
    ),
  );
}
