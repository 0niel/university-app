import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_resource.freezed.dart';

@freezed
sealed class TeacherResource<T> with _$TeacherResource<T> {
  const TeacherResource._();

  const factory TeacherResource.idle() = TeacherResourceIdle<T>;
  const factory TeacherResource.loading({T? previous}) =
      TeacherResourceLoading<T>;
  const factory TeacherResource.ready(T value) = TeacherResourceReady<T>;
  const factory TeacherResource.failure({T? previous}) =
      TeacherResourceFailure<T>;

  T? get data => switch (this) {
    TeacherResourceReady(:final value) => value,
    TeacherResourceLoading(:final previous) ||
    TeacherResourceFailure(:final previous) => previous,
    TeacherResourceIdle() => null,
  };

  bool get isLoading => this is TeacherResourceLoading<T>;
  bool get hasError => this is TeacherResourceFailure<T>;
}
