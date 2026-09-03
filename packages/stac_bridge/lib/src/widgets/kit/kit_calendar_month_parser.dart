import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

String isoDate(DateTime day) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${day.year}-${two(day.month)}-${two(day.day)}';
}

DateTime? dateOf(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value.length == 7 ? '$value-01' : value);
  return parsed == null
      ? null
      : DateTime(parsed.year, parsed.month, parsed.day);
}

class StacAppCalendarMonthParser extends StacParser<KitModel> {
  const StacAppCalendarMonthParser();

  @override
  String get type => 'appCalendarMonth';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final selected =
        dateOf(model['selected']) ?? dateOf(stateValueOf(context, model));
    return _CalendarMonth(
      model: model,
      initialMonth: dateOf(model['month']) ?? selected ?? DateTime.now(),
      initialSelected: selected,
    );
  }
}

class _CalendarMonth extends StatefulWidget {
  const _CalendarMonth({
    required this.model,
    required this.initialMonth,
    required this.initialSelected,
  });

  final KitModel model;
  final DateTime initialMonth;
  final DateTime? initialSelected;

  @override
  State<_CalendarMonth> createState() => _CalendarMonthState();
}

class _CalendarMonthState extends State<_CalendarMonth> {
  late DateTime _month = widget.initialMonth;
  late DateTime? _selected = widget.initialSelected;

  @override
  void didUpdateWidget(covariant _CalendarMonth oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelected != widget.initialSelected ||
        stateKeyOf(oldWidget.model) != stateKeyOf(widget.model)) {
      _selected = widget.initialSelected;
    }
    if (oldWidget.initialMonth != widget.initialMonth) {
      _month = widget.initialMonth;
    }
  }

  List<Color> _dots(DateTime day) {
    final marks = widget.model['marks'];
    if (marks is! Map<Object?, Object?>) return const [];
    final raw = marks[isoDate(day)];
    if (raw is! List<Object?>) return const [];
    return [
      for (final item in raw) ?parseAppColor(context, item?.toString()),
    ];
  }

  void _onDaySelected(DateTime day) {
    setState(() => _selected = day);
    writeStateValue(context, widget.model, isoDate(day));
    actionOf(context, widget.model, const [
      'onChanged',
      'onDaySelected',
    ])?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AppCalendarMonth(
      month: _month,
      selectedDay: _selected,
      today: dateOf(widget.model['today']),
      dotsForDay: _dots,
      onMonthChanged: (month) => setState(() => _month = month),
      onDaySelected: _onDaySelected,
    );
  }
}
