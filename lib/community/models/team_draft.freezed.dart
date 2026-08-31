// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeamDraft {

 String get title; String get description; List<String> get neededRoles; int get capacity; String get kind; DateTime? get deadlineAt; bool get boost;
/// Create a copy of TeamDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamDraftCopyWith<TeamDraft> get copyWith => _$TeamDraftCopyWithImpl<TeamDraft>(this as TeamDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.neededRoles, neededRoles)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.boost, boost) || other.boost == boost));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,const DeepCollectionEquality().hash(neededRoles),capacity,kind,deadlineAt,boost);

@override
String toString() {
  return 'TeamDraft(title: $title, description: $description, neededRoles: $neededRoles, capacity: $capacity, kind: $kind, deadlineAt: $deadlineAt, boost: $boost)';
}


}

/// @nodoc
abstract mixin class $TeamDraftCopyWith<$Res>  {
  factory $TeamDraftCopyWith(TeamDraft value, $Res Function(TeamDraft) _then) = _$TeamDraftCopyWithImpl;
@useResult
$Res call({
 String title, String description, List<String> neededRoles, int capacity, String kind, DateTime? deadlineAt, bool boost
});




}
/// @nodoc
class _$TeamDraftCopyWithImpl<$Res>
    implements $TeamDraftCopyWith<$Res> {
  _$TeamDraftCopyWithImpl(this._self, this._then);

  final TeamDraft _self;
  final $Res Function(TeamDraft) _then;

/// Create a copy of TeamDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? neededRoles = null,Object? capacity = null,Object? kind = null,Object? deadlineAt = freezed,Object? boost = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,neededRoles: null == neededRoles ? _self.neededRoles : neededRoles // ignore: cast_nullable_to_non_nullable
as List<String>,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,boost: null == boost ? _self.boost : boost // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamDraft].
extension TeamDraftPatterns on TeamDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamDraft value)  $default,){
final _that = this;
switch (_that) {
case _TeamDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TeamDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  List<String> neededRoles,  int capacity,  String kind,  DateTime? deadlineAt,  bool boost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamDraft() when $default != null:
return $default(_that.title,_that.description,_that.neededRoles,_that.capacity,_that.kind,_that.deadlineAt,_that.boost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  List<String> neededRoles,  int capacity,  String kind,  DateTime? deadlineAt,  bool boost)  $default,) {final _that = this;
switch (_that) {
case _TeamDraft():
return $default(_that.title,_that.description,_that.neededRoles,_that.capacity,_that.kind,_that.deadlineAt,_that.boost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  List<String> neededRoles,  int capacity,  String kind,  DateTime? deadlineAt,  bool boost)?  $default,) {final _that = this;
switch (_that) {
case _TeamDraft() when $default != null:
return $default(_that.title,_that.description,_that.neededRoles,_that.capacity,_that.kind,_that.deadlineAt,_that.boost);case _:
  return null;

}
}

}

/// @nodoc


class _TeamDraft implements TeamDraft {
  const _TeamDraft({this.title = '', this.description = '', final  List<String> neededRoles = const <String>[], this.capacity = 5, this.kind = 'hackathon', this.deadlineAt, this.boost = false}): _neededRoles = neededRoles;


@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
 final  List<String> _neededRoles;
@override@JsonKey() List<String> get neededRoles {
  if (_neededRoles is EqualUnmodifiableListView) return _neededRoles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_neededRoles);
}

@override@JsonKey() final  int capacity;
@override@JsonKey() final  String kind;
@override final  DateTime? deadlineAt;
@override@JsonKey() final  bool boost;

/// Create a copy of TeamDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamDraftCopyWith<_TeamDraft> get copyWith => __$TeamDraftCopyWithImpl<_TeamDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._neededRoles, _neededRoles)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.boost, boost) || other.boost == boost));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,const DeepCollectionEquality().hash(_neededRoles),capacity,kind,deadlineAt,boost);

@override
String toString() {
  return 'TeamDraft(title: $title, description: $description, neededRoles: $neededRoles, capacity: $capacity, kind: $kind, deadlineAt: $deadlineAt, boost: $boost)';
}


}

/// @nodoc
abstract mixin class _$TeamDraftCopyWith<$Res> implements $TeamDraftCopyWith<$Res> {
  factory _$TeamDraftCopyWith(_TeamDraft value, $Res Function(_TeamDraft) _then) = __$TeamDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, List<String> neededRoles, int capacity, String kind, DateTime? deadlineAt, bool boost
});




}
/// @nodoc
class __$TeamDraftCopyWithImpl<$Res>
    implements _$TeamDraftCopyWith<$Res> {
  __$TeamDraftCopyWithImpl(this._self, this._then);

  final _TeamDraft _self;
  final $Res Function(_TeamDraft) _then;

/// Create a copy of TeamDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? neededRoles = null,Object? capacity = null,Object? kind = null,Object? deadlineAt = freezed,Object? boost = null,}) {
  return _then(_TeamDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,neededRoles: null == neededRoles ? _self._neededRoles : neededRoles // ignore: cast_nullable_to_non_nullable
as List<String>,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,boost: null == boost ? _self.boost : boost // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
