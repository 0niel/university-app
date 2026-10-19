import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_choice_parsers.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

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
      .toggle => AppSwitch(
        value: _value,
        label: label,
        semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
        onChanged: onChanged,
      ),
      .checkbox => AppCheckbox(
        value: _value,
        label: label,
        indeterminate: boolOf(model, 'indeterminate'),
        semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
        onChanged: onChanged,
      ),
    };
  }
}
