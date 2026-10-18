import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_guidance.dart';

class MapRouteOverlay extends StatelessWidget {
  const MapRouteOverlay({
    required this.campus,
    required this.route,
    required this.stepIndex,
    required this.onClose,
    this.onNext,
    this.onPrevious,
    this.onStepSelected,
    this.maxHeight,
    super.key,
  });

  final CampusMapData campus;
  final IndoorRoute route;
  final int stepIndex;
  final VoidCallback onClose;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final ValueChanged<int>? onStepSelected;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final guidance = MapRouteGuidance(
      campus: campus,
      route: route,
      stepIndex: stepIndex,
      onClose: onClose,
      onNext: onNext,
      onPrevious: onPrevious,
      onStepSelected: onStepSelected,
    );
    return maxHeight == null
        ? guidance
        : ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight!),
            child: SingleChildScrollView(primary: false, child: guidance),
          );
  }
}
