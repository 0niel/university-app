import 'package:flutter/widgets.dart';

class NinjaWeekDay {
  const NinjaWeekDay(
    this.label, {
    this.short,
    this.isWeekend = false,
    this.isPast = false,
    this.isToday = false,
    this.dots = const <Color>[],
    this.semanticsLabel,
  });

  final String label;
  final String? short;
  final bool isWeekend;
  final bool isPast;
  final bool isToday;
  final List<Color> dots;
  final String? semanticsLabel;
}
