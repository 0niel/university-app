import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

typedef KitOption = ({String value, String label});

List<KitOption> optionsOf(KitModel model, String key) {
  final raw = model[key];
  if (raw is! List<Object?>) return const [];
  return [
    for (final item in raw)
      if (item is Map<Object?, Object?>)
        (
          value: item['value']?.toString() ?? '',
          label: item['label']?.toString() ?? item['value']?.toString() ?? '',
        )
      else if (item != null)
        (value: item.toString(), label: item.toString()),
  ];
}

class StacAppSelectFieldParser extends StacParser<KitModel> {
  const StacAppSelectFieldParser();

  @override
  String get type => 'appSelectField';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      _SelectField(model: model);
}

class _SelectField extends StatefulWidget {
  const _SelectField({required this.model});

  final KitModel model;

  @override
  State<_SelectField> createState() => _SelectFieldState();
}

class _SelectFieldState extends State<_SelectField> {
  String? _picked;

  @override
  void didUpdateWidget(covariant _SelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (stateKeyOf(oldWidget.model) != stateKeyOf(widget.model) ||
        oldWidget.model['value'] != widget.model['value']) {
      _picked = null;
    }
  }

  Future<void> _pick(List<KitOption> options, String current) async {
    final model = widget.model;
    final chosen = await showAppSheet<String>(
      context,
      title:
          stringOrNullOf(model, 'sheetTitle') ?? stringOrNullOf(model, 'label'),
      child: AppListGroup(
        children: [
          for (final option in options)
            Builder(
              builder: (sheetContext) => AppListRow(
                title: option.label,
                showChevron: false,
                trailing: option.value == current
                    ? AppLineIconWidget(
                        AppLineIcon.check,
                        size: 18,
                        color: sheetContext.colors.accent,
                      )
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(option.value),
              ),
            ),
        ],
      ),
    );
    if (chosen == null || !mounted) return;
    setState(() => _picked = chosen);
    writeStateValue(context, model, chosen);
    actionOf(context, model, const ['onChanged', 'onChange'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final options = optionsOf(model, 'options');
    final current = _picked ?? stringStateOf(context, model, 'value');
    final label = options
        .where((option) => option.value == current)
        .map((option) => option.label)
        .firstOrNull;
    final enabled = boolOf(model, 'enabled', fallback: true);
    final onTap = options.isEmpty
        ? actionOf(context, model, const ['onTap', 'onPressed'])
        : () => _pick(options, current);
    return AppSelectField(
      value: current.isEmpty ? null : (label ?? current),
      placeholder: stringOrNullOf(model, 'placeholder'),
      label: stringOrNullOf(model, 'label'),
      helperText: stringOrNullOf(model, 'helperText'),
      leadingIcon: iconOf(model, 'leadingIcon'),
      enabled: enabled,
      onTap: enabled ? onTap : null,
    );
  }
}

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
