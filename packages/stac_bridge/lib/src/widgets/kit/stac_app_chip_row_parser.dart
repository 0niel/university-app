import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_select_parsers.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

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
        : (options.firstOrNull?.value ?? '');
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
