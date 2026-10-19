import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/async_action_builder.dart';
import 'package:stac_bridge/src/widgets/kit/kit_button_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppButtonParser extends StacParser<KitModel> {
  const StacAppButtonParser();

  @override
  String get type => 'appButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final enabled = boolOf(model, 'enabled', fallback: true);
    final icon = iconOf(model, 'icon');
    final trailingIcon = iconOf(model, 'trailingIcon');
    return AsyncActionBuilder(
      key: model['id'] is String ? ValueKey(model['id']) : null,
      action: model['onPressed'] ?? model['onTap'],
      enabled: enabled,
      loading: boolOf(model, 'loading'),
      builder: (context, onPressed, {required loading}) => AppButton(
        label: loading
            ? stringOf(model, 'loadingLabel', stringOf(model, 'label'))
            : stringOf(model, 'label'),
        variant: appButtonVariantOf(stringOrNullOf(model, 'variant')),
        size: appButtonSizeOf(stringOrNullOf(model, 'size')),
        expanded: boolOf(model, 'expanded'),
        loading: loading,
        tooltip: stringOrNullOf(model, 'tooltip'),
        icon: icon == null ? null : AppLineIconWidget(icon),
        trailingIcon: trailingIcon == null
            ? null
            : AppLineIconWidget(trailingIcon),
        onPressed: onPressed,
      ),
    );
  }
}
