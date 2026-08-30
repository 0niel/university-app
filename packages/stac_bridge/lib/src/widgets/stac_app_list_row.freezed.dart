// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_list_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppListRow {

@JsonKey(fromJson: stringOrEmpty) String get title;@JsonKey(fromJson: stringOrNull) String? get subtitle;@JsonKey(fromJson: stringOrNull) String? get emoji;@JsonKey(fromJson: stringOrNull) String? get emojiColor;@JsonKey(fromJson: boolOrFalse) bool get isFirst;@JsonKey(fromJson: boolOrFalse) bool get dense; Object? get trailing;@JsonKey(name: 'onTap') Object? get actionJson;
/// Create a copy of StacAppListRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppListRowCopyWith<StacAppListRow> get copyWith => _$StacAppListRowCopyWithImpl<StacAppListRow>(this as StacAppListRow, _$identity);

  /// Serializes this StacAppListRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppListRow&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.emojiColor, emojiColor) || other.emojiColor == emojiColor)&&(identical(other.isFirst, isFirst) || other.isFirst == isFirst)&&(identical(other.dense, dense) || other.dense == dense)&&const DeepCollectionEquality().equals(other.trailing, trailing)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,subtitle,emoji,emojiColor,isFirst,dense,const DeepCollectionEquality().hash(trailing),const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppListRow(title: $title, subtitle: $subtitle, emoji: $emoji, emojiColor: $emojiColor, isFirst: $isFirst, dense: $dense, trailing: $trailing, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class $StacAppListRowCopyWith<$Res>  {
  factory $StacAppListRowCopyWith(StacAppListRow value, $Res Function(StacAppListRow) _then) = _$StacAppListRowCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String title,@JsonKey(fromJson: stringOrNull) String? subtitle,@JsonKey(fromJson: stringOrNull) String? emoji,@JsonKey(fromJson: stringOrNull) String? emojiColor,@JsonKey(fromJson: boolOrFalse) bool isFirst,@JsonKey(fromJson: boolOrFalse) bool dense, Object? trailing,@JsonKey(name: 'onTap') Object? actionJson
});




}
/// @nodoc
class _$StacAppListRowCopyWithImpl<$Res>
    implements $StacAppListRowCopyWith<$Res> {
  _$StacAppListRowCopyWithImpl(this._self, this._then);

  final StacAppListRow _self;
  final $Res Function(StacAppListRow) _then;

/// Create a copy of StacAppListRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? subtitle = freezed,Object? emoji = freezed,Object? emojiColor = freezed,Object? isFirst = null,Object? dense = null,Object? trailing = freezed,Object? actionJson = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,emojiColor: freezed == emojiColor ? _self.emojiColor : emojiColor // ignore: cast_nullable_to_non_nullable
as String?,isFirst: null == isFirst ? _self.isFirst : isFirst // ignore: cast_nullable_to_non_nullable
as bool,dense: null == dense ? _self.dense : dense // ignore: cast_nullable_to_non_nullable
as bool,trailing: freezed == trailing ? _self.trailing : trailing ,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppListRow].
extension StacAppListRowPatterns on StacAppListRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppListRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppListRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppListRow value)  $default,){
final _that = this;
switch (_that) {
case _StacAppListRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppListRow value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppListRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String title, @JsonKey(fromJson: stringOrNull)  String? subtitle, @JsonKey(fromJson: stringOrNull)  String? emoji, @JsonKey(fromJson: stringOrNull)  String? emojiColor, @JsonKey(fromJson: boolOrFalse)  bool isFirst, @JsonKey(fromJson: boolOrFalse)  bool dense,  Object? trailing, @JsonKey(name: 'onTap')  Object? actionJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppListRow() when $default != null:
return $default(_that.title,_that.subtitle,_that.emoji,_that.emojiColor,_that.isFirst,_that.dense,_that.trailing,_that.actionJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String title, @JsonKey(fromJson: stringOrNull)  String? subtitle, @JsonKey(fromJson: stringOrNull)  String? emoji, @JsonKey(fromJson: stringOrNull)  String? emojiColor, @JsonKey(fromJson: boolOrFalse)  bool isFirst, @JsonKey(fromJson: boolOrFalse)  bool dense,  Object? trailing, @JsonKey(name: 'onTap')  Object? actionJson)  $default,) {final _that = this;
switch (_that) {
case _StacAppListRow():
return $default(_that.title,_that.subtitle,_that.emoji,_that.emojiColor,_that.isFirst,_that.dense,_that.trailing,_that.actionJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrEmpty)  String title, @JsonKey(fromJson: stringOrNull)  String? subtitle, @JsonKey(fromJson: stringOrNull)  String? emoji, @JsonKey(fromJson: stringOrNull)  String? emojiColor, @JsonKey(fromJson: boolOrFalse)  bool isFirst, @JsonKey(fromJson: boolOrFalse)  bool dense,  Object? trailing, @JsonKey(name: 'onTap')  Object? actionJson)?  $default,) {final _that = this;
switch (_that) {
case _StacAppListRow() when $default != null:
return $default(_that.title,_that.subtitle,_that.emoji,_that.emojiColor,_that.isFirst,_that.dense,_that.trailing,_that.actionJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppListRow implements StacAppListRow {
  const _StacAppListRow({@JsonKey(fromJson: stringOrEmpty) required this.title, @JsonKey(fromJson: stringOrNull) this.subtitle, @JsonKey(fromJson: stringOrNull) this.emoji, @JsonKey(fromJson: stringOrNull) this.emojiColor, @JsonKey(fromJson: boolOrFalse) this.isFirst = false, @JsonKey(fromJson: boolOrFalse) this.dense = false, this.trailing, @JsonKey(name: 'onTap') this.actionJson});
  factory _StacAppListRow.fromJson(Map<String, dynamic> json) => _$StacAppListRowFromJson(json);

@override@JsonKey(fromJson: stringOrEmpty) final  String title;
@override@JsonKey(fromJson: stringOrNull) final  String? subtitle;
@override@JsonKey(fromJson: stringOrNull) final  String? emoji;
@override@JsonKey(fromJson: stringOrNull) final  String? emojiColor;
@override@JsonKey(fromJson: boolOrFalse) final  bool isFirst;
@override@JsonKey(fromJson: boolOrFalse) final  bool dense;
@override final  Object? trailing;
@override@JsonKey(name: 'onTap') final  Object? actionJson;

/// Create a copy of StacAppListRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppListRowCopyWith<_StacAppListRow> get copyWith => __$StacAppListRowCopyWithImpl<_StacAppListRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppListRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppListRow&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.emojiColor, emojiColor) || other.emojiColor == emojiColor)&&(identical(other.isFirst, isFirst) || other.isFirst == isFirst)&&(identical(other.dense, dense) || other.dense == dense)&&const DeepCollectionEquality().equals(other.trailing, trailing)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,subtitle,emoji,emojiColor,isFirst,dense,const DeepCollectionEquality().hash(trailing),const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppListRow(title: $title, subtitle: $subtitle, emoji: $emoji, emojiColor: $emojiColor, isFirst: $isFirst, dense: $dense, trailing: $trailing, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class _$StacAppListRowCopyWith<$Res> implements $StacAppListRowCopyWith<$Res> {
  factory _$StacAppListRowCopyWith(_StacAppListRow value, $Res Function(_StacAppListRow) _then) = __$StacAppListRowCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String title,@JsonKey(fromJson: stringOrNull) String? subtitle,@JsonKey(fromJson: stringOrNull) String? emoji,@JsonKey(fromJson: stringOrNull) String? emojiColor,@JsonKey(fromJson: boolOrFalse) bool isFirst,@JsonKey(fromJson: boolOrFalse) bool dense, Object? trailing,@JsonKey(name: 'onTap') Object? actionJson
});




}
/// @nodoc
class __$StacAppListRowCopyWithImpl<$Res>
    implements _$StacAppListRowCopyWith<$Res> {
  __$StacAppListRowCopyWithImpl(this._self, this._then);

  final _StacAppListRow _self;
  final $Res Function(_StacAppListRow) _then;

/// Create a copy of StacAppListRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? subtitle = freezed,Object? emoji = freezed,Object? emojiColor = freezed,Object? isFirst = null,Object? dense = null,Object? trailing = freezed,Object? actionJson = freezed,}) {
  return _then(_StacAppListRow(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,emojiColor: freezed == emojiColor ? _self.emojiColor : emojiColor // ignore: cast_nullable_to_non_nullable
as String?,isFirst: null == isFirst ? _self.isFirst : isFirst // ignore: cast_nullable_to_non_nullable
as bool,dense: null == dense ? _self.dense : dense // ignore: cast_nullable_to_non_nullable
as bool,trailing: freezed == trailing ? _self.trailing : trailing ,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}


}

// dart format on
