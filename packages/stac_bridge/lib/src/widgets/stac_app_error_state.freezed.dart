// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_error_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppErrorState {

@JsonKey(fromJson: stringOrEmpty) String get title;@JsonKey(fromJson: stringOrEmpty) String get message;@JsonKey(fromJson: _retryWhenNotString) String get primaryLabel;@JsonKey(name: 'onPrimary') Object? get primaryActionJson;
/// Create a copy of StacAppErrorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppErrorStateCopyWith<StacAppErrorState> get copyWith => _$StacAppErrorStateCopyWithImpl<StacAppErrorState>(this as StacAppErrorState, _$identity);

  /// Serializes this StacAppErrorState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppErrorState&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.primaryLabel, primaryLabel) || other.primaryLabel == primaryLabel)&&const DeepCollectionEquality().equals(other.primaryActionJson, primaryActionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message,primaryLabel,const DeepCollectionEquality().hash(primaryActionJson));

@override
String toString() {
  return 'StacAppErrorState(title: $title, message: $message, primaryLabel: $primaryLabel, primaryActionJson: $primaryActionJson)';
}


}

/// @nodoc
abstract mixin class $StacAppErrorStateCopyWith<$Res>  {
  factory $StacAppErrorStateCopyWith(StacAppErrorState value, $Res Function(StacAppErrorState) _then) = _$StacAppErrorStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String title,@JsonKey(fromJson: stringOrEmpty) String message,@JsonKey(fromJson: _retryWhenNotString) String primaryLabel,@JsonKey(name: 'onPrimary') Object? primaryActionJson
});




}
/// @nodoc
class _$StacAppErrorStateCopyWithImpl<$Res>
    implements $StacAppErrorStateCopyWith<$Res> {
  _$StacAppErrorStateCopyWithImpl(this._self, this._then);

  final StacAppErrorState _self;
  final $Res Function(StacAppErrorState) _then;

/// Create a copy of StacAppErrorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? message = null,Object? primaryLabel = null,Object? primaryActionJson = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,primaryLabel: null == primaryLabel ? _self.primaryLabel : primaryLabel // ignore: cast_nullable_to_non_nullable
as String,primaryActionJson: freezed == primaryActionJson ? _self.primaryActionJson : primaryActionJson ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppErrorState].
extension StacAppErrorStatePatterns on StacAppErrorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppErrorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppErrorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppErrorState value)  $default,){
final _that = this;
switch (_that) {
case _StacAppErrorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppErrorState value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppErrorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String title, @JsonKey(fromJson: stringOrEmpty)  String message, @JsonKey(fromJson: _retryWhenNotString)  String primaryLabel, @JsonKey(name: 'onPrimary')  Object? primaryActionJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppErrorState() when $default != null:
return $default(_that.title,_that.message,_that.primaryLabel,_that.primaryActionJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String title, @JsonKey(fromJson: stringOrEmpty)  String message, @JsonKey(fromJson: _retryWhenNotString)  String primaryLabel, @JsonKey(name: 'onPrimary')  Object? primaryActionJson)  $default,) {final _that = this;
switch (_that) {
case _StacAppErrorState():
return $default(_that.title,_that.message,_that.primaryLabel,_that.primaryActionJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrEmpty)  String title, @JsonKey(fromJson: stringOrEmpty)  String message, @JsonKey(fromJson: _retryWhenNotString)  String primaryLabel, @JsonKey(name: 'onPrimary')  Object? primaryActionJson)?  $default,) {final _that = this;
switch (_that) {
case _StacAppErrorState() when $default != null:
return $default(_that.title,_that.message,_that.primaryLabel,_that.primaryActionJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppErrorState implements StacAppErrorState {
  const _StacAppErrorState({@JsonKey(fromJson: stringOrEmpty) required this.title, @JsonKey(fromJson: stringOrEmpty) required this.message, @JsonKey(fromJson: _retryWhenNotString) this.primaryLabel = 'Повторить', @JsonKey(name: 'onPrimary') this.primaryActionJson});
  factory _StacAppErrorState.fromJson(Map<String, dynamic> json) => _$StacAppErrorStateFromJson(json);

@override@JsonKey(fromJson: stringOrEmpty) final  String title;
@override@JsonKey(fromJson: stringOrEmpty) final  String message;
@override@JsonKey(fromJson: _retryWhenNotString) final  String primaryLabel;
@override@JsonKey(name: 'onPrimary') final  Object? primaryActionJson;

/// Create a copy of StacAppErrorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppErrorStateCopyWith<_StacAppErrorState> get copyWith => __$StacAppErrorStateCopyWithImpl<_StacAppErrorState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppErrorStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppErrorState&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.primaryLabel, primaryLabel) || other.primaryLabel == primaryLabel)&&const DeepCollectionEquality().equals(other.primaryActionJson, primaryActionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message,primaryLabel,const DeepCollectionEquality().hash(primaryActionJson));

@override
String toString() {
  return 'StacAppErrorState(title: $title, message: $message, primaryLabel: $primaryLabel, primaryActionJson: $primaryActionJson)';
}


}

/// @nodoc
abstract mixin class _$StacAppErrorStateCopyWith<$Res> implements $StacAppErrorStateCopyWith<$Res> {
  factory _$StacAppErrorStateCopyWith(_StacAppErrorState value, $Res Function(_StacAppErrorState) _then) = __$StacAppErrorStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String title,@JsonKey(fromJson: stringOrEmpty) String message,@JsonKey(fromJson: _retryWhenNotString) String primaryLabel,@JsonKey(name: 'onPrimary') Object? primaryActionJson
});




}
/// @nodoc
class __$StacAppErrorStateCopyWithImpl<$Res>
    implements _$StacAppErrorStateCopyWith<$Res> {
  __$StacAppErrorStateCopyWithImpl(this._self, this._then);

  final _StacAppErrorState _self;
  final $Res Function(_StacAppErrorState) _then;

/// Create a copy of StacAppErrorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? message = null,Object? primaryLabel = null,Object? primaryActionJson = freezed,}) {
  return _then(_StacAppErrorState(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,primaryLabel: null == primaryLabel ? _self.primaryLabel : primaryLabel // ignore: cast_nullable_to_non_nullable
as String,primaryActionJson: freezed == primaryActionJson ? _self.primaryActionJson : primaryActionJson ,
  ));
}


}

// dart format on
