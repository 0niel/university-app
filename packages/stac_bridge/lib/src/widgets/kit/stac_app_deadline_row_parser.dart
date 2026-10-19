import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppDeadlineRowParser extends StacParser<KitModel> {
  const StacAppDeadlineRowParser();

  @override
  String get type => 'appDeadlineRow';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => _DeadlineRow(
    model: model,
    initial: boolStateOf(context, model, 'done'),
  );
}

class _DeadlineRow extends StatefulWidget {
  const _DeadlineRow({required this.model, required this.initial});

  final KitModel model;
  final bool initial;

  @override
  State<_DeadlineRow> createState() => _DeadlineRowState();
}

class _DeadlineRowState extends State<_DeadlineRow> {
  late bool _done = widget.initial;

  @override
  void didUpdateWidget(covariant _DeadlineRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial ||
        stateKeyOf(oldWidget.model) != stateKeyOf(widget.model) ||
        stringOf(oldWidget.model, 'title') != stringOf(widget.model, 'title')) {
      _done = widget.initial;
    }
  }

  void _toggle() {
    setState(() => _done = !_done);
    writeStateValue(context, widget.model, _done);
    actionOf(context, widget.model, const ['onToggle', 'onChanged'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return AppDeadlineRow(
      title: stringOf(model, 'title'),
      meta: stringOf(model, 'meta'),
      left: stringOf(model, 'left'),
      urgent: boolOf(model, 'urgent'),
      done: _done,
      onTap: actionOf(context, model, const ['onTap']),
      onToggle: boolOf(model, 'enabled', fallback: true) ? _toggle : null,
    );
  }
}
