import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/async_action_builder.dart';
import 'package:stac_bridge/src/widgets/material/material_icon_names.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

Widget kitButtonFromMaterial(
  BuildContext context,
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

class StacElevatedButtonKitParser extends StacParser<KitModel> {
  const StacElevatedButtonKitParser();

  @override
  String get type => 'elevatedButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      kitButtonFromMaterial(context, model, AppButtonVariant.primary);
}

class StacFilledButtonKitParser extends StacElevatedButtonKitParser {
  const StacFilledButtonKitParser();

  @override
  String get type => 'filledButton';
}

class StacOutlinedButtonKitParser extends StacParser<KitModel> {
  const StacOutlinedButtonKitParser();

  @override
  String get type => 'outlinedButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      kitButtonFromMaterial(context, model, AppButtonVariant.secondary);
}

class StacTextButtonKitParser extends StacParser<KitModel> {
  const StacTextButtonKitParser();

  @override
  String get type => 'textButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      kitButtonFromMaterial(context, model, AppButtonVariant.text);
}

class StacIconButtonKitParser extends StacParser<KitModel> {
  const StacIconButtonKitParser();

  @override
  String get type => 'iconButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final lineIcon = lineIconOfNode(model['icon']);
    final icon = lineIcon != null
        ? AppLineIconWidget(lineIcon)
        : childWidget(context, model['icon']);
    if (icon == null) return const SizedBox.shrink();
    return AppIconButton(
      icon: icon,
      tone: AppIconButtonTone.plain,
      tooltip: stringOrNullOf(model, 'tooltip'),
      foregroundColor: colorOf(context, model, 'color'),
      onPressed: actionCallback(context, model['onPressed']),
    );
  }
}

class StacFloatingActionButtonKitParser extends StacParser<KitModel> {
  const StacFloatingActionButtonKitParser();

  @override
  String get type => 'floatingActionButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon =
        lineIconOfNode(model['icon']) ??
        lineIconOfNode(model['child']) ??
        AppLineIcon.plus;
    final label = labelOf(model['child']);
    final onPressed = actionCallback(context, model['onPressed']);
    final tooltip = stringOrNullOf(model, 'tooltip');
    if (stringOf(model, 'buttonType') == 'extended' && label.isNotEmpty) {
      return AppFab.extended(
        icon: icon,
        label: label,
        onPressed: onPressed,
        tooltip: tooltip,
      );
    }
    return AppFab(icon: icon, onPressed: onPressed, tooltip: tooltip);
  }
}
