// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_catalog_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommunityCatalogEntry {

 String get id; String get slug; String get title; String get description; String get url; String get platform; String? get logoUrl; int? get membersCount; DateTime? get membersCountUpdatedAt; bool get isFeatured; bool get isOfficial; int get sortOrder;
/// Create a copy of CommunityCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityCatalogEntryCopyWith<CommunityCatalogEntry> get copyWith => _$CommunityCatalogEntryCopyWithImpl<CommunityCatalogEntry>(this as CommunityCatalogEntry, _$identity);

  /// Serializes this CommunityCatalogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityCatalogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.membersCountUpdatedAt, membersCountUpdatedAt) || other.membersCountUpdatedAt == membersCountUpdatedAt)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,description,url,platform,logoUrl,membersCount,membersCountUpdatedAt,isFeatured,isOfficial,sortOrder);

@override
String toString() {
  return 'CommunityCatalogEntry(id: $id, slug: $slug, title: $title, description: $description, url: $url, platform: $platform, logoUrl: $logoUrl, membersCount: $membersCount, membersCountUpdatedAt: $membersCountUpdatedAt, isFeatured: $isFeatured, isOfficial: $isOfficial, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $CommunityCatalogEntryCopyWith<$Res>  {
  factory $CommunityCatalogEntryCopyWith(CommunityCatalogEntry value, $Res Function(CommunityCatalogEntry) _then) = _$CommunityCatalogEntryCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, String description, String url, String platform, String? logoUrl, int? membersCount, DateTime? membersCountUpdatedAt, bool isFeatured, bool isOfficial, int sortOrder
});




}
/// @nodoc
class _$CommunityCatalogEntryCopyWithImpl<$Res>
    implements $CommunityCatalogEntryCopyWith<$Res> {
  _$CommunityCatalogEntryCopyWithImpl(this._self, this._then);

  final CommunityCatalogEntry _self;
  final $Res Function(CommunityCatalogEntry) _then;

/// Create a copy of CommunityCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? description = null,Object? url = null,Object? platform = null,Object? logoUrl = freezed,Object? membersCount = freezed,Object? membersCountUpdatedAt = freezed,Object? isFeatured = null,Object? isOfficial = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,membersCount: freezed == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int?,membersCountUpdatedAt: freezed == membersCountUpdatedAt ? _self.membersCountUpdatedAt : membersCountUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityCatalogEntry].
extension CommunityCatalogEntryPatterns on CommunityCatalogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityCatalogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityCatalogEntry value)  $default,){
final _that = this;
switch (_that) {
case _CommunityCatalogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityCatalogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityCatalogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String description,  String url,  String platform,  String? logoUrl,  int? membersCount,  DateTime? membersCountUpdatedAt,  bool isFeatured,  bool isOfficial,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityCatalogEntry() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.description,_that.url,_that.platform,_that.logoUrl,_that.membersCount,_that.membersCountUpdatedAt,_that.isFeatured,_that.isOfficial,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String description,  String url,  String platform,  String? logoUrl,  int? membersCount,  DateTime? membersCountUpdatedAt,  bool isFeatured,  bool isOfficial,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _CommunityCatalogEntry():
return $default(_that.id,_that.slug,_that.title,_that.description,_that.url,_that.platform,_that.logoUrl,_that.membersCount,_that.membersCountUpdatedAt,_that.isFeatured,_that.isOfficial,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  String description,  String url,  String platform,  String? logoUrl,  int? membersCount,  DateTime? membersCountUpdatedAt,  bool isFeatured,  bool isOfficial,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _CommunityCatalogEntry() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.description,_that.url,_that.platform,_that.logoUrl,_that.membersCount,_that.membersCountUpdatedAt,_that.isFeatured,_that.isOfficial,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommunityCatalogEntry extends CommunityCatalogEntry {
  const _CommunityCatalogEntry({required this.id, required this.slug, required this.title, required this.description, required this.url, required this.platform, this.logoUrl, this.membersCount, this.membersCountUpdatedAt, this.isFeatured = false, this.isOfficial = false, this.sortOrder = 0}): super._();
  factory _CommunityCatalogEntry.fromJson(Map<String, dynamic> json) => _$CommunityCatalogEntryFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
@override final  String description;
@override final  String url;
@override final  String platform;
@override final  String? logoUrl;
@override final  int? membersCount;
@override final  DateTime? membersCountUpdatedAt;
@override@JsonKey() final  bool isFeatured;
@override@JsonKey() final  bool isOfficial;
@override@JsonKey() final  int sortOrder;

/// Create a copy of CommunityCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityCatalogEntryCopyWith<_CommunityCatalogEntry> get copyWith => __$CommunityCatalogEntryCopyWithImpl<_CommunityCatalogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunityCatalogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityCatalogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.membersCountUpdatedAt, membersCountUpdatedAt) || other.membersCountUpdatedAt == membersCountUpdatedAt)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,description,url,platform,logoUrl,membersCount,membersCountUpdatedAt,isFeatured,isOfficial,sortOrder);

@override
String toString() {
  return 'CommunityCatalogEntry(id: $id, slug: $slug, title: $title, description: $description, url: $url, platform: $platform, logoUrl: $logoUrl, membersCount: $membersCount, membersCountUpdatedAt: $membersCountUpdatedAt, isFeatured: $isFeatured, isOfficial: $isOfficial, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$CommunityCatalogEntryCopyWith<$Res> implements $CommunityCatalogEntryCopyWith<$Res> {
  factory _$CommunityCatalogEntryCopyWith(_CommunityCatalogEntry value, $Res Function(_CommunityCatalogEntry) _then) = __$CommunityCatalogEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, String description, String url, String platform, String? logoUrl, int? membersCount, DateTime? membersCountUpdatedAt, bool isFeatured, bool isOfficial, int sortOrder
});




}
/// @nodoc
class __$CommunityCatalogEntryCopyWithImpl<$Res>
    implements _$CommunityCatalogEntryCopyWith<$Res> {
  __$CommunityCatalogEntryCopyWithImpl(this._self, this._then);

  final _CommunityCatalogEntry _self;
  final $Res Function(_CommunityCatalogEntry) _then;

/// Create a copy of CommunityCatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? description = null,Object? url = null,Object? platform = null,Object? logoUrl = freezed,Object? membersCount = freezed,Object? membersCountUpdatedAt = freezed,Object? isFeatured = null,Object? isOfficial = null,Object? sortOrder = null,}) {
  return _then(_CommunityCatalogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,membersCount: freezed == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int?,membersCountUpdatedAt: freezed == membersCountUpdatedAt ? _self.membersCountUpdatedAt : membersCountUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
