import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
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
