// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_found_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LostFoundItem {

 String get id; String get authorId; String get itemName; LostFoundItemStatus get status; DateTime get createdAt; String get authorName; String? get description; String get category; String get location;@JsonKey(name: 'images') List<String> get imagePaths;@JsonKey(includeFromJson: false, includeToJson: false) List<String> get imageUrls; bool get showContact; String? get telegramContactInfo; String? get phoneNumberContactInfo; bool get isMine;
/// Create a copy of LostFoundItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LostFoundItemCopyWith<LostFoundItem> get copyWith => _$LostFoundItemCopyWithImpl<LostFoundItem>(this as LostFoundItem, _$identity);

  /// Serializes this LostFoundItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LostFoundItem&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.imagePaths, imagePaths)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.showContact, showContact) || other.showContact == showContact)&&(identical(other.telegramContactInfo, telegramContactInfo) || other.telegramContactInfo == telegramContactInfo)&&(identical(other.phoneNumberContactInfo, phoneNumberContactInfo) || other.phoneNumberContactInfo == phoneNumberContactInfo)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorId,itemName,status,createdAt,authorName,description,category,location,const DeepCollectionEquality().hash(imagePaths),const DeepCollectionEquality().hash(imageUrls),showContact,telegramContactInfo,phoneNumberContactInfo,isMine);

@override
String toString() {
  return 'LostFoundItem(id: $id, authorId: $authorId, itemName: $itemName, status: $status, createdAt: $createdAt, authorName: $authorName, description: $description, category: $category, location: $location, imagePaths: $imagePaths, imageUrls: $imageUrls, showContact: $showContact, telegramContactInfo: $telegramContactInfo, phoneNumberContactInfo: $phoneNumberContactInfo, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class $LostFoundItemCopyWith<$Res>  {
  factory $LostFoundItemCopyWith(LostFoundItem value, $Res Function(LostFoundItem) _then) = _$LostFoundItemCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, String itemName, LostFoundItemStatus status, DateTime createdAt, String authorName, String? description, String category, String location,@JsonKey(name: 'images') List<String> imagePaths,@JsonKey(includeFromJson: false, includeToJson: false) List<String> imageUrls, bool showContact, String? telegramContactInfo, String? phoneNumberContactInfo, bool isMine
});




}
/// @nodoc
class _$LostFoundItemCopyWithImpl<$Res>
    implements $LostFoundItemCopyWith<$Res> {
  _$LostFoundItemCopyWithImpl(this._self, this._then);

  final LostFoundItem _self;
  final $Res Function(LostFoundItem) _then;

/// Create a copy of LostFoundItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? itemName = null,Object? status = null,Object? createdAt = null,Object? authorName = null,Object? description = freezed,Object? category = null,Object? location = null,Object? imagePaths = null,Object? imageUrls = null,Object? showContact = null,Object? telegramContactInfo = freezed,Object? phoneNumberContactInfo = freezed,Object? isMine = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LostFoundItemStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self.imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,showContact: null == showContact ? _self.showContact : showContact // ignore: cast_nullable_to_non_nullable
as bool,telegramContactInfo: freezed == telegramContactInfo ? _self.telegramContactInfo : telegramContactInfo // ignore: cast_nullable_to_non_nullable
as String?,phoneNumberContactInfo: freezed == phoneNumberContactInfo ? _self.phoneNumberContactInfo : phoneNumberContactInfo // ignore: cast_nullable_to_non_nullable
as String?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LostFoundItem].
extension LostFoundItemPatterns on LostFoundItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LostFoundItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LostFoundItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LostFoundItem value)  $default,){
final _that = this;
switch (_that) {
case _LostFoundItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LostFoundItem value)?  $default,){
final _that = this;
switch (_that) {
case _LostFoundItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  String itemName,  LostFoundItemStatus status,  DateTime createdAt,  String authorName,  String? description,  String category,  String location, @JsonKey(name: 'images')  List<String> imagePaths, @JsonKey(includeFromJson: false, includeToJson: false)  List<String> imageUrls,  bool showContact,  String? telegramContactInfo,  String? phoneNumberContactInfo,  bool isMine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LostFoundItem() when $default != null:
return $default(_that.id,_that.authorId,_that.itemName,_that.status,_that.createdAt,_that.authorName,_that.description,_that.category,_that.location,_that.imagePaths,_that.imageUrls,_that.showContact,_that.telegramContactInfo,_that.phoneNumberContactInfo,_that.isMine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  String itemName,  LostFoundItemStatus status,  DateTime createdAt,  String authorName,  String? description,  String category,  String location, @JsonKey(name: 'images')  List<String> imagePaths, @JsonKey(includeFromJson: false, includeToJson: false)  List<String> imageUrls,  bool showContact,  String? telegramContactInfo,  String? phoneNumberContactInfo,  bool isMine)  $default,) {final _that = this;
switch (_that) {
case _LostFoundItem():
return $default(_that.id,_that.authorId,_that.itemName,_that.status,_that.createdAt,_that.authorName,_that.description,_that.category,_that.location,_that.imagePaths,_that.imageUrls,_that.showContact,_that.telegramContactInfo,_that.phoneNumberContactInfo,_that.isMine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  String itemName,  LostFoundItemStatus status,  DateTime createdAt,  String authorName,  String? description,  String category,  String location, @JsonKey(name: 'images')  List<String> imagePaths, @JsonKey(includeFromJson: false, includeToJson: false)  List<String> imageUrls,  bool showContact,  String? telegramContactInfo,  String? phoneNumberContactInfo,  bool isMine)?  $default,) {final _that = this;
switch (_that) {
case _LostFoundItem() when $default != null:
return $default(_that.id,_that.authorId,_that.itemName,_that.status,_that.createdAt,_that.authorName,_that.description,_that.category,_that.location,_that.imagePaths,_that.imageUrls,_that.showContact,_that.telegramContactInfo,_that.phoneNumberContactInfo,_that.isMine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LostFoundItem extends LostFoundItem {
  const _LostFoundItem({required this.id, required this.authorId, required this.itemName, required this.status, required this.createdAt, this.authorName = '', this.description, this.category = 'other', this.location = '', @JsonKey(name: 'images') final  List<String> imagePaths = const <String>[], @JsonKey(includeFromJson: false, includeToJson: false) final  List<String> imageUrls = const <String>[], this.showContact = false, this.telegramContactInfo, this.phoneNumberContactInfo, this.isMine = false}): _imagePaths = imagePaths,_imageUrls = imageUrls,super._();
  factory _LostFoundItem.fromJson(Map<String, dynamic> json) => _$LostFoundItemFromJson(json);

@override final  String id;
@override final  String authorId;
@override final  String itemName;
@override final  LostFoundItemStatus status;
@override final  DateTime createdAt;
@override@JsonKey() final  String authorName;
@override final  String? description;
@override@JsonKey() final  String category;
@override@JsonKey() final  String location;
 final  List<String> _imagePaths;
@override@JsonKey(name: 'images') List<String> get imagePaths {
  if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imagePaths);
}

 final  List<String> _imageUrls;
@override@JsonKey(includeFromJson: false, includeToJson: false) List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  bool showContact;
@override final  String? telegramContactInfo;
@override final  String? phoneNumberContactInfo;
@override@JsonKey() final  bool isMine;

/// Create a copy of LostFoundItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LostFoundItemCopyWith<_LostFoundItem> get copyWith => __$LostFoundItemCopyWithImpl<_LostFoundItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LostFoundItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LostFoundItem&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._imagePaths, _imagePaths)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.showContact, showContact) || other.showContact == showContact)&&(identical(other.telegramContactInfo, telegramContactInfo) || other.telegramContactInfo == telegramContactInfo)&&(identical(other.phoneNumberContactInfo, phoneNumberContactInfo) || other.phoneNumberContactInfo == phoneNumberContactInfo)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorId,itemName,status,createdAt,authorName,description,category,location,const DeepCollectionEquality().hash(_imagePaths),const DeepCollectionEquality().hash(_imageUrls),showContact,telegramContactInfo,phoneNumberContactInfo,isMine);

@override
String toString() {
  return 'LostFoundItem(id: $id, authorId: $authorId, itemName: $itemName, status: $status, createdAt: $createdAt, authorName: $authorName, description: $description, category: $category, location: $location, imagePaths: $imagePaths, imageUrls: $imageUrls, showContact: $showContact, telegramContactInfo: $telegramContactInfo, phoneNumberContactInfo: $phoneNumberContactInfo, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class _$LostFoundItemCopyWith<$Res> implements $LostFoundItemCopyWith<$Res> {
  factory _$LostFoundItemCopyWith(_LostFoundItem value, $Res Function(_LostFoundItem) _then) = __$LostFoundItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, String itemName, LostFoundItemStatus status, DateTime createdAt, String authorName, String? description, String category, String location,@JsonKey(name: 'images') List<String> imagePaths,@JsonKey(includeFromJson: false, includeToJson: false) List<String> imageUrls, bool showContact, String? telegramContactInfo, String? phoneNumberContactInfo, bool isMine
});




}
/// @nodoc
class __$LostFoundItemCopyWithImpl<$Res>
    implements _$LostFoundItemCopyWith<$Res> {
  __$LostFoundItemCopyWithImpl(this._self, this._then);

  final _LostFoundItem _self;
  final $Res Function(_LostFoundItem) _then;

/// Create a copy of LostFoundItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? itemName = null,Object? status = null,Object? createdAt = null,Object? authorName = null,Object? description = freezed,Object? category = null,Object? location = null,Object? imagePaths = null,Object? imageUrls = null,Object? showContact = null,Object? telegramContactInfo = freezed,Object? phoneNumberContactInfo = freezed,Object? isMine = null,}) {
  return _then(_LostFoundItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LostFoundItemStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self._imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,showContact: null == showContact ? _self.showContact : showContact // ignore: cast_nullable_to_non_nullable
as bool,telegramContactInfo: freezed == telegramContactInfo ? _self.telegramContactInfo : telegramContactInfo // ignore: cast_nullable_to_non_nullable
as String?,phoneNumberContactInfo: freezed == phoneNumberContactInfo ? _self.phoneNumberContactInfo : phoneNumberContactInfo // ignore: cast_nullable_to_non_nullable
as String?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
