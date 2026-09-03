// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketListing {

 String get id; String get title; int get price; String get description; String get category; String get emoji; bool get isSold; bool get isFree;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt; bool get isMine; String get sellerName; bool get showContact;@JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson) List<MarketMediaItem> get media; String? get telegramHandle;
/// Create a copy of MarketListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketListingCopyWith<MarketListing> get copyWith => _$MarketListingCopyWithImpl<MarketListing>(this as MarketListing, _$identity);

  /// Serializes this MarketListing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketListing&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.isSold, isSold) || other.isSold == isSold)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.showContact, showContact) || other.showContact == showContact)&&const DeepCollectionEquality().equals(other.media, media)&&(identical(other.telegramHandle, telegramHandle) || other.telegramHandle == telegramHandle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,price,description,category,emoji,isSold,isFree,createdAt,isMine,sellerName,showContact,const DeepCollectionEquality().hash(media),telegramHandle);

@override
String toString() {
  return 'MarketListing(id: $id, title: $title, price: $price, description: $description, category: $category, emoji: $emoji, isSold: $isSold, isFree: $isFree, createdAt: $createdAt, isMine: $isMine, sellerName: $sellerName, showContact: $showContact, media: $media, telegramHandle: $telegramHandle)';
}


}

/// @nodoc
abstract mixin class $MarketListingCopyWith<$Res>  {
  factory $MarketListingCopyWith(MarketListing value, $Res Function(MarketListing) _then) = _$MarketListingCopyWithImpl;
@useResult
$Res call({
 String id, String title, int price, String description, String category, String emoji, bool isSold, bool isFree,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isMine, String sellerName, bool showContact,@JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson) List<MarketMediaItem> media, String? telegramHandle
});




}
/// @nodoc
class _$MarketListingCopyWithImpl<$Res>
    implements $MarketListingCopyWith<$Res> {
  _$MarketListingCopyWithImpl(this._self, this._then);

  final MarketListing _self;
  final $Res Function(MarketListing) _then;

/// Create a copy of MarketListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? price = null,Object? description = null,Object? category = null,Object? emoji = null,Object? isSold = null,Object? isFree = null,Object? createdAt = freezed,Object? isMine = null,Object? sellerName = null,Object? showContact = null,Object? media = null,Object? telegramHandle = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,isSold: null == isSold ? _self.isSold : isSold // ignore: cast_nullable_to_non_nullable
as bool,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,sellerName: null == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String,showContact: null == showContact ? _self.showContact : showContact // ignore: cast_nullable_to_non_nullable
as bool,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<MarketMediaItem>,telegramHandle: freezed == telegramHandle ? _self.telegramHandle : telegramHandle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketListing].
extension MarketListingPatterns on MarketListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketListing value)  $default,){
final _that = this;
switch (_that) {
case _MarketListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketListing value)?  $default,){
final _that = this;
switch (_that) {
case _MarketListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int price,  String description,  String category,  String emoji,  bool isSold,  bool isFree, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  String sellerName,  bool showContact, @JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson)  List<MarketMediaItem> media,  String? telegramHandle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketListing() when $default != null:
return $default(_that.id,_that.title,_that.price,_that.description,_that.category,_that.emoji,_that.isSold,_that.isFree,_that.createdAt,_that.isMine,_that.sellerName,_that.showContact,_that.media,_that.telegramHandle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int price,  String description,  String category,  String emoji,  bool isSold,  bool isFree, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  String sellerName,  bool showContact, @JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson)  List<MarketMediaItem> media,  String? telegramHandle)  $default,) {final _that = this;
switch (_that) {
case _MarketListing():
return $default(_that.id,_that.title,_that.price,_that.description,_that.category,_that.emoji,_that.isSold,_that.isFree,_that.createdAt,_that.isMine,_that.sellerName,_that.showContact,_that.media,_that.telegramHandle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int price,  String description,  String category,  String emoji,  bool isSold,  bool isFree, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  String sellerName,  bool showContact, @JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson)  List<MarketMediaItem> media,  String? telegramHandle)?  $default,) {final _that = this;
switch (_that) {
case _MarketListing() when $default != null:
return $default(_that.id,_that.title,_that.price,_that.description,_that.category,_that.emoji,_that.isSold,_that.isFree,_that.createdAt,_that.isMine,_that.sellerName,_that.showContact,_that.media,_that.telegramHandle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketListing extends MarketListing {
  const _MarketListing({required this.id, required this.title, required this.price, this.description = '', this.category = 'other', this.emoji = '📦', this.isSold = false, this.isFree = false, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt, this.isMine = false, this.sellerName = '', this.showContact = false, @JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson) final  List<MarketMediaItem> media = const <MarketMediaItem>[], this.telegramHandle}): _media = media,super._();
  factory _MarketListing.fromJson(Map<String, dynamic> json) => _$MarketListingFromJson(json);

@override final  String id;
@override final  String title;
@override final  int price;
@override@JsonKey() final  String description;
@override@JsonKey() final  String category;
@override@JsonKey() final  String emoji;
@override@JsonKey() final  bool isSold;
@override@JsonKey() final  bool isFree;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  String sellerName;
@override@JsonKey() final  bool showContact;
 final  List<MarketMediaItem> _media;
@override@JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson) List<MarketMediaItem> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

@override final  String? telegramHandle;

/// Create a copy of MarketListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketListingCopyWith<_MarketListing> get copyWith => __$MarketListingCopyWithImpl<_MarketListing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketListingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketListing&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.isSold, isSold) || other.isSold == isSold)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.showContact, showContact) || other.showContact == showContact)&&const DeepCollectionEquality().equals(other._media, _media)&&(identical(other.telegramHandle, telegramHandle) || other.telegramHandle == telegramHandle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,price,description,category,emoji,isSold,isFree,createdAt,isMine,sellerName,showContact,const DeepCollectionEquality().hash(_media),telegramHandle);

@override
String toString() {
  return 'MarketListing(id: $id, title: $title, price: $price, description: $description, category: $category, emoji: $emoji, isSold: $isSold, isFree: $isFree, createdAt: $createdAt, isMine: $isMine, sellerName: $sellerName, showContact: $showContact, media: $media, telegramHandle: $telegramHandle)';
}


}

/// @nodoc
abstract mixin class _$MarketListingCopyWith<$Res> implements $MarketListingCopyWith<$Res> {
  factory _$MarketListingCopyWith(_MarketListing value, $Res Function(_MarketListing) _then) = __$MarketListingCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int price, String description, String category, String emoji, bool isSold, bool isFree,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isMine, String sellerName, bool showContact,@JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson) List<MarketMediaItem> media, String? telegramHandle
});




}
/// @nodoc
class __$MarketListingCopyWithImpl<$Res>
    implements _$MarketListingCopyWith<$Res> {
  __$MarketListingCopyWithImpl(this._self, this._then);

  final _MarketListing _self;
  final $Res Function(_MarketListing) _then;

/// Create a copy of MarketListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? price = null,Object? description = null,Object? category = null,Object? emoji = null,Object? isSold = null,Object? isFree = null,Object? createdAt = freezed,Object? isMine = null,Object? sellerName = null,Object? showContact = null,Object? media = null,Object? telegramHandle = freezed,}) {
  return _then(_MarketListing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,isSold: null == isSold ? _self.isSold : isSold // ignore: cast_nullable_to_non_nullable
as bool,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,sellerName: null == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String,showContact: null == showContact ? _self.showContact : showContact // ignore: cast_nullable_to_non_nullable
as bool,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<MarketMediaItem>,telegramHandle: freezed == telegramHandle ? _self.telegramHandle : telegramHandle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
