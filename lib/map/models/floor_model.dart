import 'package:equatable/equatable.dart';

class FloorModel extends Equatable {
  final String id;
  final int number;
  final String svgPath;

  const FloorModel({
    required this.id,
    required this.number,
    required this.svgPath,
  });

  @override
  List<Object?> get props => [id, number, svgPath];
}
