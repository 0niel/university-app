import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

class CampusModel extends Equatable {
  final String id;
  final String displayName;
  final List<FloorModel> floors;

  const CampusModel({
    required this.id,
    required this.displayName,
    required this.floors,
  });

  @override
  List<Object?> get props => [id, displayName, floors];
}
