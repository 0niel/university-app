// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherProfile {

@JsonKey(defaultValue: '') String get teacherName; int get reviewsCount; double? get clarity; double? get loyalty; double? get usefulness;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get subjects;@JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson) List<TeacherReview> get reviews;
/// Create a copy of TeacherProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherProfileCopyWith<TeacherProfile> get copyWith => _$TeacherProfileCopyWithImpl<TeacherProfile>(this as TeacherProfile, _$identity);

  /// Serializes this TeacherProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherProfile&&(identical(other.teacherName, teacherName) || other.teacherName == teacherName)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.clarity, clarity) || other.clarity == clarity)&&(identical(other.loyalty, loyalty) || other.loyalty == loyalty)&&(identical(other.usefulness, usefulness) || other.usefulness == usefulness)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&const DeepCollectionEquality().equals(other.reviews, reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teacherName,reviewsCount,clarity,loyalty,usefulness,const DeepCollectionEquality().hash(subjects),const DeepCollectionEquality().hash(reviews));

@override
String toString() {
  return 'TeacherProfile(teacherName: $teacherName, reviewsCount: $reviewsCount, clarity: $clarity, loyalty: $loyalty, usefulness: $usefulness, subjects: $subjects, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class $TeacherProfileCopyWith<$Res>  {
  factory $TeacherProfileCopyWith(TeacherProfile value, $Res Function(TeacherProfile) _then) = _$TeacherProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String teacherName, int reviewsCount, double? clarity, double? loyalty, double? usefulness,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> subjects,@JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson) List<TeacherReview> reviews
});




}
/// @nodoc
class _$TeacherProfileCopyWithImpl<$Res>
    implements $TeacherProfileCopyWith<$Res> {
  _$TeacherProfileCopyWithImpl(this._self, this._then);

  final TeacherProfile _self;
  final $Res Function(TeacherProfile) _then;

/// Create a copy of TeacherProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teacherName = null,Object? reviewsCount = null,Object? clarity = freezed,Object? loyalty = freezed,Object? usefulness = freezed,Object? subjects = null,Object? reviews = null,}) {
  return _then(_self.copyWith(
teacherName: null == teacherName ? _self.teacherName : teacherName // ignore: cast_nullable_to_non_nullable
as String,reviewsCount: null == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int,clarity: freezed == clarity ? _self.clarity : clarity // ignore: cast_nullable_to_non_nullable
as double?,loyalty: freezed == loyalty ? _self.loyalty : loyalty // ignore: cast_nullable_to_non_nullable
as double?,usefulness: freezed == usefulness ? _self.usefulness : usefulness // ignore: cast_nullable_to_non_nullable
as double?,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<TeacherReview>,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherProfile].
extension TeacherProfilePatterns on TeacherProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherProfile value)  $default,){
final _that = this;
switch (_that) {
case _TeacherProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherProfile value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String teacherName,  int reviewsCount,  double? clarity,  double? loyalty,  double? usefulness, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> subjects, @JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson)  List<TeacherReview> reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherProfile() when $default != null:
return $default(_that.teacherName,_that.reviewsCount,_that.clarity,_that.loyalty,_that.usefulness,_that.subjects,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String teacherName,  int reviewsCount,  double? clarity,  double? loyalty,  double? usefulness, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> subjects, @JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson)  List<TeacherReview> reviews)  $default,) {final _that = this;
switch (_that) {
case _TeacherProfile():
return $default(_that.teacherName,_that.reviewsCount,_that.clarity,_that.loyalty,_that.usefulness,_that.subjects,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String teacherName,  int reviewsCount,  double? clarity,  double? loyalty,  double? usefulness, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> subjects, @JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson)  List<TeacherReview> reviews)?  $default,) {final _that = this;
switch (_that) {
case _TeacherProfile() when $default != null:
return $default(_that.teacherName,_that.reviewsCount,_that.clarity,_that.loyalty,_that.usefulness,_that.subjects,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherProfile extends TeacherProfile {
  const _TeacherProfile({@JsonKey(defaultValue: '') required this.teacherName, this.reviewsCount = 0, this.clarity, this.loyalty, this.usefulness, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> subjects = const <String>[], @JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson) final  List<TeacherReview> reviews = const <TeacherReview>[]}): _subjects = subjects,_reviews = reviews,super._();
  factory _TeacherProfile.fromJson(Map<String, dynamic> json) => _$TeacherProfileFromJson(json);

@override@JsonKey(defaultValue: '') final  String teacherName;
@override@JsonKey() final  int reviewsCount;
@override final  double? clarity;
@override final  double? loyalty;
@override final  double? usefulness;
 final  List<String> _subjects;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get subjects {
  if (_subjects is EqualUnmodifiableListView) return _subjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjects);
}

 final  List<TeacherReview> _reviews;
@override@JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson) List<TeacherReview> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}


/// Create a copy of TeacherProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherProfileCopyWith<_TeacherProfile> get copyWith => __$TeacherProfileCopyWithImpl<_TeacherProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherProfile&&(identical(other.teacherName, teacherName) || other.teacherName == teacherName)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.clarity, clarity) || other.clarity == clarity)&&(identical(other.loyalty, loyalty) || other.loyalty == loyalty)&&(identical(other.usefulness, usefulness) || other.usefulness == usefulness)&&const DeepCollectionEquality().equals(other._subjects, _subjects)&&const DeepCollectionEquality().equals(other._reviews, _reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teacherName,reviewsCount,clarity,loyalty,usefulness,const DeepCollectionEquality().hash(_subjects),const DeepCollectionEquality().hash(_reviews));

@override
String toString() {
  return 'TeacherProfile(teacherName: $teacherName, reviewsCount: $reviewsCount, clarity: $clarity, loyalty: $loyalty, usefulness: $usefulness, subjects: $subjects, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$TeacherProfileCopyWith<$Res> implements $TeacherProfileCopyWith<$Res> {
  factory _$TeacherProfileCopyWith(_TeacherProfile value, $Res Function(_TeacherProfile) _then) = __$TeacherProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String teacherName, int reviewsCount, double? clarity, double? loyalty, double? usefulness,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> subjects,@JsonKey(fromJson: _reviewsFromJson, toJson: _reviewsToJson) List<TeacherReview> reviews
});




}
/// @nodoc
class __$TeacherProfileCopyWithImpl<$Res>
    implements _$TeacherProfileCopyWith<$Res> {
  __$TeacherProfileCopyWithImpl(this._self, this._then);

  final _TeacherProfile _self;
  final $Res Function(_TeacherProfile) _then;

/// Create a copy of TeacherProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teacherName = null,Object? reviewsCount = null,Object? clarity = freezed,Object? loyalty = freezed,Object? usefulness = freezed,Object? subjects = null,Object? reviews = null,}) {
  return _then(_TeacherProfile(
teacherName: null == teacherName ? _self.teacherName : teacherName // ignore: cast_nullable_to_non_nullable
as String,reviewsCount: null == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int,clarity: freezed == clarity ? _self.clarity : clarity // ignore: cast_nullable_to_non_nullable
as double?,loyalty: freezed == loyalty ? _self.loyalty : loyalty // ignore: cast_nullable_to_non_nullable
as double?,usefulness: freezed == usefulness ? _self.usefulness : usefulness // ignore: cast_nullable_to_non_nullable
as double?,subjects: null == subjects ? _self._subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<TeacherReview>,
  ));
}


}


/// @nodoc
mixin _$TeacherReview {

@JsonKey(defaultValue: '') String get id; int get clarity; int get loyalty; int get usefulness; String get body; String get authorName; bool get isMine;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt;
/// Create a copy of TeacherReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherReviewCopyWith<TeacherReview> get copyWith => _$TeacherReviewCopyWithImpl<TeacherReview>(this as TeacherReview, _$identity);

  /// Serializes this TeacherReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherReview&&(identical(other.id, id) || other.id == id)&&(identical(other.clarity, clarity) || other.clarity == clarity)&&(identical(other.loyalty, loyalty) || other.loyalty == loyalty)&&(identical(other.usefulness, usefulness) || other.usefulness == usefulness)&&(identical(other.body, body) || other.body == body)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clarity,loyalty,usefulness,body,authorName,isMine,createdAt);

@override
String toString() {
  return 'TeacherReview(id: $id, clarity: $clarity, loyalty: $loyalty, usefulness: $usefulness, body: $body, authorName: $authorName, isMine: $isMine, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TeacherReviewCopyWith<$Res>  {
  factory $TeacherReviewCopyWith(TeacherReview value, $Res Function(TeacherReview) _then) = _$TeacherReviewCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id, int clarity, int loyalty, int usefulness, String body, String authorName, bool isMine,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class _$TeacherReviewCopyWithImpl<$Res>
    implements $TeacherReviewCopyWith<$Res> {
  _$TeacherReviewCopyWithImpl(this._self, this._then);

  final TeacherReview _self;
  final $Res Function(TeacherReview) _then;

/// Create a copy of TeacherReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clarity = null,Object? loyalty = null,Object? usefulness = null,Object? body = null,Object? authorName = null,Object? isMine = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clarity: null == clarity ? _self.clarity : clarity // ignore: cast_nullable_to_non_nullable
as int,loyalty: null == loyalty ? _self.loyalty : loyalty // ignore: cast_nullable_to_non_nullable
as int,usefulness: null == usefulness ? _self.usefulness : usefulness // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherReview].
extension TeacherReviewPatterns on TeacherReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherReview value)  $default,){
final _that = this;
switch (_that) {
case _TeacherReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherReview value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id,  int clarity,  int loyalty,  int usefulness,  String body,  String authorName,  bool isMine, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherReview() when $default != null:
return $default(_that.id,_that.clarity,_that.loyalty,_that.usefulness,_that.body,_that.authorName,_that.isMine,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id,  int clarity,  int loyalty,  int usefulness,  String body,  String authorName,  bool isMine, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TeacherReview():
return $default(_that.id,_that.clarity,_that.loyalty,_that.usefulness,_that.body,_that.authorName,_that.isMine,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id,  int clarity,  int loyalty,  int usefulness,  String body,  String authorName,  bool isMine, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TeacherReview() when $default != null:
return $default(_that.id,_that.clarity,_that.loyalty,_that.usefulness,_that.body,_that.authorName,_that.isMine,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherReview extends TeacherReview {
  const _TeacherReview({@JsonKey(defaultValue: '') required this.id, this.clarity = 0, this.loyalty = 0, this.usefulness = 0, this.body = '', this.authorName = '', this.isMine = false, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt}): super._();
  factory _TeacherReview.fromJson(Map<String, dynamic> json) => _$TeacherReviewFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey() final  int clarity;
@override@JsonKey() final  int loyalty;
@override@JsonKey() final  int usefulness;
@override@JsonKey() final  String body;
@override@JsonKey() final  String authorName;
@override@JsonKey() final  bool isMine;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;

/// Create a copy of TeacherReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherReviewCopyWith<_TeacherReview> get copyWith => __$TeacherReviewCopyWithImpl<_TeacherReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherReview&&(identical(other.id, id) || other.id == id)&&(identical(other.clarity, clarity) || other.clarity == clarity)&&(identical(other.loyalty, loyalty) || other.loyalty == loyalty)&&(identical(other.usefulness, usefulness) || other.usefulness == usefulness)&&(identical(other.body, body) || other.body == body)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clarity,loyalty,usefulness,body,authorName,isMine,createdAt);

@override
String toString() {
  return 'TeacherReview(id: $id, clarity: $clarity, loyalty: $loyalty, usefulness: $usefulness, body: $body, authorName: $authorName, isMine: $isMine, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TeacherReviewCopyWith<$Res> implements $TeacherReviewCopyWith<$Res> {
  factory _$TeacherReviewCopyWith(_TeacherReview value, $Res Function(_TeacherReview) _then) = __$TeacherReviewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id, int clarity, int loyalty, int usefulness, String body, String authorName, bool isMine,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class __$TeacherReviewCopyWithImpl<$Res>
    implements _$TeacherReviewCopyWith<$Res> {
  __$TeacherReviewCopyWithImpl(this._self, this._then);

  final _TeacherReview _self;
  final $Res Function(_TeacherReview) _then;

/// Create a copy of TeacherReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clarity = null,Object? loyalty = null,Object? usefulness = null,Object? body = null,Object? authorName = null,Object? isMine = null,Object? createdAt = freezed,}) {
  return _then(_TeacherReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clarity: null == clarity ? _self.clarity : clarity // ignore: cast_nullable_to_non_nullable
as int,loyalty: null == loyalty ? _self.loyalty : loyalty // ignore: cast_nullable_to_non_nullable
as int,usefulness: null == usefulness ? _self.usefulness : usefulness // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
