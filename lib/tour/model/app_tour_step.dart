import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/tour/model/app_tour_target.dart';

@immutable
class AppTourStep {
  const AppTourStep({
    required this.title,
    required this.body,
    this.target,
    this.location,
    this.shape = NinjaSpotlightShape.rounded,
    this.radius = 22,
    this.padding = 8,
    this.optional = true,
  });

  final String title;
  final String body;

  final AppTourTarget? target;

  final String? location;

  final NinjaSpotlightShape shape;
  final double radius;

  final double padding;

  final bool optional;
}
