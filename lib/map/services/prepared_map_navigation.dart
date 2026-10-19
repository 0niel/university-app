import 'package:rtu_mirea_app/map/navigation/indoor_navigation_graph.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmark.dart';

class PreparedMapNavigation {
  const PreparedMapNavigation({required this.graph, required this.byFloor});

  final IndoorNavigationGraph? graph;
  final Map<String, List<MapNavigationLandmark>> byFloor;
}
