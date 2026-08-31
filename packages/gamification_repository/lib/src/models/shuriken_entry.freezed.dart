// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shuriken_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShurikenEntry {

 String get title; int get amount; String get emoji;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt;
/// Create a copy of ShurikenEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShurikenEntryCopyWith<ShurikenEntry> get copyWith => _$ShurikenEntryCopyWithImpl<ShurikenEntry>(this as ShurikenEntry, _$identity);

  /// Serializes this ShurikenEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShurikenEntry&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,amount,emoji,createdAt);

@override
String toString() {
  return 'ShurikenEntry(title: $title, amount: $amount, emoji: $emoji, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ShurikenEntryCopyWith<$Res>  {
  factory $ShurikenEntryCopyWith(ShurikenEntry value, $Res Function(ShurikenEntry) _then) = _$ShurikenEntryCopyWithImpl;
@useResult
$Res call({
 String title, int amount, String emoji,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class _$ShurikenEntryCopyWithImpl<$Res>
    implements $ShurikenEntryCopyWith<$Res> {
  _$ShurikenEntryCopyWithImpl(this._self, this._then);

  final ShurikenEntry _self;
  final $Res Function(ShurikenEntry) _then;

/// Create a copy of ShurikenEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? amount = null,Object? emoji = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShurikenEntry].
extension ShurikenEntryPatterns on ShurikenEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShurikenEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShurikenEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShurikenEntry value)  $default,){
final _that = this;
switch (_that) {
case _ShurikenEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShurikenEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ShurikenEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int amount,  String emoji, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShurikenEntry() when $default != null:
return $default(_that.title,_that.amount,_that.emoji,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int amount,  String emoji, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ShurikenEntry():
return $default(_that.title,_that.amount,_that.emoji,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int amount,  String emoji, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ShurikenEntry() when $default != null:
return $default(_that.title,_that.amount,_that.emoji,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShurikenEntry extends ShurikenEntry {
  const _ShurikenEntry({this.title = '', this.amount = 0, this.emoji = '✨', @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt}): super._();
  factory _ShurikenEntry.fromJson(Map<String, dynamic> json) => _$ShurikenEntryFromJson(json);

@override@JsonKey() final  String title;
@override@JsonKey() final  int amount;
@override@JsonKey() final  String emoji;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;

/// Create a copy of ShurikenEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShurikenEntryCopyWith<_ShurikenEntry> get copyWith => __$ShurikenEntryCopyWithImpl<_ShurikenEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShurikenEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShurikenEntry&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,amount,emoji,createdAt);

@override
String toString() {
  return 'ShurikenEntry(title: $title, amount: $amount, emoji: $emoji, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ShurikenEntryCopyWith<$Res> implements $ShurikenEntryCopyWith<$Res> {
  factory _$ShurikenEntryCopyWith(_ShurikenEntry value, $Res Function(_ShurikenEntry) _then) = __$ShurikenEntryCopyWithImpl;
@override @useResult
$Res call({
 String title, int amount, String emoji,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class __$ShurikenEntryCopyWithImpl<$Res>
    implements _$ShurikenEntryCopyWith<$Res> {
  __$ShurikenEntryCopyWithImpl(this._self, this._then);

  final _ShurikenEntry _self;
  final $Res Function(_ShurikenEntry) _then;

/// Create a copy of ShurikenEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? amount = null,Object? emoji = null,Object? createdAt = freezed,}) {
  return _then(_ShurikenEntry(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
