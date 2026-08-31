// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyGroup {

 String get id; String get name; String get emoji; String get description; String get joinCode; bool get isDiscoverable; int get memberCount;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? get createdAt;
/// Create a copy of StudyGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyGroupCopyWith<StudyGroup> get copyWith => _$StudyGroupCopyWithImpl<StudyGroup>(this as StudyGroup, _$identity);

  /// Serializes this StudyGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.description, description) || other.description == description)&&(identical(other.joinCode, joinCode) || other.joinCode == joinCode)&&(identical(other.isDiscoverable, isDiscoverable) || other.isDiscoverable == isDiscoverable)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,emoji,description,joinCode,isDiscoverable,memberCount,createdAt);

@override
String toString() {
  return 'StudyGroup(id: $id, name: $name, emoji: $emoji, description: $description, joinCode: $joinCode, isDiscoverable: $isDiscoverable, memberCount: $memberCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudyGroupCopyWith<$Res>  {
  factory $StudyGroupCopyWith(StudyGroup value, $Res Function(StudyGroup) _then) = _$StudyGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, String emoji, String description, String joinCode, bool isDiscoverable, int memberCount,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? createdAt
});




}
/// @nodoc
class _$StudyGroupCopyWithImpl<$Res>
    implements $StudyGroupCopyWith<$Res> {
  _$StudyGroupCopyWithImpl(this._self, this._then);

  final StudyGroup _self;
  final $Res Function(StudyGroup) _then;

/// Create a copy of StudyGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? emoji = null,Object? description = null,Object? joinCode = null,Object? isDiscoverable = null,Object? memberCount = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,joinCode: null == joinCode ? _self.joinCode : joinCode // ignore: cast_nullable_to_non_nullable
as String,isDiscoverable: null == isDiscoverable ? _self.isDiscoverable : isDiscoverable // ignore: cast_nullable_to_non_nullable
as bool,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyGroup].
extension StudyGroupPatterns on StudyGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyGroup value)  $default,){
final _that = this;
switch (_that) {
case _StudyGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyGroup value)?  $default,){
final _that = this;
switch (_that) {
case _StudyGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String emoji,  String description,  String joinCode,  bool isDiscoverable,  int memberCount, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyGroup() when $default != null:
return $default(_that.id,_that.name,_that.emoji,_that.description,_that.joinCode,_that.isDiscoverable,_that.memberCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String emoji,  String description,  String joinCode,  bool isDiscoverable,  int memberCount, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _StudyGroup():
return $default(_that.id,_that.name,_that.emoji,_that.description,_that.joinCode,_that.isDiscoverable,_that.memberCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String emoji,  String description,  String joinCode,  bool isDiscoverable,  int memberCount, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StudyGroup() when $default != null:
return $default(_that.id,_that.name,_that.emoji,_that.description,_that.joinCode,_that.isDiscoverable,_that.memberCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyGroup implements StudyGroup {
  const _StudyGroup({required this.id, required this.name, this.emoji = '🎓', this.description = '', this.joinCode = '', this.isDiscoverable = true, this.memberCount = 0, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) this.createdAt});
  factory _StudyGroup.fromJson(Map<String, dynamic> json) => _$StudyGroupFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String emoji;
@override@JsonKey() final  String description;
@override@JsonKey() final  String joinCode;
@override@JsonKey() final  bool isDiscoverable;
@override@JsonKey() final  int memberCount;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime? createdAt;

/// Create a copy of StudyGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyGroupCopyWith<_StudyGroup> get copyWith => __$StudyGroupCopyWithImpl<_StudyGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.description, description) || other.description == description)&&(identical(other.joinCode, joinCode) || other.joinCode == joinCode)&&(identical(other.isDiscoverable, isDiscoverable) || other.isDiscoverable == isDiscoverable)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,emoji,description,joinCode,isDiscoverable,memberCount,createdAt);

@override
String toString() {
  return 'StudyGroup(id: $id, name: $name, emoji: $emoji, description: $description, joinCode: $joinCode, isDiscoverable: $isDiscoverable, memberCount: $memberCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudyGroupCopyWith<$Res> implements $StudyGroupCopyWith<$Res> {
  factory _$StudyGroupCopyWith(_StudyGroup value, $Res Function(_StudyGroup) _then) = __$StudyGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String emoji, String description, String joinCode, bool isDiscoverable, int memberCount,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? createdAt
});




}
/// @nodoc
class __$StudyGroupCopyWithImpl<$Res>
    implements _$StudyGroupCopyWith<$Res> {
  __$StudyGroupCopyWithImpl(this._self, this._then);

  final _StudyGroup _self;
  final $Res Function(_StudyGroup) _then;

/// Create a copy of StudyGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? emoji = null,Object? description = null,Object? joinCode = null,Object? isDiscoverable = null,Object? memberCount = null,Object? createdAt = freezed,}) {
  return _then(_StudyGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,joinCode: null == joinCode ? _self.joinCode : joinCode // ignore: cast_nullable_to_non_nullable
as String,isDiscoverable: null == isDiscoverable ? _self.isDiscoverable : isDiscoverable // ignore: cast_nullable_to_non_nullable
as bool,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
