// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_catalog_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceCatalogEntry {

 String get id; String get slug; String get title; String get description; String get url; String get iconKey; String get colorKey; int get sortOrder; String? get emoji;
/// Create a copy of ServiceCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCatalogEntryCopyWith<ServiceCatalogEntry> get copyWith => _$ServiceCatalogEntryCopyWithImpl<ServiceCatalogEntry>(this as ServiceCatalogEntry, _$identity);

  /// Serializes this ServiceCatalogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceCatalogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,description,url,iconKey,colorKey,sortOrder,emoji);

@override
String toString() {
  return 'ServiceCatalogEntry(id: $id, slug: $slug, title: $title, description: $description, url: $url, iconKey: $iconKey, colorKey: $colorKey, sortOrder: $sortOrder, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $ServiceCatalogEntryCopyWith<$Res>  {
  factory $ServiceCatalogEntryCopyWith(ServiceCatalogEntry value, $Res Function(ServiceCatalogEntry) _then) = _$ServiceCatalogEntryCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, String description, String url, String iconKey, String colorKey, int sortOrder, String? emoji
});




}
/// @nodoc
class _$ServiceCatalogEntryCopyWithImpl<$Res>
    implements $ServiceCatalogEntryCopyWith<$Res> {
  _$ServiceCatalogEntryCopyWithImpl(this._self, this._then);

  final ServiceCatalogEntry _self;
  final $Res Function(ServiceCatalogEntry) _then;

/// Create a copy of ServiceCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? description = null,Object? url = null,Object? iconKey = null,Object? colorKey = null,Object? sortOrder = null,Object? emoji = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceCatalogEntry].
extension ServiceCatalogEntryPatterns on ServiceCatalogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceCatalogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceCatalogEntry value)  $default,){
final _that = this;
switch (_that) {
case _ServiceCatalogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceCatalogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String description,  String url,  String iconKey,  String colorKey,  int sortOrder,  String? emoji)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceCatalogEntry() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.description,_that.url,_that.iconKey,_that.colorKey,_that.sortOrder,_that.emoji);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String description,  String url,  String iconKey,  String colorKey,  int sortOrder,  String? emoji)  $default,) {final _that = this;
switch (_that) {
case _ServiceCatalogEntry():
return $default(_that.id,_that.slug,_that.title,_that.description,_that.url,_that.iconKey,_that.colorKey,_that.sortOrder,_that.emoji);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  String description,  String url,  String iconKey,  String colorKey,  int sortOrder,  String? emoji)?  $default,) {final _that = this;
switch (_that) {
case _ServiceCatalogEntry() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.description,_that.url,_that.iconKey,_that.colorKey,_that.sortOrder,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceCatalogEntry implements ServiceCatalogEntry {
  const _ServiceCatalogEntry({required this.id, required this.slug, required this.title, required this.description, required this.url, required this.iconKey, required this.colorKey, required this.sortOrder, this.emoji});
  factory _ServiceCatalogEntry.fromJson(Map<String, dynamic> json) => _$ServiceCatalogEntryFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
@override final  String description;
@override final  String url;
@override final  String iconKey;
@override final  String colorKey;
@override final  int sortOrder;
@override final  String? emoji;

/// Create a copy of ServiceCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCatalogEntryCopyWith<_ServiceCatalogEntry> get copyWith => __$ServiceCatalogEntryCopyWithImpl<_ServiceCatalogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceCatalogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceCatalogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,description,url,iconKey,colorKey,sortOrder,emoji);

@override
String toString() {
  return 'ServiceCatalogEntry(id: $id, slug: $slug, title: $title, description: $description, url: $url, iconKey: $iconKey, colorKey: $colorKey, sortOrder: $sortOrder, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$ServiceCatalogEntryCopyWith<$Res> implements $ServiceCatalogEntryCopyWith<$Res> {
  factory _$ServiceCatalogEntryCopyWith(_ServiceCatalogEntry value, $Res Function(_ServiceCatalogEntry) _then) = __$ServiceCatalogEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, String description, String url, String iconKey, String colorKey, int sortOrder, String? emoji
});




}
/// @nodoc
class __$ServiceCatalogEntryCopyWithImpl<$Res>
    implements _$ServiceCatalogEntryCopyWith<$Res> {
  __$ServiceCatalogEntryCopyWithImpl(this._self, this._then);

  final _ServiceCatalogEntry _self;
  final $Res Function(_ServiceCatalogEntry) _then;

/// Create a copy of ServiceCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? description = null,Object? url = null,Object? iconKey = null,Object? colorKey = null,Object? sortOrder = null,Object? emoji = freezed,}) {
  return _then(_ServiceCatalogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
