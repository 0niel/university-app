import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/src/lessons_schedule/campus.dart';

part 'classroom.freezed.dart';
part 'classroom.g.dart';

@freezed
abstract class Classroom with _$Classroom {
  const factory Classroom({
    required String name,
    String? uid,
    Campus? campus,
    String? url,
  }) = _Classroom;

  const Classroom._();

  factory Classroom.online({String? url}) =>
      Classroom(name: 'Online', url: url);

  factory Classroom.fromJson(Map<String, dynamic> json) =>
      _$ClassroomFromJson(json);

  bool get isOnline => url != null && name == 'Online';
}
