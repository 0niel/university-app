// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TopicList {

@JsonKey(name: 'can_create_topic') bool get canCreateTopic;@JsonKey(name: 'for_period') String get forPeriod;@JsonKey(name: 'per_page') int get perPage;@JsonKey(name: 'top_tags') List<Object?> get topTags; List<Topic> get topics;
/// Create a copy of TopicList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicListCopyWith<TopicList> get copyWith => _$TopicListCopyWithImpl<TopicList>(this as TopicList, _$identity);

  /// Serializes this TopicList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicList&&(identical(other.canCreateTopic, canCreateTopic) || other.canCreateTopic == canCreateTopic)&&(identical(other.forPeriod, forPeriod) || other.forPeriod == forPeriod)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other.topTags, topTags)&&const DeepCollectionEquality().equals(other.topics, topics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canCreateTopic,forPeriod,perPage,const DeepCollectionEquality().hash(topTags),const DeepCollectionEquality().hash(topics));

@override
String toString() {
  return 'TopicList(canCreateTopic: $canCreateTopic, forPeriod: $forPeriod, perPage: $perPage, topTags: $topTags, topics: $topics)';
}


}

/// @nodoc
abstract mixin class $TopicListCopyWith<$Res>  {
  factory $TopicListCopyWith(TopicList value, $Res Function(TopicList) _then) = _$TopicListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'can_create_topic') bool canCreateTopic,@JsonKey(name: 'for_period') String forPeriod,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'top_tags') List<Object?> topTags, List<Topic> topics
});




}
/// @nodoc
class _$TopicListCopyWithImpl<$Res>
    implements $TopicListCopyWith<$Res> {
  _$TopicListCopyWithImpl(this._self, this._then);

  final TopicList _self;
  final $Res Function(TopicList) _then;

/// Create a copy of TopicList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canCreateTopic = null,Object? forPeriod = null,Object? perPage = null,Object? topTags = null,Object? topics = null,}) {
  return _then(_self.copyWith(
canCreateTopic: null == canCreateTopic ? _self.canCreateTopic : canCreateTopic // ignore: cast_nullable_to_non_nullable
as bool,forPeriod: null == forPeriod ? _self.forPeriod : forPeriod // ignore: cast_nullable_to_non_nullable
as String,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,topTags: null == topTags ? _self.topTags : topTags // ignore: cast_nullable_to_non_nullable
as List<Object?>,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<Topic>,
  ));
}

}


/// Adds pattern-matching-related methods to [TopicList].
extension TopicListPatterns on TopicList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopicList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopicList value)  $default,){
final _that = this;
switch (_that) {
case _TopicList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopicList value)?  $default,){
final _that = this;
switch (_that) {
case _TopicList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'can_create_topic')  bool canCreateTopic, @JsonKey(name: 'for_period')  String forPeriod, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'top_tags')  List<Object?> topTags,  List<Topic> topics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicList() when $default != null:
return $default(_that.canCreateTopic,_that.forPeriod,_that.perPage,_that.topTags,_that.topics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'can_create_topic')  bool canCreateTopic, @JsonKey(name: 'for_period')  String forPeriod, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'top_tags')  List<Object?> topTags,  List<Topic> topics)  $default,) {final _that = this;
switch (_that) {
case _TopicList():
return $default(_that.canCreateTopic,_that.forPeriod,_that.perPage,_that.topTags,_that.topics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'can_create_topic')  bool canCreateTopic, @JsonKey(name: 'for_period')  String forPeriod, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'top_tags')  List<Object?> topTags,  List<Topic> topics)?  $default,) {final _that = this;
switch (_that) {
case _TopicList() when $default != null:
return $default(_that.canCreateTopic,_that.forPeriod,_that.perPage,_that.topTags,_that.topics);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TopicList implements TopicList {
  const _TopicList({@JsonKey(name: 'can_create_topic') required this.canCreateTopic, @JsonKey(name: 'for_period') required this.forPeriod, @JsonKey(name: 'per_page') required this.perPage, @JsonKey(name: 'top_tags') required final  List<Object?> topTags, required final  List<Topic> topics}): _topTags = topTags,_topics = topics;
  factory _TopicList.fromJson(Map<String, dynamic> json) => _$TopicListFromJson(json);

@override@JsonKey(name: 'can_create_topic') final  bool canCreateTopic;
@override@JsonKey(name: 'for_period') final  String forPeriod;
@override@JsonKey(name: 'per_page') final  int perPage;
 final  List<Object?> _topTags;
@override@JsonKey(name: 'top_tags') List<Object?> get topTags {
  if (_topTags is EqualUnmodifiableListView) return _topTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topTags);
}

 final  List<Topic> _topics;
@override List<Topic> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}


/// Create a copy of TopicList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicListCopyWith<_TopicList> get copyWith => __$TopicListCopyWithImpl<_TopicList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicList&&(identical(other.canCreateTopic, canCreateTopic) || other.canCreateTopic == canCreateTopic)&&(identical(other.forPeriod, forPeriod) || other.forPeriod == forPeriod)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other._topTags, _topTags)&&const DeepCollectionEquality().equals(other._topics, _topics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canCreateTopic,forPeriod,perPage,const DeepCollectionEquality().hash(_topTags),const DeepCollectionEquality().hash(_topics));

@override
String toString() {
  return 'TopicList(canCreateTopic: $canCreateTopic, forPeriod: $forPeriod, perPage: $perPage, topTags: $topTags, topics: $topics)';
}


}

/// @nodoc
abstract mixin class _$TopicListCopyWith<$Res> implements $TopicListCopyWith<$Res> {
  factory _$TopicListCopyWith(_TopicList value, $Res Function(_TopicList) _then) = __$TopicListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'can_create_topic') bool canCreateTopic,@JsonKey(name: 'for_period') String forPeriod,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'top_tags') List<Object?> topTags, List<Topic> topics
});




}
/// @nodoc
class __$TopicListCopyWithImpl<$Res>
    implements _$TopicListCopyWith<$Res> {
  __$TopicListCopyWithImpl(this._self, this._then);

  final _TopicList _self;
  final $Res Function(_TopicList) _then;

/// Create a copy of TopicList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canCreateTopic = null,Object? forPeriod = null,Object? perPage = null,Object? topTags = null,Object? topics = null,}) {
  return _then(_TopicList(
canCreateTopic: null == canCreateTopic ? _self.canCreateTopic : canCreateTopic // ignore: cast_nullable_to_non_nullable
as bool,forPeriod: null == forPeriod ? _self.forPeriod : forPeriod // ignore: cast_nullable_to_non_nullable
as String,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,topTags: null == topTags ? _self._topTags : topTags // ignore: cast_nullable_to_non_nullable
as List<Object?>,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<Topic>,
  ));
}


}

// dart format on
