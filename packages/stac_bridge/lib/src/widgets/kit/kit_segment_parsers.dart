import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

enum KitIndexedControl { segmented, tabs }

class StacAppSegmentedControlParser extends StacParser<KitModel> {
  const StacAppSegmentedControlParser();

  @override
  String get type => 'appSegmentedControl';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final options = mapListOf(model, 'options');
    if (options.isEmpty) return const SizedBox.shrink();
    return KitIndexedControlView(
      model: model,
      options: options,
      kind: KitIndexedControl.segmented,
      initial: intStateOf(context, model, 'selectedIndex', 0),
    );
  }
}

class StacAppTabsParser extends StacParser<KitModel> {
  const StacAppTabsParser();

  @override
  String get type => 'appTabs';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final tabs = mapListOf(model, 'tabs');
    if (tabs.isEmpty) return const SizedBox.shrink();
    return KitIndexedControlView(
      model: model,
      options: tabs,
      kind: KitIndexedControl.tabs,
      initial: intStateOf(context, model, 'selectedIndex', 0),
    );
  }
}

class KitIndexedControlView extends StatefulWidget {
  const KitIndexedControlView({
    required this.model,
    required this.options,
    required this.kind,
    required this.initial,
    super.key,
  });

  final KitModel model;
  final List<KitModel> options;
  final KitIndexedControl kind;
  final int initial;

  @override
  State<KitIndexedControlView> createState() => _KitIndexedControlViewState();
}

class _KitIndexedControlViewState extends State<KitIndexedControlView> {
  late int _index = _clamp(widget.initial);

  int _clamp(int value) => value.clamp(0, widget.options.length - 1);

  @override
  void didUpdateWidget(covariant KitIndexedControlView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial ||
        oldWidget.kind != widget.kind ||
        oldWidget.options.length != widget.options.length ||
        stateKeyOf(oldWidget.model) != stateKeyOf(widget.model)) {
      _index = _clamp(widget.initial);
    }
  }

  void _onChanged(int index) {
    if (index != _index) setState(() => _index = index);
    final option = widget.options[index];
    writeStateValue(
      context,
      widget.model,
      stringOrNullOf(option, 'value') ?? index,
    );
    actionOf(context, option, const ['onSelected', 'onTap'])?.call();
    actionOf(context, widget.model, const ['onChanged', 'onChange'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final enabled = boolOf(model, 'enabled', fallback: true);
    final control = switch (widget.kind) {
      KitIndexedControl.segmented => AppSegmentedControl<int>(
        value: _index,
        onCanvas: boolOf(model, 'onCanvas'),
        expanded: boolOf(model, 'expanded', fallback: true),
        onChanged: enabled ? _onChanged : null,
        options: [
          for (final (index, option) in widget.options.indexed)
            AppSegmentedOption(
              value: index,
              label: stringOf(option, 'label'),
              icon: iconOf(option, 'icon'),
            ),
        ],
      ),
      KitIndexedControl.tabs => NinjaTabs<int>(
        value: _index,
        padding: insetsOf(model, 'padding', 0),
        onChanged: enabled ? _onChanged : null,
        tabs: [
          for (final (index, option) in widget.options.indexed)
            NinjaTab(
              value: index,
              label: stringOf(option, 'label'),
              count: intOf(option, 'count'),
            ),
        ],
      ),
    };
    final child = childWidget(context, widget.options[_index]['child']);
    if (child == null) return control;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        control,
        SizedBox(height: doubleOr(model, 'gap', AppSpacing.md)),
        child,
      ],
    );
  }
}
