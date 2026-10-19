import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppChipParser extends StacParser<KitModel> {
  const StacAppChipParser();

  @override
  String get type => 'appChip';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final label = stringOf(model, 'label');
    final value = stringOrNullOf(model, 'value');
    final stateKey = stateKeyOf(model);
    final selected = stateKey.isNotEmpty && value != null
        ? stateValueOf(context, model)?.toString() == value
        : boolOf(model, 'selected');
    final enabled = boolOf(model, 'enabled', fallback: true);
    final tapAction = actionOf(context, model, const ['onTap', 'onPressed']);
    VoidCallback? onTap;
    if (stateKey.isNotEmpty) {
      onTap = () {
        writeStateValue(context, model, value ?? !selected);
        tapAction?.call();
      };
    } else {
      onTap = tapAction;
    }
    final color = colorOf(context, model, 'color');
    final leadingIcon = iconOf(model, 'leadingIcon');
    final count = intOf(model, 'count');
    final dot = boolOf(model, 'dot') || boolOf(model, 'showDot');
    final dotColor = colorOf(context, model, 'dotColor');
    if (stringOf(model, 'style') == 'tinted') {
      return AppChip(
        label: label,
        selected: selected,
        enabled: enabled,
        color: color,
        count: count,
        showDot: dot,
        dotColor: dotColor,
        leadingIcon: leadingIcon,
        onTap: onTap,
        onRemove: actionOf(context, model, const ['onRemove', 'onDelete']),
        removeSemanticLabel: stringOrNullOf(model, 'removeLabel'),
      );
    }
    return AppChip.filter(
      label: label,
      selected: selected,
      enabled: enabled,
      color: color,
      count: count,
      showDot: dot,
      dotColor: dotColor,
      leadingIcon: leadingIcon,
      onTap: onTap,
    );
  }
}
