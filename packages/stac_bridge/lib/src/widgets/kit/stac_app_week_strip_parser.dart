import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppWeekStripParser extends StacParser<KitModel> {
  const StacAppWeekStripParser();

  @override
  String get type => 'appWeekStrip';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final days = mapListOf(model, 'days');
    if (days.isEmpty) return const SizedBox.shrink();
    return _WeekStrip(
      model: model,
      days: days,
      initial: intStateOf(context, model, 'selectedIndex', 0),
    );
  }
}

class _WeekStrip extends StatefulWidget {
  const _WeekStrip({
    required this.model,
    required this.days,
    required this.initial,
  });

  final KitModel model;
  final List<KitModel> days;
  final int initial;

  @override
  State<_WeekStrip> createState() => _WeekStripState();
}

class _WeekStripState extends State<_WeekStrip> {
  late int _index = widget.initial.clamp(0, widget.days.length - 1);

  @override
  void didUpdateWidget(covariant _WeekStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial ||
        oldWidget.days.length != widget.days.length ||
        stateKeyOf(oldWidget.model) != stateKeyOf(widget.model)) {
      _index = widget.initial.clamp(0, widget.days.length - 1);
    }
  }

  void _onSelected(int index) {
    setState(() => _index = index);
    writeStateValue(context, widget.model, index);
    actionOf(context, widget.model, const ['onChanged', 'onSelected'])?.call();
  }

  @override
  Widget build(BuildContext context) {
    return NinjaWeekStrip(
      selectedIndex: _index,
      dense: boolOf(widget.model, 'dense'),
      padding: insetsOf(widget.model, 'padding', 0),
      onSelected: _onSelected,
      days: [
        for (final day in widget.days)
          NinjaWeekDay(
            stringOf(day, 'label'),
            short: stringOrNullOf(day, 'short'),
            isWeekend: boolOf(day, 'weekend') || boolOf(day, 'isWeekend'),
            isPast: boolOf(day, 'past') || boolOf(day, 'isPast'),
            isToday: boolOf(day, 'today') || boolOf(day, 'isToday'),
            dots: [
              for (final dot in stringListOf(day, 'dots'))
                ?parseAppColor(context, dot),
            ],
          ),
      ],
    );
  }
}
