// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_group_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyGroupSummary {

 String get id; String get name; String get emoji; String get description; int get memberCount; String get ownerName; bool get hasRequested;
/// Create a copy of StudyGroupSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyGroupSummaryCopyWith<StudyGroupSummary> get copyWith => _$StudyGroupSummaryCopyWithImpl<StudyGroupSummary>(this as StudyGroupSummary, _$identity);

  /// Serializes this StudyGroupSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyGroupSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.description, description) || other.description == description)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.hasRequested, hasRequested) || other.hasRequested == hasRequested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,emoji,description,memberCount,ownerName,hasRequested);

@override
String toString() {
  return 'StudyGroupSummary(id: $id, name: $name, emoji: $emoji, description: $description, memberCount: $memberCount, ownerName: $ownerName, hasRequested: $hasRequested)';
}


}

/// @nodoc
abstract mixin class $StudyGroupSummaryCopyWith<$Res>  {
  factory $StudyGroupSummaryCopyWith(StudyGroupSummary value, $Res Function(StudyGroupSummary) _then) = _$StudyGroupSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String emoji, String description, int memberCount, String ownerName, bool hasRequested
});




}
/// @nodoc
class _$StudyGroupSummaryCopyWithImpl<$Res>
    implements $StudyGroupSummaryCopyWith<$Res> {
  _$StudyGroupSummaryCopyWithImpl(this._self, this._then);

  final StudyGroupSummary _self;
  final $Res Function(StudyGroupSummary) _then;

/// Create a copy of StudyGroupSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? emoji = null,Object? description = null,Object? memberCount = null,Object? ownerName = null,Object? hasRequested = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,hasRequested: null == hasRequested ? _self.hasRequested : hasRequested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyGroupSummary].
extension StudyGroupSummaryPatterns on StudyGroupSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyGroupSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyGroupSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyGroupSummary value)  $default,){
final _that = this;
switch (_that) {
case _StudyGroupSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyGroupSummary value)?  $default,){
final _that = this;
switch (_that) {
case _StudyGroupSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String emoji,  String description,  int memberCount,  String ownerName,  bool hasRequested)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyGroupSummary() when $default != null:
return $default(_that.id,_that.name,_that.emoji,_that.description,_that.memberCount,_that.ownerName,_that.hasRequested);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String emoji,  String description,  int memberCount,  String ownerName,  bool hasRequested)  $default,) {final _that = this;
switch (_that) {
case _StudyGroupSummary():
return $default(_that.id,_that.name,_that.emoji,_that.description,_that.memberCount,_that.ownerName,_that.hasRequested);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String emoji,  String description,  int memberCount,  String ownerName,  bool hasRequested)?  $default,) {final _that = this;
switch (_that) {
case _StudyGroupSummary() when $default != null:
return $default(_that.id,_that.name,_that.emoji,_that.description,_that.memberCount,_that.ownerName,_that.hasRequested);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyGroupSummary implements StudyGroupSummary {
  const _StudyGroupSummary({required this.id, required this.name, this.emoji = '🎓', this.description = '', this.memberCount = 0, this.ownerName = '', this.hasRequested = false});
  factory _StudyGroupSummary.fromJson(Map<String, dynamic> json) => _$StudyGroupSummaryFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String emoji;
@override@JsonKey() final  String description;
@override@JsonKey() final  int memberCount;
@override@JsonKey() final  String ownerName;
@override@JsonKey() final  bool hasRequested;

/// Create a copy of StudyGroupSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyGroupSummaryCopyWith<_StudyGroupSummary> get copyWith => __$StudyGroupSummaryCopyWithImpl<_StudyGroupSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyGroupSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyGroupSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.description, description) || other.description == description)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.hasRequested, hasRequested) || other.hasRequested == hasRequested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,emoji,description,memberCount,ownerName,hasRequested);

@override
String toString() {
  return 'StudyGroupSummary(id: $id, name: $name, emoji: $emoji, description: $description, memberCount: $memberCount, ownerName: $ownerName, hasRequested: $hasRequested)';
}


}

/// @nodoc
abstract mixin class _$StudyGroupSummaryCopyWith<$Res> implements $StudyGroupSummaryCopyWith<$Res> {
  factory _$StudyGroupSummaryCopyWith(_StudyGroupSummary value, $Res Function(_StudyGroupSummary) _then) = __$StudyGroupSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String emoji, String description, int memberCount, String ownerName, bool hasRequested
});




}
/// @nodoc
class __$StudyGroupSummaryCopyWithImpl<$Res>
    implements _$StudyGroupSummaryCopyWith<$Res> {
  __$StudyGroupSummaryCopyWithImpl(this._self, this._then);

  final _StudyGroupSummary _self;
  final $Res Function(_StudyGroupSummary) _then;

/// Create a copy of StudyGroupSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? emoji = null,Object? description = null,Object? memberCount = null,Object? ownerName = null,Object? hasRequested = null,}) {
  return _then(_StudyGroupSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,hasRequested: null == hasRequested ? _self.hasRequested : hasRequested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
