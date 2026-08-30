// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamificationQuest {

 String get id; String get period; String get emoji; String get title; int get target; int get xpReward; int get progress; bool get isCompleted;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get completedAt;
/// Create a copy of GamificationQuest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamificationQuestCopyWith<GamificationQuest> get copyWith => _$GamificationQuestCopyWithImpl<GamificationQuest>(this as GamificationQuest, _$identity);

  /// Serializes this GamificationQuest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationQuest&&(identical(other.id, id) || other.id == id)&&(identical(other.period, period) || other.period == period)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.title, title) || other.title == title)&&(identical(other.target, target) || other.target == target)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,period,emoji,title,target,xpReward,progress,isCompleted,completedAt);

@override
String toString() {
  return 'GamificationQuest(id: $id, period: $period, emoji: $emoji, title: $title, target: $target, xpReward: $xpReward, progress: $progress, isCompleted: $isCompleted, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $GamificationQuestCopyWith<$Res>  {
  factory $GamificationQuestCopyWith(GamificationQuest value, $Res Function(GamificationQuest) _then) = _$GamificationQuestCopyWithImpl;
@useResult
$Res call({
 String id, String period, String emoji, String title, int target, int xpReward, int progress, bool isCompleted,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? completedAt
});




}
/// @nodoc
class _$GamificationQuestCopyWithImpl<$Res>
    implements $GamificationQuestCopyWith<$Res> {
  _$GamificationQuestCopyWithImpl(this._self, this._then);

  final GamificationQuest _self;
  final $Res Function(GamificationQuest) _then;

/// Create a copy of GamificationQuest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? period = null,Object? emoji = null,Object? title = null,Object? target = null,Object? xpReward = null,Object? progress = null,Object? isCompleted = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GamificationQuest].
extension GamificationQuestPatterns on GamificationQuest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamificationQuest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamificationQuest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamificationQuest value)  $default,){
final _that = this;
switch (_that) {
case _GamificationQuest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamificationQuest value)?  $default,){
final _that = this;
switch (_that) {
case _GamificationQuest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String period,  String emoji,  String title,  int target,  int xpReward,  int progress,  bool isCompleted, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamificationQuest() when $default != null:
return $default(_that.id,_that.period,_that.emoji,_that.title,_that.target,_that.xpReward,_that.progress,_that.isCompleted,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String period,  String emoji,  String title,  int target,  int xpReward,  int progress,  bool isCompleted, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _GamificationQuest():
return $default(_that.id,_that.period,_that.emoji,_that.title,_that.target,_that.xpReward,_that.progress,_that.isCompleted,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String period,  String emoji,  String title,  int target,  int xpReward,  int progress,  bool isCompleted, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _GamificationQuest() when $default != null:
return $default(_that.id,_that.period,_that.emoji,_that.title,_that.target,_that.xpReward,_that.progress,_that.isCompleted,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GamificationQuest extends GamificationQuest {
  const _GamificationQuest({required this.id, required this.period, required this.emoji, required this.title, required this.target, required this.xpReward, this.progress = 0, this.isCompleted = false, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.completedAt}): super._();
  factory _GamificationQuest.fromJson(Map<String, dynamic> json) => _$GamificationQuestFromJson(json);

@override final  String id;
@override final  String period;
@override final  String emoji;
@override final  String title;
@override final  int target;
@override final  int xpReward;
@override@JsonKey() final  int progress;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? completedAt;

/// Create a copy of GamificationQuest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamificationQuestCopyWith<_GamificationQuest> get copyWith => __$GamificationQuestCopyWithImpl<_GamificationQuest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamificationQuestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamificationQuest&&(identical(other.id, id) || other.id == id)&&(identical(other.period, period) || other.period == period)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.title, title) || other.title == title)&&(identical(other.target, target) || other.target == target)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,period,emoji,title,target,xpReward,progress,isCompleted,completedAt);

@override
String toString() {
  return 'GamificationQuest(id: $id, period: $period, emoji: $emoji, title: $title, target: $target, xpReward: $xpReward, progress: $progress, isCompleted: $isCompleted, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$GamificationQuestCopyWith<$Res> implements $GamificationQuestCopyWith<$Res> {
  factory _$GamificationQuestCopyWith(_GamificationQuest value, $Res Function(_GamificationQuest) _then) = __$GamificationQuestCopyWithImpl;
@override @useResult
$Res call({
 String id, String period, String emoji, String title, int target, int xpReward, int progress, bool isCompleted,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? completedAt
});




}
/// @nodoc
class __$GamificationQuestCopyWithImpl<$Res>
    implements _$GamificationQuestCopyWith<$Res> {
  __$GamificationQuestCopyWithImpl(this._self, this._then);

  final _GamificationQuest _self;
  final $Res Function(_GamificationQuest) _then;

/// Create a copy of GamificationQuest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? period = null,Object? emoji = null,Object? title = null,Object? target = null,Object? xpReward = null,Object? progress = null,Object? isCompleted = null,Object? completedAt = freezed,}) {
  return _then(_GamificationQuest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
