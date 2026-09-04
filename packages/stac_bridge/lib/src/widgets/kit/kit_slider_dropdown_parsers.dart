import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_select_parsers.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacSliderKitParser extends StacParser<KitModel> {
  const StacSliderKitParser();

  @override
  String get type => 'slider';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => _KitSlider(
    model: model,
    initial: doubleStateOf(context, model, 'value'),
  );
}

class _KitSlider extends StatefulWidget {
  const _KitSlider({required this.model, required this.initial});

  final KitModel model;
  final double initial;

  @override
  State<_KitSlider> createState() => _KitSliderState();
}

class _KitSliderState extends State<_KitSlider> {
  late double _value = widget.initial;

  String get _id => stringOf(widget.model, 'id');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_id.isEmpty) return;
    context.dependOnInheritedWidgetOfExactType<StacFormScope>()?.formData[_id] =
        _value;
  }

  @override
  void didUpdateWidget(covariant _KitSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial ||
        stateKeyOf(oldWidget.model) != stateKeyOf(widget.model) ||
        stringOf(oldWidget.model, 'id') != _id) {
      _value = widget.initial;
    }
  }

  void _onChanged(double value) {
    setState(() => _value = value);
    if (_id.isNotEmpty) {
      context
              .dependOnInheritedWidgetOfExactType<StacFormScope>()
              ?.formData[_id] =
          value;
    }
    writeStateValue(context, widget.model, value);
    actionOf(context, widget.model, const ['onChanged', 'onChange'])?.call();
  }

  void _onChangeEnd(double value) {
    actionOf(context, widget.model, const ['onChangeEnd'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final enabled = boolOf(model, 'enabled', fallback: true);
    return AppSlider(
      value: _value,
      min: doubleOr(model, 'min', 0),
      max: doubleOr(model, 'max', 1),
      divisions: intOf(model, 'divisions'),
      label: stringOrNullOf(model, 'label'),
      enabled: enabled,
      semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
      onChanged: enabled ? _onChanged : null,
      onChangeEnd: enabled ? _onChangeEnd : null,
    );
  }
}

class StacDropdownMenuKitParser extends StacParser<KitModel> {
  const StacDropdownMenuKitParser();

  @override
  String get type => 'dropdownMenu';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      _KitDropdownMenu(model: model);
}

class _KitDropdownMenu extends StatefulWidget {
  const _KitDropdownMenu({required this.model});

  final KitModel model;

  @override
  State<_KitDropdownMenu> createState() => _KitDropdownMenuState();
}

class _KitDropdownMenuState extends State<_KitDropdownMenu> {
  String? _picked;

  @override
  void didUpdateWidget(covariant _KitDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (stateKeyOf(oldWidget.model) != stateKeyOf(widget.model) ||
        oldWidget.model['initialSelection'] !=
            widget.model['initialSelection']) {
      _picked = null;
    }
  }

  List<KitOption> _entriesOf(KitModel model) {
    final entries = optionsOf(model, 'dropdownMenuEntries');
    return entries.isNotEmpty ? entries : optionsOf(model, 'entries');
  }

  Future<void> _pick(List<KitOption> entries, String current) async {
    final model = widget.model;
    final chosen = await showAppSheet<String>(
      context,
      title: stringOrNullOf(model, 'sheetTitle'),
      child: AppListGroup(
        children: [
          for (final entry in entries)
            Builder(
              builder: (sheetContext) => AppListRow(
                title: entry.label,
                showChevron: false,
                trailing: entry.value == current
                    ? AppLineIconWidget(
                        AppLineIcon.check,
                        size: 18,
                        color: sheetContext.colors.accent,
                      )
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(entry.value),
              ),
            ),
        ],
      ),
    );
    if (chosen == null || !mounted) return;
    setState(() => _picked = chosen);
    writeStateValue(context, model, chosen);
    actionOf(context, model, const [
      'onSelected',
      'onChanged',
      'onChange',
    ])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final entries = _entriesOf(model);
    final current =
        _picked ?? stringStateOf(context, model, 'initialSelection');
    var label = '';
    for (final entry in entries) {
      if (entry.value == current) {
        label = entry.label;
        break;
      }
    }
    final labelText = labelOf(model['label']);
    final enabled = boolOf(model, 'enabled', fallback: true);
    final onTap = entries.isEmpty
        ? actionOf(context, model, const ['onTap'])
        : () => _pick(entries, current);
    return AppSelectField(
      value: current.isEmpty ? null : (label.isEmpty ? current : label),
      placeholder: stringOrNullOf(model, 'hintText'),
      label: labelText.isEmpty ? null : labelText,
      helperText:
          stringOrNullOf(model, 'errorText') ??
          stringOrNullOf(model, 'helperText'),
      enabled: enabled,
      onTap: enabled ? onTap : null,
    );
  }
}
