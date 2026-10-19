import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

String mapRouteInstructionLabel(
  IndoorRouteInstruction instruction,
  CampusMapData campus,
  AppLocalizations l10n,
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
  final floorLabel = floor == null
      ? l10n.mapRouteAnotherFloor
      : l10n.mapFloorNumber(floor);
  return switch (instruction.maneuver) {
    IndoorManeuver.depart => l10n.mapRouteDepart,
    IndoorManeuver.straight => l10n.mapRouteStraight,
    IndoorManeuver.turnLeft => l10n.mapRouteTurnLeft,
    IndoorManeuver.turnRight => l10n.mapRouteTurnRight,
    IndoorManeuver.turnBack => l10n.mapRouteTurnBack,
    IndoorManeuver.stairs =>
      changesFloor
          ? l10n.mapRouteStairsToFloor(floorLabel)
          : l10n.mapRouteStairs,
    IndoorManeuver.elevator => l10n.mapRouteElevatorToFloor(floorLabel),
    IndoorManeuver.ramp =>
      changesFloor ? l10n.mapRouteRampToFloor(floorLabel) : l10n.mapRouteRamp,
    IndoorManeuver.escalator =>
      changesFloor
          ? l10n.mapRouteEscalatorToFloor(floorLabel)
          : l10n.mapRouteEscalator,
    IndoorManeuver.floorTransition => l10n.mapRouteChangeFloor(floorLabel),
    IndoorManeuver.arrive => l10n.mapRouteArrive,
  };
}

String mapRouteInstructionCompactLabel(
  IndoorManeuver maneuver,
  AppLocalizations l10n,
) => switch (maneuver) {
  IndoorManeuver.depart => l10n.mapRouteCompactStart,
  IndoorManeuver.straight => l10n.mapRouteCompactStraight,
  IndoorManeuver.turnLeft => l10n.mapRouteCompactLeft,
  IndoorManeuver.turnRight => l10n.mapRouteCompactRight,
  IndoorManeuver.turnBack => l10n.mapRouteCompactTurnBack,
  IndoorManeuver.stairs => l10n.mapRouteCompactStairs,
  IndoorManeuver.elevator => l10n.mapRouteCompactElevator,
  IndoorManeuver.ramp => l10n.mapRouteCompactRamp,
  IndoorManeuver.escalator => l10n.mapRouteCompactEscalator,
  IndoorManeuver.floorTransition => l10n.mapRouteCompactTransition,
  IndoorManeuver.arrive => l10n.mapRouteCompactFinish,
};

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

String mapRouteNodeLabel(
  IndoorNavigationNode node,
  CampusMapData campus,
  AppLocalizations l10n,
) =>
    campus.placeForId(node.roomId ?? '')?.label ??
    node.label ??
    l10n.mapRoutePointFallback;

String mapRouteInstructionContext(
  IndoorRouteInstruction instruction,
  CampusMapData campus,
  AppLocalizations l10n,
) {
  final from = campus.floorForId(instruction.atNode.floorId)?.floor.number;
  final to = campus.floorForId(instruction.toNode?.floorId ?? '')?.floor.number;
  final parts = <String>[];
  switch (instruction.maneuver) {
    case IndoorManeuver.depart || IndoorManeuver.arrive:
      parts.add(mapRouteNodeLabel(instruction.atNode, campus, l10n));
    case IndoorManeuver.straight ||
        IndoorManeuver.turnLeft ||
        IndoorManeuver.turnRight ||
        IndoorManeuver.turnBack ||
        IndoorManeuver.stairs ||
        IndoorManeuver.elevator ||
        IndoorManeuver.ramp ||
        IndoorManeuver.escalator ||
        IndoorManeuver.floorTransition:
      break;
  }
  if (instruction.toNode != null &&
      instruction.atNode.floorId != instruction.toNode!.floorId &&
      from != null &&
      to != null) {
    parts.add(l10n.mapRouteFloorTransition(from, to));
    if (from != to) {
      parts.add(to > from ? l10n.mapRouteAscent : l10n.mapRouteDescent);
    }
  } else if (from != null) {
    parts.add(l10n.mapFloorNumber(from));
  }
  return parts.join(' · ');
}
