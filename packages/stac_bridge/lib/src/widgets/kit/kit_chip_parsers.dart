import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_select_parsers.dart';
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

class StacAppChipRowParser extends StacParser<KitModel> {
  const StacAppChipRowParser();

  @override
  String get type => 'appChipRow';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final padding = insetsOf(model, 'padding', 0);
    final spacing = doubleOr(model, 'spacing', 6);
    final items = mapListOf(model, 'items');
    if (items.isEmpty) {
      return NinjaChipRow(
        padding: padding,
        spacing: spacing,
        children: childrenWidgets(context, model['children']),
      );
    }
    return _ChipRow(
      model: model,
      items: items,
      padding: padding,
      spacing: spacing,
      initial: stringStateOf(context, model, 'value'),
    );
  }
}

class _ChipRow extends StatefulWidget {
  const _ChipRow({
    required this.model,
    required this.items,
    required this.padding,
    required this.spacing,
    required this.initial,
  });

  final KitModel model;
  final List<KitModel> items;
  final EdgeInsets padding;
  final double spacing;
  final String initial;

  @override
  State<_ChipRow> createState() => _ChipRowState();
}

class _ChipRowState extends State<_ChipRow> {
  late String _value = widget.initial;

  @override
  void didUpdateWidget(covariant _ChipRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial ||
        stateKeyOf(oldWidget.model) != stateKeyOf(widget.model)) {
      _value = widget.initial;
    }
  }

  void _onChanged(String value) {
    setState(() => _value = value);
    writeStateValue(context, widget.model, value);
    actionOf(context, widget.model, const ['onChanged', 'onChange'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final options = optionsOf(widget.model, 'items');
    final current = options.any((option) => option.value == _value)
        ? _value
        : options.first.value;
    return AppChipRow<String>(
      value: current,
      padding: widget.padding,
      spacing: widget.spacing,
      onChanged: boolOf(widget.model, 'enabled', fallback: true)
          ? _onChanged
          : null,
      items: [
        for (final item in widget.items)
          AppChipRowItem(
            value: item['value']?.toString() ?? '',
            label: stringOf(item, 'label', item['value']?.toString() ?? ''),
            icon: iconOf(item, 'icon'),
            count: intOf(item, 'count'),
          ),
      ],
    );
  }
}
