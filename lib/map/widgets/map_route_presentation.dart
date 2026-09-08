import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

String mapRouteInstructionLabel(
  IndoorRouteInstruction instruction,
  CampusMapData campus,
) {
  final floor = campus
      .floorForId(
        instruction.toNode?.floorId ?? instruction.atNode.floorId,
      )
      ?.floor
      .number;
  final changesFloor =
      instruction.toNode != null &&
      instruction.toNode!.floorId != instruction.atNode.floorId;
  final floorLabel = floor == null ? 'другой' : '$floor';
  return switch (instruction.maneuver) {
    IndoorManeuver.depart => 'Начните маршрут',
    IndoorManeuver.straight => 'Продолжайте прямо',
    IndoorManeuver.turnLeft => 'Поверните налево',
    IndoorManeuver.turnRight => 'Поверните направо',
    IndoorManeuver.turnBack => 'Развернитесь',
    IndoorManeuver.stairs =>
      changesFloor ? 'По лестнице на $floorLabel этаж' : 'Пройдите по лестнице',
    IndoorManeuver.elevator => 'На лифте на $floorLabel этаж',
    IndoorManeuver.ramp =>
      changesFloor ? 'По пандусу на $floorLabel этаж' : 'Пройдите по пандусу',
    IndoorManeuver.escalator =>
      changesFloor
          ? 'На эскалаторе на $floorLabel этаж'
          : 'Пройдите по эскалатору',
    IndoorManeuver.floorTransition => 'Перейдите на $floorLabel этаж',
    IndoorManeuver.arrive => 'Вы на месте',
  };
}

IconData mapRouteInstructionIcon(IndoorManeuver maneuver) => switch (maneuver) {
  IndoorManeuver.depart => Icons.trip_origin_rounded,
  IndoorManeuver.arrive => Icons.flag_rounded,
  IndoorManeuver.turnLeft => Icons.turn_left_rounded,
  IndoorManeuver.turnRight => Icons.turn_right_rounded,
  IndoorManeuver.turnBack => Icons.u_turn_left_rounded,
  IndoorManeuver.stairs => Icons.stairs_rounded,
  IndoorManeuver.elevator => Icons.elevator_rounded,
  IndoorManeuver.escalator => Icons.escalator_rounded,
  IndoorManeuver.ramp => Icons.accessible_forward_rounded,
  IndoorManeuver.floorTransition => Icons.swap_vert_rounded,
  IndoorManeuver.straight => Icons.straight_rounded,
};

String mapRouteNodeLabel(IndoorNavigationNode node, CampusMapData campus) =>
    campus.placeForId(node.roomId ?? '')?.label ??
    node.label ??
    'Точка на плане';

String mapRouteInstructionContext(
  IndoorRouteInstruction instruction,
  CampusMapData campus,
) {
  final from = campus.floorForId(instruction.atNode.floorId)?.floor.number;
  final to = campus.floorForId(instruction.toNode?.floorId ?? '')?.floor.number;
  final parts = <String>[];
  if (instruction.maneuver == IndoorManeuver.depart ||
      instruction.maneuver == IndoorManeuver.arrive) {
    parts.add(mapRouteNodeLabel(instruction.atNode, campus));
  }
  if (instruction.toNode != null &&
      instruction.atNode.floorId != instruction.toNode!.floorId &&
      from != null &&
      to != null) {
    parts.add('$from → $to этаж');
    if (from != to) parts.add(to > from ? 'Подъём' : 'Спуск');
  } else if (from != null) {
    parts.add('$from этаж');
  }
  final distance = instruction.distanceMeters;
  if (distance != null && distance > 0) {
    parts.add(distance < 1 ? '<1 м' : '${distance.round()} м');
  }
  return parts.join(' · ');
}
