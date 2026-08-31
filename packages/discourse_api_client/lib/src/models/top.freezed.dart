// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'top.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Top {

 List<User> get users;@JsonKey(name: 'topic_list') TopicList get topicList;
/// Create a copy of Top
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopCopyWith<Top> get copyWith => _$TopCopyWithImpl<Top>(this as Top, _$identity);

  /// Serializes this Top to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Top&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.topicList, topicList) || other.topicList == topicList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users),topicList);

@override
String toString() {
  return 'Top(users: $users, topicList: $topicList)';
}


}

/// @nodoc
abstract mixin class $TopCopyWith<$Res>  {
  factory $TopCopyWith(Top value, $Res Function(Top) _then) = _$TopCopyWithImpl;
@useResult
$Res call({
 List<User> users,@JsonKey(name: 'topic_list') TopicList topicList
});


$TopicListCopyWith<$Res> get topicList;

}
/// @nodoc
class _$TopCopyWithImpl<$Res>
    implements $TopCopyWith<$Res> {
  _$TopCopyWithImpl(this._self, this._then);

  final Top _self;
  final $Res Function(Top) _then;

/// Create a copy of Top
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? topicList = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<User>,topicList: null == topicList ? _self.topicList : topicList // ignore: cast_nullable_to_non_nullable
as TopicList,
  ));
}
/// Create a copy of Top
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TopicListCopyWith<$Res> get topicList {

  return $TopicListCopyWith<$Res>(_self.topicList, (value) {
    return _then(_self.copyWith(topicList: value));
  });
}
}


/// Adds pattern-matching-related methods to [Top].
extension TopPatterns on Top {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Top value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Top() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Top value)  $default,){
final _that = this;
switch (_that) {
case _Top():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Top value)?  $default,){
final _that = this;
switch (_that) {
case _Top() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<User> users, @JsonKey(name: 'topic_list')  TopicList topicList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Top() when $default != null:
return $default(_that.users,_that.topicList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<User> users, @JsonKey(name: 'topic_list')  TopicList topicList)  $default,) {final _that = this;
switch (_that) {
case _Top():
return $default(_that.users,_that.topicList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<User> users, @JsonKey(name: 'topic_list')  TopicList topicList)?  $default,) {final _that = this;
switch (_that) {
case _Top() when $default != null:
return $default(_that.users,_that.topicList);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Top implements Top {
  const _Top({required final  List<User> users, @JsonKey(name: 'topic_list') required this.topicList}): _users = users;
  factory _Top.fromJson(Map<String, dynamic> json) => _$TopFromJson(json);

 final  List<User> _users;
@override List<User> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override@JsonKey(name: 'topic_list') final  TopicList topicList;

/// Create a copy of Top
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopCopyWith<_Top> get copyWith => __$TopCopyWithImpl<_Top>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Top&&const DeepCollectionEquality().equals(other._users, _users)&&(identical(other.topicList, topicList) || other.topicList == topicList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),topicList);

@override
String toString() {
  return 'Top(users: $users, topicList: $topicList)';
}


}

/// @nodoc
abstract mixin class _$TopCopyWith<$Res> implements $TopCopyWith<$Res> {
  factory _$TopCopyWith(_Top value, $Res Function(_Top) _then) = __$TopCopyWithImpl;
@override @useResult
$Res call({
 List<User> users,@JsonKey(name: 'topic_list') TopicList topicList
});


@override $TopicListCopyWith<$Res> get topicList;

}
/// @nodoc
class __$TopCopyWithImpl<$Res>
    implements _$TopCopyWith<$Res> {
  __$TopCopyWithImpl(this._self, this._then);

  final _Top _self;
  final $Res Function(_Top) _then;

/// Create a copy of Top
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? topicList = null,}) {
  return _then(_Top(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<User>,topicList: null == topicList ? _self.topicList : topicList // ignore: cast_nullable_to_non_nullable
as TopicList,
  ));
}

/// Create a copy of Top
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TopicListCopyWith<$Res> get topicList {

  return $TopicListCopyWith<$Res>(_self.topicList, (value) {
    return _then(_self.copyWith(topicList: value));
  });
}
}

// dart format on
