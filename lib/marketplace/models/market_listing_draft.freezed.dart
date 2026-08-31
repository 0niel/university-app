// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_listing_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketListingDraft {

 String get title; int get price; String get category; String get description; bool get showContact;
/// Create a copy of MarketListingDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketListingDraftCopyWith<MarketListingDraft> get copyWith => _$MarketListingDraftCopyWithImpl<MarketListingDraft>(this as MarketListingDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketListingDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.showContact, showContact) || other.showContact == showContact));
}


@override
int get hashCode => Object.hash(runtimeType,title,price,category,description,showContact);

@override
String toString() {
  return 'MarketListingDraft(title: $title, price: $price, category: $category, description: $description, showContact: $showContact)';
}


}

/// @nodoc
abstract mixin class $MarketListingDraftCopyWith<$Res>  {
  factory $MarketListingDraftCopyWith(MarketListingDraft value, $Res Function(MarketListingDraft) _then) = _$MarketListingDraftCopyWithImpl;
@useResult
$Res call({
 String title, int price, String category, String description, bool showContact
});




}
/// @nodoc
class _$MarketListingDraftCopyWithImpl<$Res>
    implements $MarketListingDraftCopyWith<$Res> {
  _$MarketListingDraftCopyWithImpl(this._self, this._then);

  final MarketListingDraft _self;
  final $Res Function(MarketListingDraft) _then;

/// Create a copy of MarketListingDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? price = null,Object? category = null,Object? description = null,Object? showContact = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,showContact: null == showContact ? _self.showContact : showContact // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketListingDraft].
extension MarketListingDraftPatterns on MarketListingDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketListingDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketListingDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketListingDraft value)  $default,){
final _that = this;
switch (_that) {
case _MarketListingDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketListingDraft value)?  $default,){
final _that = this;
switch (_that) {
case _MarketListingDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int price,  String category,  String description,  bool showContact)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketListingDraft() when $default != null:
return $default(_that.title,_that.price,_that.category,_that.description,_that.showContact);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int price,  String category,  String description,  bool showContact)  $default,) {final _that = this;
switch (_that) {
case _MarketListingDraft():
return $default(_that.title,_that.price,_that.category,_that.description,_that.showContact);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int price,  String category,  String description,  bool showContact)?  $default,) {final _that = this;
switch (_that) {
case _MarketListingDraft() when $default != null:
return $default(_that.title,_that.price,_that.category,_that.description,_that.showContact);case _:
  return null;

}
}

}

/// @nodoc


class _MarketListingDraft extends MarketListingDraft {
  const _MarketListingDraft({this.title = '', this.price = -1, this.category = 'other', this.description = '', this.showContact = false}): super._();


@override@JsonKey() final  String title;
@override@JsonKey() final  int price;
@override@JsonKey() final  String category;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool showContact;

/// Create a copy of MarketListingDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketListingDraftCopyWith<_MarketListingDraft> get copyWith => __$MarketListingDraftCopyWithImpl<_MarketListingDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketListingDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.showContact, showContact) || other.showContact == showContact));
}


@override
int get hashCode => Object.hash(runtimeType,title,price,category,description,showContact);

@override
String toString() {
  return 'MarketListingDraft(title: $title, price: $price, category: $category, description: $description, showContact: $showContact)';
}


}

/// @nodoc
abstract mixin class _$MarketListingDraftCopyWith<$Res> implements $MarketListingDraftCopyWith<$Res> {
  factory _$MarketListingDraftCopyWith(_MarketListingDraft value, $Res Function(_MarketListingDraft) _then) = __$MarketListingDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, int price, String category, String description, bool showContact
});




}
/// @nodoc
class __$MarketListingDraftCopyWithImpl<$Res>
    implements _$MarketListingDraftCopyWith<$Res> {
  __$MarketListingDraftCopyWithImpl(this._self, this._then);

  final _MarketListingDraft _self;
  final $Res Function(_MarketListingDraft) _then;

/// Create a copy of MarketListingDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? price = null,Object? category = null,Object? description = null,Object? showContact = null,}) {
  return _then(_MarketListingDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,showContact: null == showContact ? _self.showContact : showContact // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
