import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_segment_parsers.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

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
    final option = widget.options.elementAtOrNull(index);
    if (option == null) return;
    if (index != _index) setState(() => _index = index);
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
      .segmented => AppSegmentedControl<int>(
        value: _index,
        isOnCanvas: boolOf(model, 'onCanvas'),
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
      .tabs => NinjaTabs<int>(
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
    final child = childWidget(
      context,
      widget.options.elementAtOrNull(_index)?['child'],
    );
    if (child == null) return control;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        control,
        SizedBox(height: doubleOr(model, 'gap', AppSpacing.md)),
        child,
      ],
    );
  }
}
