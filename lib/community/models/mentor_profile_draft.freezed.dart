// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentor_profile_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MentorProfileDraft {

 List<String> get topics; String get bio; String get level; List<String> get formats; int get price;
/// Create a copy of MentorProfileDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentorProfileDraftCopyWith<MentorProfileDraft> get copyWith => _$MentorProfileDraftCopyWithImpl<MentorProfileDraft>(this as MentorProfileDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentorProfileDraft&&const DeepCollectionEquality().equals(other.topics, topics)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.formats, formats)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(topics),bio,level,const DeepCollectionEquality().hash(formats),price);

@override
String toString() {
  return 'MentorProfileDraft(topics: $topics, bio: $bio, level: $level, formats: $formats, price: $price)';
}


}

/// @nodoc
abstract mixin class $MentorProfileDraftCopyWith<$Res>  {
  factory $MentorProfileDraftCopyWith(MentorProfileDraft value, $Res Function(MentorProfileDraft) _then) = _$MentorProfileDraftCopyWithImpl;
@useResult
$Res call({
 List<String> topics, String bio, String level, List<String> formats, int price
});




}
/// @nodoc
class _$MentorProfileDraftCopyWithImpl<$Res>
    implements $MentorProfileDraftCopyWith<$Res> {
  _$MentorProfileDraftCopyWithImpl(this._self, this._then);

  final MentorProfileDraft _self;
  final $Res Function(MentorProfileDraft) _then;

/// Create a copy of MentorProfileDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topics = null,Object? bio = null,Object? level = null,Object? formats = null,Object? price = null,}) {
  return _then(_self.copyWith(
topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,formats: null == formats ? _self.formats : formats // ignore: cast_nullable_to_non_nullable
as List<String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MentorProfileDraft].
extension MentorProfileDraftPatterns on MentorProfileDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentorProfileDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentorProfileDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentorProfileDraft value)  $default,){
final _that = this;
switch (_that) {
case _MentorProfileDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentorProfileDraft value)?  $default,){
final _that = this;
switch (_that) {
case _MentorProfileDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> topics,  String bio,  String level,  List<String> formats,  int price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentorProfileDraft() when $default != null:
return $default(_that.topics,_that.bio,_that.level,_that.formats,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> topics,  String bio,  String level,  List<String> formats,  int price)  $default,) {final _that = this;
switch (_that) {
case _MentorProfileDraft():
return $default(_that.topics,_that.bio,_that.level,_that.formats,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> topics,  String bio,  String level,  List<String> formats,  int price)?  $default,) {final _that = this;
switch (_that) {
case _MentorProfileDraft() when $default != null:
return $default(_that.topics,_that.bio,_that.level,_that.formats,_that.price);case _:
  return null;

}
}

}

/// @nodoc


class _MentorProfileDraft implements MentorProfileDraft {
  const _MentorProfileDraft({final  List<String> topics = const <String>[], this.bio = '', this.level = '', final  List<String> formats = const <String>[], this.price = 0}): _topics = topics,_formats = formats;


 final  List<String> _topics;
@override@JsonKey() List<String> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}

@override@JsonKey() final  String bio;
@override@JsonKey() final  String level;
 final  List<String> _formats;
@override@JsonKey() List<String> get formats {
  if (_formats is EqualUnmodifiableListView) return _formats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_formats);
}

@override@JsonKey() final  int price;

/// Create a copy of MentorProfileDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentorProfileDraftCopyWith<_MentorProfileDraft> get copyWith => __$MentorProfileDraftCopyWithImpl<_MentorProfileDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentorProfileDraft&&const DeepCollectionEquality().equals(other._topics, _topics)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._formats, _formats)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_topics),bio,level,const DeepCollectionEquality().hash(_formats),price);

@override
String toString() {
  return 'MentorProfileDraft(topics: $topics, bio: $bio, level: $level, formats: $formats, price: $price)';
}


}

/// @nodoc
abstract mixin class _$MentorProfileDraftCopyWith<$Res> implements $MentorProfileDraftCopyWith<$Res> {
  factory _$MentorProfileDraftCopyWith(_MentorProfileDraft value, $Res Function(_MentorProfileDraft) _then) = __$MentorProfileDraftCopyWithImpl;
@override @useResult
$Res call({
 List<String> topics, String bio, String level, List<String> formats, int price
});




}
/// @nodoc
class __$MentorProfileDraftCopyWithImpl<$Res>
    implements _$MentorProfileDraftCopyWith<$Res> {
  __$MentorProfileDraftCopyWithImpl(this._self, this._then);

  final _MentorProfileDraft _self;
  final $Res Function(_MentorProfileDraft) _then;

/// Create a copy of MentorProfileDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topics = null,Object? bio = null,Object? level = null,Object? formats = null,Object? price = null,}) {
  return _then(_MentorProfileDraft(
topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,formats: null == formats ? _self._formats : formats // ignore: cast_nullable_to_non_nullable
as List<String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
