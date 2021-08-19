import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int id;
  final String name;

  Tag({required this.id, required this.name});

  factory Tag.from_json(Map<String, dynamic> json) =>
      Tag(id: json['id'], name: json['name']);

  @override
  List<Object?> get props => [id];
}
