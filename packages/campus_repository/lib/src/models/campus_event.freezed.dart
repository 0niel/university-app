// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campus_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CampusEvent {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get title;@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime get startsAt; String get description; String get emoji; String get category; String get place; int get goingCount; bool get isGoing; bool get isMine;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get goingNames;
/// Create a copy of CampusEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampusEventCopyWith<CampusEvent> get copyWith => _$CampusEventCopyWithImpl<CampusEvent>(this as CampusEvent, _$identity);

  /// Serializes this CampusEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampusEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.category, category) || other.category == category)&&(identical(other.place, place) || other.place == place)&&(identical(other.goingCount, goingCount) || other.goingCount == goingCount)&&(identical(other.isGoing, isGoing) || other.isGoing == isGoing)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&const DeepCollectionEquality().equals(other.goingNames, goingNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,startsAt,description,emoji,category,place,goingCount,isGoing,isMine,const DeepCollectionEquality().hash(goingNames));

@override
String toString() {
  return 'CampusEvent(id: $id, title: $title, startsAt: $startsAt, description: $description, emoji: $emoji, category: $category, place: $place, goingCount: $goingCount, isGoing: $isGoing, isMine: $isMine, goingNames: $goingNames)';
}


}

/// @nodoc
abstract mixin class $CampusEventCopyWith<$Res>  {
  factory $CampusEventCopyWith(CampusEvent value, $Res Function(CampusEvent) _then) = _$CampusEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime startsAt, String description, String emoji, String category, String place, int goingCount, bool isGoing, bool isMine,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> goingNames
});




}
/// @nodoc
class _$CampusEventCopyWithImpl<$Res>
    implements $CampusEventCopyWith<$Res> {
  _$CampusEventCopyWithImpl(this._self, this._then);

  final CampusEvent _self;
  final $Res Function(CampusEvent) _then;

/// Create a copy of CampusEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? startsAt = null,Object? description = null,Object? emoji = null,Object? category = null,Object? place = null,Object? goingCount = null,Object? isGoing = null,Object? isMine = null,Object? goingNames = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,goingCount: null == goingCount ? _self.goingCount : goingCount // ignore: cast_nullable_to_non_nullable
as int,isGoing: null == isGoing ? _self.isGoing : isGoing // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,goingNames: null == goingNames ? _self.goingNames : goingNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CampusEvent].
extension CampusEventPatterns on CampusEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampusEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampusEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampusEvent value)  $default,){
final _that = this;
switch (_that) {
case _CampusEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampusEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CampusEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime startsAt,  String description,  String emoji,  String category,  String place,  int goingCount,  bool isGoing,  bool isMine, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> goingNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampusEvent() when $default != null:
return $default(_that.id,_that.title,_that.startsAt,_that.description,_that.emoji,_that.category,_that.place,_that.goingCount,_that.isGoing,_that.isMine,_that.goingNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime startsAt,  String description,  String emoji,  String category,  String place,  int goingCount,  bool isGoing,  bool isMine, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> goingNames)  $default,) {final _that = this;
switch (_that) {
case _CampusEvent():
return $default(_that.id,_that.title,_that.startsAt,_that.description,_that.emoji,_that.category,_that.place,_that.goingCount,_that.isGoing,_that.isMine,_that.goingNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime startsAt,  String description,  String emoji,  String category,  String place,  int goingCount,  bool isGoing,  bool isMine, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> goingNames)?  $default,) {final _that = this;
switch (_that) {
case _CampusEvent() when $default != null:
return $default(_that.id,_that.title,_that.startsAt,_that.description,_that.emoji,_that.category,_that.place,_that.goingCount,_that.isGoing,_that.isMine,_that.goingNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CampusEvent implements CampusEvent {
  const _CampusEvent({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.title, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) required this.startsAt, this.description = '', this.emoji = '🎉', this.category = 'other', this.place = '', this.goingCount = 0, this.isGoing = false, this.isMine = false, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> goingNames = const <String>[]}): _goingNames = goingNames;
  factory _CampusEvent.fromJson(Map<String, dynamic> json) => _$CampusEventFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String title;
@override@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) final  DateTime startsAt;
@override@JsonKey() final  String description;
@override@JsonKey() final  String emoji;
@override@JsonKey() final  String category;
@override@JsonKey() final  String place;
@override@JsonKey() final  int goingCount;
@override@JsonKey() final  bool isGoing;
@override@JsonKey() final  bool isMine;
 final  List<String> _goingNames;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get goingNames {
  if (_goingNames is EqualUnmodifiableListView) return _goingNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goingNames);
}


/// Create a copy of CampusEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampusEventCopyWith<_CampusEvent> get copyWith => __$CampusEventCopyWithImpl<_CampusEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampusEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampusEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.category, category) || other.category == category)&&(identical(other.place, place) || other.place == place)&&(identical(other.goingCount, goingCount) || other.goingCount == goingCount)&&(identical(other.isGoing, isGoing) || other.isGoing == isGoing)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&const DeepCollectionEquality().equals(other._goingNames, _goingNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,startsAt,description,emoji,category,place,goingCount,isGoing,isMine,const DeepCollectionEquality().hash(_goingNames));

@override
String toString() {
  return 'CampusEvent(id: $id, title: $title, startsAt: $startsAt, description: $description, emoji: $emoji, category: $category, place: $place, goingCount: $goingCount, isGoing: $isGoing, isMine: $isMine, goingNames: $goingNames)';
}


}

/// @nodoc
abstract mixin class _$CampusEventCopyWith<$Res> implements $CampusEventCopyWith<$Res> {
  factory _$CampusEventCopyWith(_CampusEvent value, $Res Function(_CampusEvent) _then) = __$CampusEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime startsAt, String description, String emoji, String category, String place, int goingCount, bool isGoing, bool isMine,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> goingNames
});




}
/// @nodoc
class __$CampusEventCopyWithImpl<$Res>
    implements _$CampusEventCopyWith<$Res> {
  __$CampusEventCopyWithImpl(this._self, this._then);

  final _CampusEvent _self;
  final $Res Function(_CampusEvent) _then;

/// Create a copy of CampusEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? startsAt = null,Object? description = null,Object? emoji = null,Object? category = null,Object? place = null,Object? goingCount = null,Object? isGoing = null,Object? isMine = null,Object? goingNames = null,}) {
  return _then(_CampusEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,goingCount: null == goingCount ? _self.goingCount : goingCount // ignore: cast_nullable_to_non_nullable
as int,isGoing: null == isGoing ? _self.isGoing : isGoing // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,goingNames: null == goingNames ? _self._goingNames : goingNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
