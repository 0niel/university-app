import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'teacher.g.dart';

/// {@template teacher}
/// The teacher data.
/// {@endtemplate}
@JsonSerializable()
@immutable
class Teacher extends Equatable {
  /// {@macro teacher}
  const Teacher({
    required this.name,
    this.uid,
    this.photoUrl,
    this.email,
    this.phone,
    this.post,
    this.department,
  });

  /// Converts a `Map<String, dynamic>` into a [Teacher] instance.
  factory Teacher.fromJson(Map<String, dynamic> json) => _$TeacherFromJson(json);

  /// The unique identifier of the Teacher. This is used for identifying the
  /// Teacher in the database and in the API.
  final String? uid;

  /// The name of the Teacher.
  final String name;

  /// The URL of the Teacher's photo.
  final String? photoUrl;

  /// Email address.
  final String? email;

  /// Phone number.
  final String? phone;

  /// Work post.
  final String? post;

  /// Department where the Teacher works.
  final String? department;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$TeacherToJson(this);

  @override
  List<Object?> get props => [uid, name, photoUrl, email, phone, post, department];
}
