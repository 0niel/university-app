// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'squad_challenge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SquadChallenge {

 String get id; String get title; String get description; int get rewardShurikens; int get target; int get progress; DateTime get endsAt;
/// Create a copy of SquadChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SquadChallengeCopyWith<SquadChallenge> get copyWith => _$SquadChallengeCopyWithImpl<SquadChallenge>(this as SquadChallenge, _$identity);

  /// Serializes this SquadChallenge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SquadChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.rewardShurikens, rewardShurikens) || other.rewardShurikens == rewardShurikens)&&(identical(other.target, target) || other.target == target)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,rewardShurikens,target,progress,endsAt);

@override
String toString() {
  return 'SquadChallenge(id: $id, title: $title, description: $description, rewardShurikens: $rewardShurikens, target: $target, progress: $progress, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $SquadChallengeCopyWith<$Res>  {
  factory $SquadChallengeCopyWith(SquadChallenge value, $Res Function(SquadChallenge) _then) = _$SquadChallengeCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, int rewardShurikens, int target, int progress, DateTime endsAt
});




}
/// @nodoc
class _$SquadChallengeCopyWithImpl<$Res>
    implements $SquadChallengeCopyWith<$Res> {
  _$SquadChallengeCopyWithImpl(this._self, this._then);

  final SquadChallenge _self;
  final $Res Function(SquadChallenge) _then;

/// Create a copy of SquadChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? rewardShurikens = null,Object? target = null,Object? progress = null,Object? endsAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,rewardShurikens: null == rewardShurikens ? _self.rewardShurikens : rewardShurikens // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SquadChallenge].
extension SquadChallengePatterns on SquadChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SquadChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SquadChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SquadChallenge value)  $default,){
final _that = this;
switch (_that) {
case _SquadChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SquadChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _SquadChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  int rewardShurikens,  int target,  int progress,  DateTime endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SquadChallenge() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.rewardShurikens,_that.target,_that.progress,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  int rewardShurikens,  int target,  int progress,  DateTime endsAt)  $default,) {final _that = this;
switch (_that) {
case _SquadChallenge():
return $default(_that.id,_that.title,_that.description,_that.rewardShurikens,_that.target,_that.progress,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  int rewardShurikens,  int target,  int progress,  DateTime endsAt)?  $default,) {final _that = this;
switch (_that) {
case _SquadChallenge() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.rewardShurikens,_that.target,_that.progress,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SquadChallenge extends SquadChallenge {
  const _SquadChallenge({required this.id, required this.title, required this.description, required this.rewardShurikens, required this.target, required this.progress, required this.endsAt}): super._();
  factory _SquadChallenge.fromJson(Map<String, dynamic> json) => _$SquadChallengeFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  int rewardShurikens;
@override final  int target;
@override final  int progress;
@override final  DateTime endsAt;

/// Create a copy of SquadChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SquadChallengeCopyWith<_SquadChallenge> get copyWith => __$SquadChallengeCopyWithImpl<_SquadChallenge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SquadChallengeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SquadChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.rewardShurikens, rewardShurikens) || other.rewardShurikens == rewardShurikens)&&(identical(other.target, target) || other.target == target)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,rewardShurikens,target,progress,endsAt);

@override
String toString() {
  return 'SquadChallenge(id: $id, title: $title, description: $description, rewardShurikens: $rewardShurikens, target: $target, progress: $progress, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$SquadChallengeCopyWith<$Res> implements $SquadChallengeCopyWith<$Res> {
  factory _$SquadChallengeCopyWith(_SquadChallenge value, $Res Function(_SquadChallenge) _then) = __$SquadChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, int rewardShurikens, int target, int progress, DateTime endsAt
});




}
/// @nodoc
class __$SquadChallengeCopyWithImpl<$Res>
    implements _$SquadChallengeCopyWith<$Res> {
  __$SquadChallengeCopyWithImpl(this._self, this._then);

  final _SquadChallenge _self;
  final $Res Function(_SquadChallenge) _then;

/// Create a copy of SquadChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? rewardShurikens = null,Object? target = null,Object? progress = null,Object? endsAt = null,}) {
  return _then(_SquadChallenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,rewardShurikens: null == rewardShurikens ? _self.rewardShurikens : rewardShurikens // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
