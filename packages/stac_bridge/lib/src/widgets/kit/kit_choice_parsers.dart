import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

enum KitBoolControl { toggle, checkbox }

class StacAppToggleParser extends StacParser<KitModel> {
  const StacAppToggleParser();

  @override
  String get type => 'appToggle';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitBoolControlView(
    model: model,
    kind: KitBoolControl.toggle,
    initial: boolStateOf(context, model, 'value'),
  );
}

class StacAppSwitchParser extends StacAppToggleParser {
  const StacAppSwitchParser();

  @override
  String get type => 'appSwitch';
}

class StacAppCheckboxParser extends StacParser<KitModel> {
  const StacAppCheckboxParser();

  @override
  String get type => 'appCheckbox';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitBoolControlView(
    model: model,
    kind: KitBoolControl.checkbox,
    initial: boolStateOf(context, model, 'value'),
  );
}

class KitBoolControlView extends StatefulWidget {
  const KitBoolControlView({
    required this.model,
    required this.kind,
    required this.initial,
    super.key,
  });

  final KitModel model;
  final KitBoolControl kind;
  final bool initial;

  @override
  State<KitBoolControlView> createState() => _KitBoolControlViewState();
}

class _KitBoolControlViewState extends State<KitBoolControlView> {
  late bool _value = widget.initial;

  String get _id => stringOf(widget.model, 'id');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_id.isEmpty) return;
    context.dependOnInheritedWidgetOfExactType<StacFormScope>()?.formData[_id] =
        _value;
  }

  @override
  void didUpdateWidget(covariant KitBoolControlView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial ||
        oldWidget.kind != widget.kind ||
        stateKeyOf(oldWidget.model) != stateKeyOf(widget.model) ||
        stringOf(oldWidget.model, 'id') != _id) {
      _value = widget.initial;
    }
  }

  void _onChanged(bool value) {
    setState(() => _value = value);
    if (_id.isNotEmpty) {
      context
              .dependOnInheritedWidgetOfExactType<StacFormScope>()
              ?.formData[_id] =
          value;
    }
    writeStateValue(context, widget.model, value);
    actionOf(
      context,
      widget.model,
      const ['onChanged', 'onChange'],
    )?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final enabled = boolOf(model, 'enabled', fallback: true);
    final label = stringOrNullOf(model, 'label');
    final onChanged = enabled ? _onChanged : null;
    return switch (widget.kind) {
      KitBoolControl.toggle => AppSwitch(
        value: _value,
        label: label,
        semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
        onChanged: onChanged,
      ),
      KitBoolControl.checkbox => AppCheckbox(
        value: _value,
        label: label,
        indeterminate: boolOf(model, 'indeterminate'),
        semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
        onChanged: onChanged,
      ),
    };
  }
}

class StacAppRadioParser extends StacParser<KitModel> {
  const StacAppRadioParser();

  @override
  String get type => 'appRadio';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final value = stringOf(model, 'value');
    final registry = RadioGroup.maybeOf<dynamic>(context);
    final groupValue =
        registry?.groupValue?.toString() ??
        stringStateOf(context, model, 'groupValue');
    final enabled = boolOf(model, 'enabled', fallback: true);
    return AppRadio<String>(
      value: value,
      groupValue: groupValue.isEmpty ? null : groupValue,
      label: stringOrNullOf(model, 'label'),
      semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
      onChanged: !enabled
          ? null
          : (selected) {
              registry?.onChanged(selected);
              writeStateValue(context, model, selected);
              actionOf(context, model, const ['onChanged', 'onChange'])?.call();
            },
    );
  }
}
