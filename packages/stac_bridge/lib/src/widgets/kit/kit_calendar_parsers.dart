import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

LessonRowState? lessonRowStateOf(String? name) => switch (name) {
  'plain' => LessonRowState.plain,
  'past' => LessonRowState.past,
  'current' || 'now' => LessonRowState.current,
  'next' => LessonRowState.next,
  'moved' => LessonRowState.moved,
  'cancelled' => LessonRowState.cancelled,
  'exam' => LessonRowState.exam,
  'own' || 'custom' => LessonRowState.own,
  _ => null,
};

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

class StacAppLessonRowParser extends StacParser<KitModel> {
  const StacAppLessonRowParser();

  @override
  String get type => 'appLessonRow';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => NinjaLessonRow(
    title: stringOf(model, 'title'),
    time: stringOf(model, 'time'),
    endTime: stringOrNullOf(model, 'endTime'),
    meta: stringOrNullOf(model, 'meta'),
    color: colorOf(context, model, 'color'),
    typeLabel: stringOrNullOf(model, 'typeLabel'),
    chipLabel: stringOrNullOf(model, 'chipLabel'),
    chipColor: colorOf(context, model, 'chipColor'),
    state: lessonRowStateOf(stringOrNullOf(model, 'state')),
    progress: doubleOf(model, 'progress'),
    stateLabel: stringOrNullOf(model, 'stateLabel'),
    inset: doubleOr(model, 'inset', 0),
    onTap: actionOf(context, model, const ['onTap']),
    onMore: actionOf(context, model, const ['onMore']),
    actions: [
      for (final action in mapListOf(model, 'actions'))
        NinjaLessonAction(
          label: stringOf(action, 'label'),
          primary: boolOf(action, 'primary', fallback: true),
          onPressed: actionOf(context, action, const ['onPressed', 'onTap']),
        ),
    ],
  );
}
