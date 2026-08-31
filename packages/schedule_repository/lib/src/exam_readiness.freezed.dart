// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_readiness.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamReadiness {

@JsonKey(name: 'subject_name') String get subjectName; int get readiness;
/// Create a copy of ExamReadiness
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamReadinessCopyWith<ExamReadiness> get copyWith => _$ExamReadinessCopyWithImpl<ExamReadiness>(this as ExamReadiness, _$identity);

  /// Serializes this ExamReadiness to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamReadiness&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.readiness, readiness) || other.readiness == readiness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectName,readiness);

@override
String toString() {
  return 'ExamReadiness(subjectName: $subjectName, readiness: $readiness)';
}


}

/// @nodoc
abstract mixin class $ExamReadinessCopyWith<$Res>  {
  factory $ExamReadinessCopyWith(ExamReadiness value, $Res Function(ExamReadiness) _then) = _$ExamReadinessCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'subject_name') String subjectName, int readiness
});




}
/// @nodoc
class _$ExamReadinessCopyWithImpl<$Res>
    implements $ExamReadinessCopyWith<$Res> {
  _$ExamReadinessCopyWithImpl(this._self, this._then);

  final ExamReadiness _self;
  final $Res Function(ExamReadiness) _then;

/// Create a copy of ExamReadiness
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectName = null,Object? readiness = null,}) {
  return _then(_self.copyWith(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamReadiness].
extension ExamReadinessPatterns on ExamReadiness {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamReadiness value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamReadiness() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamReadiness value)  $default,){
final _that = this;
switch (_that) {
case _ExamReadiness():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamReadiness value)?  $default,){
final _that = this;
switch (_that) {
case _ExamReadiness() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'subject_name')  String subjectName,  int readiness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamReadiness() when $default != null:
return $default(_that.subjectName,_that.readiness);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'subject_name')  String subjectName,  int readiness)  $default,) {final _that = this;
switch (_that) {
case _ExamReadiness():
return $default(_that.subjectName,_that.readiness);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'subject_name')  String subjectName,  int readiness)?  $default,) {final _that = this;
switch (_that) {
case _ExamReadiness() when $default != null:
return $default(_that.subjectName,_that.readiness);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamReadiness implements ExamReadiness {
  const _ExamReadiness({@JsonKey(name: 'subject_name') required this.subjectName, required this.readiness});
  factory _ExamReadiness.fromJson(Map<String, dynamic> json) => _$ExamReadinessFromJson(json);

@override@JsonKey(name: 'subject_name') final  String subjectName;
@override final  int readiness;

/// Create a copy of ExamReadiness
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamReadinessCopyWith<_ExamReadiness> get copyWith => __$ExamReadinessCopyWithImpl<_ExamReadiness>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamReadinessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamReadiness&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.readiness, readiness) || other.readiness == readiness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectName,readiness);

@override
String toString() {
  return 'ExamReadiness(subjectName: $subjectName, readiness: $readiness)';
}


}

/// @nodoc
abstract mixin class _$ExamReadinessCopyWith<$Res> implements $ExamReadinessCopyWith<$Res> {
  factory _$ExamReadinessCopyWith(_ExamReadiness value, $Res Function(_ExamReadiness) _then) = __$ExamReadinessCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'subject_name') String subjectName, int readiness
});




}
/// @nodoc
class __$ExamReadinessCopyWithImpl<$Res>
    implements _$ExamReadinessCopyWith<$Res> {
  __$ExamReadinessCopyWithImpl(this._self, this._then);

  final _ExamReadiness _self;
  final $Res Function(_ExamReadiness) _then;

/// Create a copy of ExamReadiness
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectName = null,Object? readiness = null,}) {
  return _then(_ExamReadiness(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
