import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppStepperParser extends StacParser<KitModel> {
  const StacAppStepperParser();

  @override
  String get type => 'appStepper';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => _Stepper(
    model: model,
    initial: intStateOf(context, model, 'value', 0),
  );
}

class _Stepper extends StatefulWidget {
  const _Stepper({required this.model, required this.initial});

  final KitModel model;
  final int initial;

  @override
  State<_Stepper> createState() => _StepperState();
}

class _StepperState extends State<_Stepper> {
  late int _value = widget.initial;

  @override
  void didUpdateWidget(covariant _Stepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial ||
        stateKeyOf(oldWidget.model) != stateKeyOf(widget.model)) {
      _value = widget.initial;
    }
  }

  void _onChanged(int value) {
    setState(() => _value = value);
    writeStateValue(context, widget.model, value);
    actionOf(context, widget.model, const ['onChanged', 'onChange'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return AppStepper(
      value: _value,
      min: intOf(model, 'min') ?? 0,
      max: intOf(model, 'max') ?? 99,
      onChanged: boolOf(model, 'enabled', fallback: true) ? _onChanged : null,
    );
  }
}
