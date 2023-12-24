import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'group.g.dart';

/// {@template Group}
/// A group is a group of students who study together.
/// {@endtemplate}
@JsonSerializable()
@immutable
class Group extends Equatable {
  /// {@macro Group}
  const Group({
    required this.name,
    this.uid,
  });

  /// Converts a `Map<String, dynamic>` into a [Group] instance.
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  /// Group name.
  final String name;

  /// The unique identifier of the Group. This is used for identifying the
  /// Group in the database and in the API.
  final String? uid;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @override
  List<Object?> get props => [name, uid];
}
