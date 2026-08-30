// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_app.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MiniApp {

 String get id; String get slug; String get name; String get description; String get iconEmoji; String? get iconUrl; String get accentColor;@JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) MiniAppCategory get category; List<String> get tags;@JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson) MiniAppSourceKind get sourceKind; String? get originUrl; String get entryPath;@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) MiniAppStatus get status; String? get reviewNotes; int get version; int get launchCount;@JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson) double get ratingAvg; int get ratingCount; String? get ownerId; bool get isOwner; bool get isFeatured; int? get myRating; bool get isHidden; bool get hasMyOpenReport; int? get openReportCount;@JsonKey(fromJson: MiniAppPermission.listFromJson, toJson: _permissionsToJson) List<MiniAppPermission> get requestedPermissions;@JsonKey(fromJson: _nullablePermissionsFromJson, toJson: _nullablePermissionsToJson) List<MiniAppPermission>? get grantedPermissions;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get createdAt;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get publishedAt;
/// Create a copy of MiniApp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppCopyWith<MiniApp> get copyWith => _$MiniAppCopyWithImpl<MiniApp>(this as MiniApp, _$identity);

  /// Serializes this MiniApp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniApp&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.accentColor, accentColor) || other.accentColor == accentColor)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.sourceKind, sourceKind) || other.sourceKind == sourceKind)&&(identical(other.originUrl, originUrl) || other.originUrl == originUrl)&&(identical(other.entryPath, entryPath) || other.entryPath == entryPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewNotes, reviewNotes) || other.reviewNotes == reviewNotes)&&(identical(other.version, version) || other.version == version)&&(identical(other.launchCount, launchCount) || other.launchCount == launchCount)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.myRating, myRating) || other.myRating == myRating)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.hasMyOpenReport, hasMyOpenReport) || other.hasMyOpenReport == hasMyOpenReport)&&(identical(other.openReportCount, openReportCount) || other.openReportCount == openReportCount)&&const DeepCollectionEquality().equals(other.requestedPermissions, requestedPermissions)&&const DeepCollectionEquality().equals(other.grantedPermissions, grantedPermissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,slug,name,description,iconEmoji,iconUrl,accentColor,category,const DeepCollectionEquality().hash(tags),sourceKind,originUrl,entryPath,status,reviewNotes,version,launchCount,ratingAvg,ratingCount,ownerId,isOwner,isFeatured,myRating,isHidden,hasMyOpenReport,openReportCount,const DeepCollectionEquality().hash(requestedPermissions),const DeepCollectionEquality().hash(grantedPermissions),createdAt,publishedAt]);

@override
String toString() {
  return 'MiniApp(id: $id, slug: $slug, name: $name, description: $description, iconEmoji: $iconEmoji, iconUrl: $iconUrl, accentColor: $accentColor, category: $category, tags: $tags, sourceKind: $sourceKind, originUrl: $originUrl, entryPath: $entryPath, status: $status, reviewNotes: $reviewNotes, version: $version, launchCount: $launchCount, ratingAvg: $ratingAvg, ratingCount: $ratingCount, ownerId: $ownerId, isOwner: $isOwner, isFeatured: $isFeatured, myRating: $myRating, isHidden: $isHidden, hasMyOpenReport: $hasMyOpenReport, openReportCount: $openReportCount, requestedPermissions: $requestedPermissions, grantedPermissions: $grantedPermissions, createdAt: $createdAt, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $MiniAppCopyWith<$Res>  {
  factory $MiniAppCopyWith(MiniApp value, $Res Function(MiniApp) _then) = _$MiniAppCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String description, String iconEmoji, String? iconUrl, String accentColor,@JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) MiniAppCategory category, List<String> tags,@JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson) MiniAppSourceKind sourceKind, String? originUrl, String entryPath,@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) MiniAppStatus status, String? reviewNotes, int version, int launchCount,@JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson) double ratingAvg, int ratingCount, String? ownerId, bool isOwner, bool isFeatured, int? myRating, bool isHidden, bool hasMyOpenReport, int? openReportCount,@JsonKey(fromJson: MiniAppPermission.listFromJson, toJson: _permissionsToJson) List<MiniAppPermission> requestedPermissions,@JsonKey(fromJson: _nullablePermissionsFromJson, toJson: _nullablePermissionsToJson) List<MiniAppPermission>? grantedPermissions,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? publishedAt
});




}
/// @nodoc
class _$MiniAppCopyWithImpl<$Res>
    implements $MiniAppCopyWith<$Res> {
  _$MiniAppCopyWithImpl(this._self, this._then);

  final MiniApp _self;
  final $Res Function(MiniApp) _then;

/// Create a copy of MiniApp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? description = null,Object? iconEmoji = null,Object? iconUrl = freezed,Object? accentColor = null,Object? category = null,Object? tags = null,Object? sourceKind = null,Object? originUrl = freezed,Object? entryPath = null,Object? status = null,Object? reviewNotes = freezed,Object? version = null,Object? launchCount = null,Object? ratingAvg = null,Object? ratingCount = null,Object? ownerId = freezed,Object? isOwner = null,Object? isFeatured = null,Object? myRating = freezed,Object? isHidden = null,Object? hasMyOpenReport = null,Object? openReportCount = freezed,Object? requestedPermissions = null,Object? grantedPermissions = freezed,Object? createdAt = freezed,Object? publishedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: null == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,accentColor: null == accentColor ? _self.accentColor : accentColor // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MiniAppCategory,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,sourceKind: null == sourceKind ? _self.sourceKind : sourceKind // ignore: cast_nullable_to_non_nullable
as MiniAppSourceKind,originUrl: freezed == originUrl ? _self.originUrl : originUrl // ignore: cast_nullable_to_non_nullable
as String?,entryPath: null == entryPath ? _self.entryPath : entryPath // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppStatus,reviewNotes: freezed == reviewNotes ? _self.reviewNotes : reviewNotes // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,launchCount: null == launchCount ? _self.launchCount : launchCount // ignore: cast_nullable_to_non_nullable
as int,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,myRating: freezed == myRating ? _self.myRating : myRating // ignore: cast_nullable_to_non_nullable
as int?,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,hasMyOpenReport: null == hasMyOpenReport ? _self.hasMyOpenReport : hasMyOpenReport // ignore: cast_nullable_to_non_nullable
as bool,openReportCount: freezed == openReportCount ? _self.openReportCount : openReportCount // ignore: cast_nullable_to_non_nullable
as int?,requestedPermissions: null == requestedPermissions ? _self.requestedPermissions : requestedPermissions // ignore: cast_nullable_to_non_nullable
as List<MiniAppPermission>,grantedPermissions: freezed == grantedPermissions ? _self.grantedPermissions : grantedPermissions // ignore: cast_nullable_to_non_nullable
as List<MiniAppPermission>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniApp].
extension MiniAppPatterns on MiniApp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniApp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniApp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniApp value)  $default,){
final _that = this;
switch (_that) {
case _MiniApp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniApp value)?  $default,){
final _that = this;
switch (_that) {
case _MiniApp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String description,  String iconEmoji,  String? iconUrl,  String accentColor, @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)  MiniAppCategory category,  List<String> tags, @JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson)  MiniAppSourceKind sourceKind,  String? originUrl,  String entryPath, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  MiniAppStatus status,  String? reviewNotes,  int version,  int launchCount, @JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson)  double ratingAvg,  int ratingCount,  String? ownerId,  bool isOwner,  bool isFeatured,  int? myRating,  bool isHidden,  bool hasMyOpenReport,  int? openReportCount, @JsonKey(fromJson: MiniAppPermission.listFromJson, toJson: _permissionsToJson)  List<MiniAppPermission> requestedPermissions, @JsonKey(fromJson: _nullablePermissionsFromJson, toJson: _nullablePermissionsToJson)  List<MiniAppPermission>? grantedPermissions, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniApp() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.description,_that.iconEmoji,_that.iconUrl,_that.accentColor,_that.category,_that.tags,_that.sourceKind,_that.originUrl,_that.entryPath,_that.status,_that.reviewNotes,_that.version,_that.launchCount,_that.ratingAvg,_that.ratingCount,_that.ownerId,_that.isOwner,_that.isFeatured,_that.myRating,_that.isHidden,_that.hasMyOpenReport,_that.openReportCount,_that.requestedPermissions,_that.grantedPermissions,_that.createdAt,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String description,  String iconEmoji,  String? iconUrl,  String accentColor, @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)  MiniAppCategory category,  List<String> tags, @JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson)  MiniAppSourceKind sourceKind,  String? originUrl,  String entryPath, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  MiniAppStatus status,  String? reviewNotes,  int version,  int launchCount, @JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson)  double ratingAvg,  int ratingCount,  String? ownerId,  bool isOwner,  bool isFeatured,  int? myRating,  bool isHidden,  bool hasMyOpenReport,  int? openReportCount, @JsonKey(fromJson: MiniAppPermission.listFromJson, toJson: _permissionsToJson)  List<MiniAppPermission> requestedPermissions, @JsonKey(fromJson: _nullablePermissionsFromJson, toJson: _nullablePermissionsToJson)  List<MiniAppPermission>? grantedPermissions, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _MiniApp():
return $default(_that.id,_that.slug,_that.name,_that.description,_that.iconEmoji,_that.iconUrl,_that.accentColor,_that.category,_that.tags,_that.sourceKind,_that.originUrl,_that.entryPath,_that.status,_that.reviewNotes,_that.version,_that.launchCount,_that.ratingAvg,_that.ratingCount,_that.ownerId,_that.isOwner,_that.isFeatured,_that.myRating,_that.isHidden,_that.hasMyOpenReport,_that.openReportCount,_that.requestedPermissions,_that.grantedPermissions,_that.createdAt,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String description,  String iconEmoji,  String? iconUrl,  String accentColor, @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)  MiniAppCategory category,  List<String> tags, @JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson)  MiniAppSourceKind sourceKind,  String? originUrl,  String entryPath, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  MiniAppStatus status,  String? reviewNotes,  int version,  int launchCount, @JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson)  double ratingAvg,  int ratingCount,  String? ownerId,  bool isOwner,  bool isFeatured,  int? myRating,  bool isHidden,  bool hasMyOpenReport,  int? openReportCount, @JsonKey(fromJson: MiniAppPermission.listFromJson, toJson: _permissionsToJson)  List<MiniAppPermission> requestedPermissions, @JsonKey(fromJson: _nullablePermissionsFromJson, toJson: _nullablePermissionsToJson)  List<MiniAppPermission>? grantedPermissions, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _MiniApp() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.description,_that.iconEmoji,_that.iconUrl,_that.accentColor,_that.category,_that.tags,_that.sourceKind,_that.originUrl,_that.entryPath,_that.status,_that.reviewNotes,_that.version,_that.launchCount,_that.ratingAvg,_that.ratingCount,_that.ownerId,_that.isOwner,_that.isFeatured,_that.myRating,_that.isHidden,_that.hasMyOpenReport,_that.openReportCount,_that.requestedPermissions,_that.grantedPermissions,_that.createdAt,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiniApp extends MiniApp {
  const _MiniApp({required this.id, required this.slug, required this.name, this.description = '', this.iconEmoji = '🧩', this.iconUrl, this.accentColor = '#7C5CFF', @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) this.category = MiniAppCategory.other, final  List<String> tags = const <String>[], @JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson) this.sourceKind = MiniAppSourceKind.hosted, this.originUrl, this.entryPath = '/', @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) this.status = MiniAppStatus.draft, this.reviewNotes, this.version = 1, this.launchCount = 0, @JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson) this.ratingAvg = 0, this.ratingCount = 0, this.ownerId, this.isOwner = false, this.isFeatured = false, this.myRating, this.isHidden = false, this.hasMyOpenReport = false, this.openReportCount, @JsonKey(fromJson: MiniAppPermission.listFromJson, toJson: _permissionsToJson) final  List<MiniAppPermission> requestedPermissions = const <MiniAppPermission>[], @JsonKey(fromJson: _nullablePermissionsFromJson, toJson: _nullablePermissionsToJson) final  List<MiniAppPermission>? grantedPermissions, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.publishedAt}): _tags = tags,_requestedPermissions = requestedPermissions,_grantedPermissions = grantedPermissions,super._();
  factory _MiniApp.fromJson(Map<String, dynamic> json) => _$MiniAppFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String iconEmoji;
@override final  String? iconUrl;
@override@JsonKey() final  String accentColor;
@override@JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) final  MiniAppCategory category;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson) final  MiniAppSourceKind sourceKind;
@override final  String? originUrl;
@override@JsonKey() final  String entryPath;
@override@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) final  MiniAppStatus status;
@override final  String? reviewNotes;
@override@JsonKey() final  int version;
@override@JsonKey() final  int launchCount;
@override@JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson) final  double ratingAvg;
@override@JsonKey() final  int ratingCount;
@override final  String? ownerId;
@override@JsonKey() final  bool isOwner;
@override@JsonKey() final  bool isFeatured;
@override final  int? myRating;
@override@JsonKey() final  bool isHidden;
@override@JsonKey() final  bool hasMyOpenReport;
@override final  int? openReportCount;
 final  List<MiniAppPermission> _requestedPermissions;
@override@JsonKey(fromJson: MiniAppPermission.listFromJson, toJson: _permissionsToJson) List<MiniAppPermission> get requestedPermissions {
  if (_requestedPermissions is EqualUnmodifiableListView) return _requestedPermissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requestedPermissions);
}

 final  List<MiniAppPermission>? _grantedPermissions;
@override@JsonKey(fromJson: _nullablePermissionsFromJson, toJson: _nullablePermissionsToJson) List<MiniAppPermission>? get grantedPermissions {
  final value = _grantedPermissions;
  if (value == null) return null;
  if (_grantedPermissions is EqualUnmodifiableListView) return _grantedPermissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? publishedAt;

/// Create a copy of MiniApp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppCopyWith<_MiniApp> get copyWith => __$MiniAppCopyWithImpl<_MiniApp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiniAppToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniApp&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.accentColor, accentColor) || other.accentColor == accentColor)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.sourceKind, sourceKind) || other.sourceKind == sourceKind)&&(identical(other.originUrl, originUrl) || other.originUrl == originUrl)&&(identical(other.entryPath, entryPath) || other.entryPath == entryPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewNotes, reviewNotes) || other.reviewNotes == reviewNotes)&&(identical(other.version, version) || other.version == version)&&(identical(other.launchCount, launchCount) || other.launchCount == launchCount)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.myRating, myRating) || other.myRating == myRating)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.hasMyOpenReport, hasMyOpenReport) || other.hasMyOpenReport == hasMyOpenReport)&&(identical(other.openReportCount, openReportCount) || other.openReportCount == openReportCount)&&const DeepCollectionEquality().equals(other._requestedPermissions, _requestedPermissions)&&const DeepCollectionEquality().equals(other._grantedPermissions, _grantedPermissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,slug,name,description,iconEmoji,iconUrl,accentColor,category,const DeepCollectionEquality().hash(_tags),sourceKind,originUrl,entryPath,status,reviewNotes,version,launchCount,ratingAvg,ratingCount,ownerId,isOwner,isFeatured,myRating,isHidden,hasMyOpenReport,openReportCount,const DeepCollectionEquality().hash(_requestedPermissions),const DeepCollectionEquality().hash(_grantedPermissions),createdAt,publishedAt]);

@override
String toString() {
  return 'MiniApp(id: $id, slug: $slug, name: $name, description: $description, iconEmoji: $iconEmoji, iconUrl: $iconUrl, accentColor: $accentColor, category: $category, tags: $tags, sourceKind: $sourceKind, originUrl: $originUrl, entryPath: $entryPath, status: $status, reviewNotes: $reviewNotes, version: $version, launchCount: $launchCount, ratingAvg: $ratingAvg, ratingCount: $ratingCount, ownerId: $ownerId, isOwner: $isOwner, isFeatured: $isFeatured, myRating: $myRating, isHidden: $isHidden, hasMyOpenReport: $hasMyOpenReport, openReportCount: $openReportCount, requestedPermissions: $requestedPermissions, grantedPermissions: $grantedPermissions, createdAt: $createdAt, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$MiniAppCopyWith<$Res> implements $MiniAppCopyWith<$Res> {
  factory _$MiniAppCopyWith(_MiniApp value, $Res Function(_MiniApp) _then) = __$MiniAppCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String description, String iconEmoji, String? iconUrl, String accentColor,@JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson) MiniAppCategory category, List<String> tags,@JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson) MiniAppSourceKind sourceKind, String? originUrl, String entryPath,@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) MiniAppStatus status, String? reviewNotes, int version, int launchCount,@JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson) double ratingAvg, int ratingCount, String? ownerId, bool isOwner, bool isFeatured, int? myRating, bool isHidden, bool hasMyOpenReport, int? openReportCount,@JsonKey(fromJson: MiniAppPermission.listFromJson, toJson: _permissionsToJson) List<MiniAppPermission> requestedPermissions,@JsonKey(fromJson: _nullablePermissionsFromJson, toJson: _nullablePermissionsToJson) List<MiniAppPermission>? grantedPermissions,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? publishedAt
});




}
/// @nodoc
class __$MiniAppCopyWithImpl<$Res>
    implements _$MiniAppCopyWith<$Res> {
  __$MiniAppCopyWithImpl(this._self, this._then);

  final _MiniApp _self;
  final $Res Function(_MiniApp) _then;

/// Create a copy of MiniApp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? description = null,Object? iconEmoji = null,Object? iconUrl = freezed,Object? accentColor = null,Object? category = null,Object? tags = null,Object? sourceKind = null,Object? originUrl = freezed,Object? entryPath = null,Object? status = null,Object? reviewNotes = freezed,Object? version = null,Object? launchCount = null,Object? ratingAvg = null,Object? ratingCount = null,Object? ownerId = freezed,Object? isOwner = null,Object? isFeatured = null,Object? myRating = freezed,Object? isHidden = null,Object? hasMyOpenReport = null,Object? openReportCount = freezed,Object? requestedPermissions = null,Object? grantedPermissions = freezed,Object? createdAt = freezed,Object? publishedAt = freezed,}) {
  return _then(_MiniApp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: null == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,accentColor: null == accentColor ? _self.accentColor : accentColor // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MiniAppCategory,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,sourceKind: null == sourceKind ? _self.sourceKind : sourceKind // ignore: cast_nullable_to_non_nullable
as MiniAppSourceKind,originUrl: freezed == originUrl ? _self.originUrl : originUrl // ignore: cast_nullable_to_non_nullable
as String?,entryPath: null == entryPath ? _self.entryPath : entryPath // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppStatus,reviewNotes: freezed == reviewNotes ? _self.reviewNotes : reviewNotes // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,launchCount: null == launchCount ? _self.launchCount : launchCount // ignore: cast_nullable_to_non_nullable
as int,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,myRating: freezed == myRating ? _self.myRating : myRating // ignore: cast_nullable_to_non_nullable
as int?,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,hasMyOpenReport: null == hasMyOpenReport ? _self.hasMyOpenReport : hasMyOpenReport // ignore: cast_nullable_to_non_nullable
as bool,openReportCount: freezed == openReportCount ? _self.openReportCount : openReportCount // ignore: cast_nullable_to_non_nullable
as int?,requestedPermissions: null == requestedPermissions ? _self._requestedPermissions : requestedPermissions // ignore: cast_nullable_to_non_nullable
as List<MiniAppPermission>,grantedPermissions: freezed == grantedPermissions ? _self._grantedPermissions : grantedPermissions // ignore: cast_nullable_to_non_nullable
as List<MiniAppPermission>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
