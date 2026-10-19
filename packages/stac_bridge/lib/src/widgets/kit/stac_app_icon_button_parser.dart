import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/async_action_builder.dart';
import 'package:stac_bridge/src/widgets/kit/kit_button_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppIconButtonParser extends StacParser<KitModel> {
  const StacAppIconButtonParser();

  @override
  String get type => 'appIconButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon = iconOf(model, 'icon');
    if (icon == null) return const SizedBox.shrink();
    final enabled = boolOf(model, 'enabled', fallback: true);
    return AsyncActionBuilder(
      action: model['onPressed'] ?? model['onTap'],
      enabled: enabled,
      loading: boolOf(model, 'loading'),
      builder: (context, onPressed, {required loading}) => AppIconButton(
        icon: loading
            ? const SizedBox.square(dimension: 20, child: AppSpinner(size: 20))
            : AppLineIconWidget(icon),
        tooltip: stringOrNullOf(model, 'tooltip'),
        tone: appIconButtonToneOf(
          stringOrNullOf(model, 'tone') ?? stringOrNullOf(model, 'variant'),
        ),
        shape: stringOf(model, 'shape') == 'circle' ? .circle : .rounded,
        size: appIconButtonSizeOf(stringOrNullOf(model, 'size')),
        dot: boolOf(model, 'dot'),
        dotColor: colorOf(context, model, 'dotColor'),
        onPressed: onPressed,
      ),
    );
  }
}
