// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_target_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleTargetRow {

 String get externalId; String get targetTitle; String get fullTitle;
/// Create a copy of ScheduleTargetRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleTargetRowCopyWith<ScheduleTargetRow> get copyWith => _$ScheduleTargetRowCopyWithImpl<ScheduleTargetRow>(this as ScheduleTargetRow, _$identity);

  /// Serializes this ScheduleTargetRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleTargetRow&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.targetTitle, targetTitle) || other.targetTitle == targetTitle)&&(identical(other.fullTitle, fullTitle) || other.fullTitle == fullTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,externalId,targetTitle,fullTitle);

@override
String toString() {
  return 'ScheduleTargetRow(externalId: $externalId, targetTitle: $targetTitle, fullTitle: $fullTitle)';
}


}

/// @nodoc
abstract mixin class $ScheduleTargetRowCopyWith<$Res>  {
  factory $ScheduleTargetRowCopyWith(ScheduleTargetRow value, $Res Function(ScheduleTargetRow) _then) = _$ScheduleTargetRowCopyWithImpl;
@useResult
$Res call({
 String externalId, String targetTitle, String fullTitle
});




}
/// @nodoc
class _$ScheduleTargetRowCopyWithImpl<$Res>
    implements $ScheduleTargetRowCopyWith<$Res> {
  _$ScheduleTargetRowCopyWithImpl(this._self, this._then);

  final ScheduleTargetRow _self;
  final $Res Function(ScheduleTargetRow) _then;

/// Create a copy of ScheduleTargetRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? externalId = null,Object? targetTitle = null,Object? fullTitle = null,}) {
  return _then(_self.copyWith(
externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,targetTitle: null == targetTitle ? _self.targetTitle : targetTitle // ignore: cast_nullable_to_non_nullable
as String,fullTitle: null == fullTitle ? _self.fullTitle : fullTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleTargetRow].
extension ScheduleTargetRowPatterns on ScheduleTargetRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleTargetRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleTargetRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleTargetRow value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleTargetRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleTargetRow value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleTargetRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String externalId,  String targetTitle,  String fullTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleTargetRow() when $default != null:
return $default(_that.externalId,_that.targetTitle,_that.fullTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String externalId,  String targetTitle,  String fullTitle)  $default,) {final _that = this;
switch (_that) {
case _ScheduleTargetRow():
return $default(_that.externalId,_that.targetTitle,_that.fullTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String externalId,  String targetTitle,  String fullTitle)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleTargetRow() when $default != null:
return $default(_that.externalId,_that.targetTitle,_that.fullTitle);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ScheduleTargetRow extends ScheduleTargetRow {
  const _ScheduleTargetRow({required this.externalId, required this.targetTitle, required this.fullTitle}): super._();
  factory _ScheduleTargetRow.fromJson(Map<String, dynamic> json) => _$ScheduleTargetRowFromJson(json);

@override final  String externalId;
@override final  String targetTitle;
@override final  String fullTitle;

/// Create a copy of ScheduleTargetRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleTargetRowCopyWith<_ScheduleTargetRow> get copyWith => __$ScheduleTargetRowCopyWithImpl<_ScheduleTargetRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleTargetRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleTargetRow&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.targetTitle, targetTitle) || other.targetTitle == targetTitle)&&(identical(other.fullTitle, fullTitle) || other.fullTitle == fullTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,externalId,targetTitle,fullTitle);

@override
String toString() {
  return 'ScheduleTargetRow(externalId: $externalId, targetTitle: $targetTitle, fullTitle: $fullTitle)';
}


}

/// @nodoc
abstract mixin class _$ScheduleTargetRowCopyWith<$Res> implements $ScheduleTargetRowCopyWith<$Res> {
  factory _$ScheduleTargetRowCopyWith(_ScheduleTargetRow value, $Res Function(_ScheduleTargetRow) _then) = __$ScheduleTargetRowCopyWithImpl;
@override @useResult
$Res call({
 String externalId, String targetTitle, String fullTitle
});




}
/// @nodoc
class __$ScheduleTargetRowCopyWithImpl<$Res>
    implements _$ScheduleTargetRowCopyWith<$Res> {
  __$ScheduleTargetRowCopyWithImpl(this._self, this._then);

  final _ScheduleTargetRow _self;
  final $Res Function(_ScheduleTargetRow) _then;

/// Create a copy of ScheduleTargetRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? externalId = null,Object? targetTitle = null,Object? fullTitle = null,}) {
  return _then(_ScheduleTargetRow(
externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,targetTitle: null == targetTitle ? _self.targetTitle : targetTitle // ignore: cast_nullable_to_non_nullable
as String,fullTitle: null == fullTitle ? _self.fullTitle : fullTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
