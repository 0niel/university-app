// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_found_report_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LostFoundReportDraft {

 String get title; LostFoundItemStatus get status; String get category; String get description; String get telegram; String get phoneNumber; String get location; bool get showContact; List<LostFoundImageUpload> get images;
/// Create a copy of LostFoundReportDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LostFoundReportDraftCopyWith<LostFoundReportDraft> get copyWith => _$LostFoundReportDraftCopyWithImpl<LostFoundReportDraft>(this as LostFoundReportDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LostFoundReportDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.telegram, telegram) || other.telegram == telegram)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.location, location) || other.location == location)&&(identical(other.showContact, showContact) || other.showContact == showContact)&&const DeepCollectionEquality().equals(other.images, images));
}


@override
int get hashCode => Object.hash(runtimeType,title,status,category,description,telegram,phoneNumber,location,showContact,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'LostFoundReportDraft(title: $title, status: $status, category: $category, description: $description, telegram: $telegram, phoneNumber: $phoneNumber, location: $location, showContact: $showContact, images: $images)';
}


}

/// @nodoc
abstract mixin class $LostFoundReportDraftCopyWith<$Res>  {
  factory $LostFoundReportDraftCopyWith(LostFoundReportDraft value, $Res Function(LostFoundReportDraft) _then) = _$LostFoundReportDraftCopyWithImpl;
@useResult
$Res call({
 String title, LostFoundItemStatus status, String category, String description, String telegram, String phoneNumber, String location, bool showContact, List<LostFoundImageUpload> images
});




}
/// @nodoc
class _$LostFoundReportDraftCopyWithImpl<$Res>
    implements $LostFoundReportDraftCopyWith<$Res> {
  _$LostFoundReportDraftCopyWithImpl(this._self, this._then);

  final LostFoundReportDraft _self;
  final $Res Function(LostFoundReportDraft) _then;

/// Create a copy of LostFoundReportDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? status = null,Object? category = null,Object? description = null,Object? telegram = null,Object? phoneNumber = null,Object? location = null,Object? showContact = null,Object? images = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LostFoundItemStatus,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,telegram: null == telegram ? _self.telegram : telegram // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,showContact: null == showContact ? _self.showContact : showContact // ignore: cast_nullable_to_non_nullable
as bool,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<LostFoundImageUpload>,
  ));
}

}


/// Adds pattern-matching-related methods to [LostFoundReportDraft].
extension LostFoundReportDraftPatterns on LostFoundReportDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LostFoundReportDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LostFoundReportDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LostFoundReportDraft value)  $default,){
final _that = this;
switch (_that) {
case _LostFoundReportDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LostFoundReportDraft value)?  $default,){
final _that = this;
switch (_that) {
case _LostFoundReportDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  LostFoundItemStatus status,  String category,  String description,  String telegram,  String phoneNumber,  String location,  bool showContact,  List<LostFoundImageUpload> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LostFoundReportDraft() when $default != null:
return $default(_that.title,_that.status,_that.category,_that.description,_that.telegram,_that.phoneNumber,_that.location,_that.showContact,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  LostFoundItemStatus status,  String category,  String description,  String telegram,  String phoneNumber,  String location,  bool showContact,  List<LostFoundImageUpload> images)  $default,) {final _that = this;
switch (_that) {
case _LostFoundReportDraft():
return $default(_that.title,_that.status,_that.category,_that.description,_that.telegram,_that.phoneNumber,_that.location,_that.showContact,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  LostFoundItemStatus status,  String category,  String description,  String telegram,  String phoneNumber,  String location,  bool showContact,  List<LostFoundImageUpload> images)?  $default,) {final _that = this;
switch (_that) {
case _LostFoundReportDraft() when $default != null:
return $default(_that.title,_that.status,_that.category,_that.description,_that.telegram,_that.phoneNumber,_that.location,_that.showContact,_that.images);case _:
  return null;

}
}

}

/// @nodoc


class _LostFoundReportDraft extends LostFoundReportDraft {
  const _LostFoundReportDraft({this.title = '', this.status = LostFoundItemStatus.found, this.category = 'other', this.description = '', this.telegram = '', this.phoneNumber = '', this.location = '', this.showContact = false, final  List<LostFoundImageUpload> images = const <LostFoundImageUpload>[]}): _images = images,super._();


@override@JsonKey() final  String title;
@override@JsonKey() final  LostFoundItemStatus status;
@override@JsonKey() final  String category;
@override@JsonKey() final  String description;
@override@JsonKey() final  String telegram;
@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  String location;
@override@JsonKey() final  bool showContact;
 final  List<LostFoundImageUpload> _images;
@override@JsonKey() List<LostFoundImageUpload> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of LostFoundReportDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LostFoundReportDraftCopyWith<_LostFoundReportDraft> get copyWith => __$LostFoundReportDraftCopyWithImpl<_LostFoundReportDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LostFoundReportDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.telegram, telegram) || other.telegram == telegram)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.location, location) || other.location == location)&&(identical(other.showContact, showContact) || other.showContact == showContact)&&const DeepCollectionEquality().equals(other._images, _images));
}


@override
int get hashCode => Object.hash(runtimeType,title,status,category,description,telegram,phoneNumber,location,showContact,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'LostFoundReportDraft(title: $title, status: $status, category: $category, description: $description, telegram: $telegram, phoneNumber: $phoneNumber, location: $location, showContact: $showContact, images: $images)';
}


}

/// @nodoc
abstract mixin class _$LostFoundReportDraftCopyWith<$Res> implements $LostFoundReportDraftCopyWith<$Res> {
  factory _$LostFoundReportDraftCopyWith(_LostFoundReportDraft value, $Res Function(_LostFoundReportDraft) _then) = __$LostFoundReportDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, LostFoundItemStatus status, String category, String description, String telegram, String phoneNumber, String location, bool showContact, List<LostFoundImageUpload> images
});




}
/// @nodoc
class __$LostFoundReportDraftCopyWithImpl<$Res>
    implements _$LostFoundReportDraftCopyWith<$Res> {
  __$LostFoundReportDraftCopyWithImpl(this._self, this._then);

  final _LostFoundReportDraft _self;
  final $Res Function(_LostFoundReportDraft) _then;

/// Create a copy of LostFoundReportDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? status = null,Object? category = null,Object? description = null,Object? telegram = null,Object? phoneNumber = null,Object? location = null,Object? showContact = null,Object? images = null,}) {
  return _then(_LostFoundReportDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LostFoundItemStatus,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,telegram: null == telegram ? _self.telegram : telegram // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,showContact: null == showContact ? _self.showContact : showContact // ignore: cast_nullable_to_non_nullable
as bool,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<LostFoundImageUpload>,
  ));
}


}

// dart format on
