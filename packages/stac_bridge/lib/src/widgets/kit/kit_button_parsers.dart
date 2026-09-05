import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/async_action_builder.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

AppButtonVariant appButtonVariantOf(String? name) =>
    enumByName(AppButtonVariant.values, name, AppButtonVariant.primary);

AppButtonSize appButtonSizeOf(String? name) =>
    enumByName(AppButtonSize.values, name, AppButtonSize.medium);

AppIconButtonTone appIconButtonToneOf(String? name) => switch (name) {
  'primary' || 'filled' => AppIconButtonTone.primary,
  'tonal' => AppIconButtonTone.tonal,
  'danger' || 'destructive' => AppIconButtonTone.danger,
  'secondary' || 'outline' => AppIconButtonTone.secondary,
  'surface' => AppIconButtonTone.surface,
  _ => AppIconButtonTone.plain,
};

AppIconButtonSize appIconButtonSizeOf(String? name) => switch (name) {
  'small' => AppIconButtonSize.small,
  'compact' => AppIconButtonSize.compact,
  _ => AppIconButtonSize.regular,
};

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
        shape: stringOf(model, 'shape') == 'circle'
            ? AppIconButtonShape.circle
            : AppIconButtonShape.rounded,
        size: appIconButtonSizeOf(stringOrNullOf(model, 'size')),
        dot: boolOf(model, 'dot'),
        dotColor: colorOf(context, model, 'dotColor'),
        onPressed: onPressed,
      ),
    );
  }
}

class StacAppFabParser extends StacParser<KitModel> {
  const StacAppFabParser();

  @override
  String get type => 'appFab';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon = iconOf(model, 'icon') ?? AppLineIcon.plus;
    final label = stringOf(model, 'label');
    final enabled = boolOf(model, 'enabled', fallback: true);
    final onPressed = enabled
        ? actionOf(context, model, const ['onPressed', 'onTap'])
        : null;
    final tooltip = stringOrNullOf(model, 'tooltip');
    if (label.isEmpty) {
      return AppFab(icon: icon, onPressed: onPressed, tooltip: tooltip);
    }
    return AppFab.extended(
      icon: icon,
      label: label,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
