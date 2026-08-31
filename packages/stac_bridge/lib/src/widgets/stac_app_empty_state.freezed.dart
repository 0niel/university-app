// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_empty_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppEmptyState {

@JsonKey(fromJson: _sparklesWhenNotString) String get emoji;@JsonKey(fromJson: stringOrEmpty) String get title; String? get subtitle; Object? get child;
/// Create a copy of StacAppEmptyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppEmptyStateCopyWith<StacAppEmptyState> get copyWith => _$StacAppEmptyStateCopyWithImpl<StacAppEmptyState>(this as StacAppEmptyState, _$identity);

  /// Serializes this StacAppEmptyState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppEmptyState&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.child, child));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,title,subtitle,const DeepCollectionEquality().hash(child));

@override
String toString() {
  return 'StacAppEmptyState(emoji: $emoji, title: $title, subtitle: $subtitle, child: $child)';
}


}

/// @nodoc
abstract mixin class $StacAppEmptyStateCopyWith<$Res>  {
  factory $StacAppEmptyStateCopyWith(StacAppEmptyState value, $Res Function(StacAppEmptyState) _then) = _$StacAppEmptyStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _sparklesWhenNotString) String emoji,@JsonKey(fromJson: stringOrEmpty) String title, String? subtitle, Object? child
});




}
/// @nodoc
class _$StacAppEmptyStateCopyWithImpl<$Res>
    implements $StacAppEmptyStateCopyWith<$Res> {
  _$StacAppEmptyStateCopyWithImpl(this._self, this._then);

  final StacAppEmptyState _self;
  final $Res Function(StacAppEmptyState) _then;

/// Create a copy of StacAppEmptyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = null,Object? title = null,Object? subtitle = freezed,Object? child = freezed,}) {
  return _then(_self.copyWith(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,child: freezed == child ? _self.child : child ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppEmptyState].
extension StacAppEmptyStatePatterns on StacAppEmptyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppEmptyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppEmptyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppEmptyState value)  $default,){
final _that = this;
switch (_that) {
case _StacAppEmptyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppEmptyState value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppEmptyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _sparklesWhenNotString)  String emoji, @JsonKey(fromJson: stringOrEmpty)  String title,  String? subtitle,  Object? child)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppEmptyState() when $default != null:
return $default(_that.emoji,_that.title,_that.subtitle,_that.child);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _sparklesWhenNotString)  String emoji, @JsonKey(fromJson: stringOrEmpty)  String title,  String? subtitle,  Object? child)  $default,) {final _that = this;
switch (_that) {
case _StacAppEmptyState():
return $default(_that.emoji,_that.title,_that.subtitle,_that.child);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _sparklesWhenNotString)  String emoji, @JsonKey(fromJson: stringOrEmpty)  String title,  String? subtitle,  Object? child)?  $default,) {final _that = this;
switch (_that) {
case _StacAppEmptyState() when $default != null:
return $default(_that.emoji,_that.title,_that.subtitle,_that.child);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppEmptyState implements StacAppEmptyState {
  const _StacAppEmptyState({@JsonKey(fromJson: _sparklesWhenNotString) required this.emoji, @JsonKey(fromJson: stringOrEmpty) required this.title, this.subtitle, this.child});
  factory _StacAppEmptyState.fromJson(Map<String, dynamic> json) => _$StacAppEmptyStateFromJson(json);

@override@JsonKey(fromJson: _sparklesWhenNotString) final  String emoji;
@override@JsonKey(fromJson: stringOrEmpty) final  String title;
@override final  String? subtitle;
@override final  Object? child;

/// Create a copy of StacAppEmptyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppEmptyStateCopyWith<_StacAppEmptyState> get copyWith => __$StacAppEmptyStateCopyWithImpl<_StacAppEmptyState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppEmptyStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppEmptyState&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.child, child));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,title,subtitle,const DeepCollectionEquality().hash(child));

@override
String toString() {
  return 'StacAppEmptyState(emoji: $emoji, title: $title, subtitle: $subtitle, child: $child)';
}


}

/// @nodoc
abstract mixin class _$StacAppEmptyStateCopyWith<$Res> implements $StacAppEmptyStateCopyWith<$Res> {
  factory _$StacAppEmptyStateCopyWith(_StacAppEmptyState value, $Res Function(_StacAppEmptyState) _then) = __$StacAppEmptyStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _sparklesWhenNotString) String emoji,@JsonKey(fromJson: stringOrEmpty) String title, String? subtitle, Object? child
});




}
/// @nodoc
class __$StacAppEmptyStateCopyWithImpl<$Res>
    implements _$StacAppEmptyStateCopyWith<$Res> {
  __$StacAppEmptyStateCopyWithImpl(this._self, this._then);

  final _StacAppEmptyState _self;
  final $Res Function(_StacAppEmptyState) _then;

/// Create a copy of StacAppEmptyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = null,Object? title = null,Object? subtitle = freezed,Object? child = freezed,}) {
  return _then(_StacAppEmptyState(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,child: freezed == child ? _self.child : child ,
  ));
}


}

// dart format on
