// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_app_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MiniAppReport {

@JsonKey(includeToJson: false) String? get id;@JsonKey(unknownEnumValue: MiniAppReportReason.other) MiniAppReportReason get reason; String get details;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get createdAt;
/// Create a copy of MiniAppReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppReportCopyWith<MiniAppReport> get copyWith => _$MiniAppReportCopyWithImpl<MiniAppReport>(this as MiniAppReport, _$identity);

  /// Serializes this MiniAppReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppReport&&(identical(other.id, id) || other.id == id)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.details, details) || other.details == details)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reason,details,createdAt);

@override
String toString() {
  return 'MiniAppReport(id: $id, reason: $reason, details: $details, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MiniAppReportCopyWith<$Res>  {
  factory $MiniAppReportCopyWith(MiniAppReport value, $Res Function(MiniAppReport) _then) = _$MiniAppReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String? id,@JsonKey(unknownEnumValue: MiniAppReportReason.other) MiniAppReportReason reason, String details,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt
});




}
/// @nodoc
class _$MiniAppReportCopyWithImpl<$Res>
    implements $MiniAppReportCopyWith<$Res> {
  _$MiniAppReportCopyWithImpl(this._self, this._then);

  final MiniAppReport _self;
  final $Res Function(MiniAppReport) _then;

/// Create a copy of MiniAppReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? reason = null,Object? details = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as MiniAppReportReason,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppReport].
extension MiniAppReportPatterns on MiniAppReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppReport value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppReport value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? id, @JsonKey(unknownEnumValue: MiniAppReportReason.other)  MiniAppReportReason reason,  String details, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppReport() when $default != null:
return $default(_that.id,_that.reason,_that.details,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? id, @JsonKey(unknownEnumValue: MiniAppReportReason.other)  MiniAppReportReason reason,  String details, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MiniAppReport():
return $default(_that.id,_that.reason,_that.details,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String? id, @JsonKey(unknownEnumValue: MiniAppReportReason.other)  MiniAppReportReason reason,  String details, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppReport() when $default != null:
return $default(_that.id,_that.reason,_that.details,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiniAppReport implements MiniAppReport {
  const _MiniAppReport({@JsonKey(includeToJson: false) this.id, @JsonKey(unknownEnumValue: MiniAppReportReason.other) this.reason = MiniAppReportReason.other, this.details = '', @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.createdAt});
  factory _MiniAppReport.fromJson(Map<String, dynamic> json) => _$MiniAppReportFromJson(json);

@override@JsonKey(includeToJson: false) final  String? id;
@override@JsonKey(unknownEnumValue: MiniAppReportReason.other) final  MiniAppReportReason reason;
@override@JsonKey() final  String details;
@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? createdAt;

/// Create a copy of MiniAppReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppReportCopyWith<_MiniAppReport> get copyWith => __$MiniAppReportCopyWithImpl<_MiniAppReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiniAppReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppReport&&(identical(other.id, id) || other.id == id)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.details, details) || other.details == details)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reason,details,createdAt);

@override
String toString() {
  return 'MiniAppReport(id: $id, reason: $reason, details: $details, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MiniAppReportCopyWith<$Res> implements $MiniAppReportCopyWith<$Res> {
  factory _$MiniAppReportCopyWith(_MiniAppReport value, $Res Function(_MiniAppReport) _then) = __$MiniAppReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String? id,@JsonKey(unknownEnumValue: MiniAppReportReason.other) MiniAppReportReason reason, String details,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt
});




}
/// @nodoc
class __$MiniAppReportCopyWithImpl<$Res>
    implements _$MiniAppReportCopyWith<$Res> {
  __$MiniAppReportCopyWithImpl(this._self, this._then);

  final _MiniAppReport _self;
  final $Res Function(_MiniAppReport) _then;

/// Create a copy of MiniAppReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? reason = null,Object? details = null,Object? createdAt = freezed,}) {
  return _then(_MiniAppReport(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as MiniAppReportReason,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
