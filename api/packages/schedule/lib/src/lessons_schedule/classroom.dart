import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:schedule/src/lessons_schedule/campus.dart';

part 'classroom.g.dart';

/// {@template classroom}
/// A classroom is a location where lessons can take place. It can be either
/// online or offline (default, in a physical location).
/// {@endtemplate}
@JsonSerializable()
@immutable
class Classroom extends Equatable {
  /// {@macro classroom}
  const Classroom({
    required this.name,
    this.uid,
    this.campus,
  }) : url = null;

  /// Classroom for online lessons.
  const Classroom.online({
    this.url,
  })  : uid = null,
        campus = null,
        name = 'Online';

  /// Converts a `Map<String, dynamic>` into a [Classroom] instance.
  factory Classroom.fromJson(Map<String, dynamic> json) => _$ClassroomFromJson(json);

  /// The unique identifier of the classroom. This is used for identifying the
  /// classroom in the database and in the API.
  final String? uid;

  /// The name of the classroom.
  final String name;

  /// The campus where the classroom is located.
  final Campus? campus;

  /// The URL if the classroom is online.
  final String? url;

  /// Is the classroom online.
  bool get isOnline => url != null && name == 'Online';

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$ClassroomToJson(this);

  /// Creates a copy of the current instance with the specified fields replaced
  /// with the new values.
  Classroom copyWith({
    String? uid,
    String? name,
    Campus? campus,
    String? url,
  }) {
    return Classroom(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      campus: campus ?? this.campus,
    );
  }

  @override
  List<Object?> get props => [uid, name, campus, url];
}
