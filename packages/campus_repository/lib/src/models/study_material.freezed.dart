// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_material.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyMaterial {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get title; String get subjectName; List<String> get subjectNames; String get materialType; int get downloads; int get likes; int get price; int get pages; String get authorName; String get fileName; String get mimeType; int get fileSize; bool get hasFile; bool get requiresRepublish; bool get isMine;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt; String? get previewPath; String? get batchId; int? get width; int? get height; int? get durationSeconds; bool get isLiked;
/// Create a copy of StudyMaterial
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyMaterialCopyWith<StudyMaterial> get copyWith => _$StudyMaterialCopyWithImpl<StudyMaterial>(this as StudyMaterial, _$identity);

  /// Serializes this StudyMaterial to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyMaterial&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&const DeepCollectionEquality().equals(other.subjectNames, subjectNames)&&(identical(other.materialType, materialType) || other.materialType == materialType)&&(identical(other.downloads, downloads) || other.downloads == downloads)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.price, price) || other.price == price)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.requiresRepublish, requiresRepublish) || other.requiresRepublish == requiresRepublish)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,subjectName,const DeepCollectionEquality().hash(subjectNames),materialType,downloads,likes,price,pages,authorName,fileName,mimeType,fileSize,hasFile,requiresRepublish,isMine,createdAt,previewPath,batchId,width,height,durationSeconds,isLiked]);

@override
String toString() {
  return 'StudyMaterial(id: $id, title: $title, subjectName: $subjectName, subjectNames: $subjectNames, materialType: $materialType, downloads: $downloads, likes: $likes, price: $price, pages: $pages, authorName: $authorName, fileName: $fileName, mimeType: $mimeType, fileSize: $fileSize, hasFile: $hasFile, requiresRepublish: $requiresRepublish, isMine: $isMine, createdAt: $createdAt, previewPath: $previewPath, batchId: $batchId, width: $width, height: $height, durationSeconds: $durationSeconds, isLiked: $isLiked)';
}


}

/// @nodoc
abstract mixin class $StudyMaterialCopyWith<$Res>  {
  factory $StudyMaterialCopyWith(StudyMaterial value, $Res Function(StudyMaterial) _then) = _$StudyMaterialCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title, String subjectName, List<String> subjectNames, String materialType, int downloads, int likes, int price, int pages, String authorName, String fileName, String mimeType, int fileSize, bool hasFile, bool requiresRepublish, bool isMine,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, String? previewPath, String? batchId, int? width, int? height, int? durationSeconds, bool isLiked
});




}
/// @nodoc
class _$StudyMaterialCopyWithImpl<$Res>
    implements $StudyMaterialCopyWith<$Res> {
  _$StudyMaterialCopyWithImpl(this._self, this._then);

  final StudyMaterial _self;
  final $Res Function(StudyMaterial) _then;

/// Create a copy of StudyMaterial
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subjectName = null,Object? subjectNames = null,Object? materialType = null,Object? downloads = null,Object? likes = null,Object? price = null,Object? pages = null,Object? authorName = null,Object? fileName = null,Object? mimeType = null,Object? fileSize = null,Object? hasFile = null,Object? requiresRepublish = null,Object? isMine = null,Object? createdAt = freezed,Object? previewPath = freezed,Object? batchId = freezed,Object? width = freezed,Object? height = freezed,Object? durationSeconds = freezed,Object? isLiked = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,subjectNames: null == subjectNames ? _self.subjectNames : subjectNames // ignore: cast_nullable_to_non_nullable
as List<String>,materialType: null == materialType ? _self.materialType : materialType // ignore: cast_nullable_to_non_nullable
as String,downloads: null == downloads ? _self.downloads : downloads // ignore: cast_nullable_to_non_nullable
as int,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,requiresRepublish: null == requiresRepublish ? _self.requiresRepublish : requiresRepublish // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyMaterial].
extension StudyMaterialPatterns on StudyMaterial {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyMaterial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyMaterial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyMaterial value)  $default,){
final _that = this;
switch (_that) {
case _StudyMaterial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyMaterial value)?  $default,){
final _that = this;
switch (_that) {
case _StudyMaterial() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String subjectName,  List<String> subjectNames,  String materialType,  int downloads,  int likes,  int price,  int pages,  String authorName,  String fileName,  String mimeType,  int fileSize,  bool hasFile,  bool requiresRepublish,  bool isMine, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  String? previewPath,  String? batchId,  int? width,  int? height,  int? durationSeconds,  bool isLiked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyMaterial() when $default != null:
return $default(_that.id,_that.title,_that.subjectName,_that.subjectNames,_that.materialType,_that.downloads,_that.likes,_that.price,_that.pages,_that.authorName,_that.fileName,_that.mimeType,_that.fileSize,_that.hasFile,_that.requiresRepublish,_that.isMine,_that.createdAt,_that.previewPath,_that.batchId,_that.width,_that.height,_that.durationSeconds,_that.isLiked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String subjectName,  List<String> subjectNames,  String materialType,  int downloads,  int likes,  int price,  int pages,  String authorName,  String fileName,  String mimeType,  int fileSize,  bool hasFile,  bool requiresRepublish,  bool isMine, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  String? previewPath,  String? batchId,  int? width,  int? height,  int? durationSeconds,  bool isLiked)  $default,) {final _that = this;
switch (_that) {
case _StudyMaterial():
return $default(_that.id,_that.title,_that.subjectName,_that.subjectNames,_that.materialType,_that.downloads,_that.likes,_that.price,_that.pages,_that.authorName,_that.fileName,_that.mimeType,_that.fileSize,_that.hasFile,_that.requiresRepublish,_that.isMine,_that.createdAt,_that.previewPath,_that.batchId,_that.width,_that.height,_that.durationSeconds,_that.isLiked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String subjectName,  List<String> subjectNames,  String materialType,  int downloads,  int likes,  int price,  int pages,  String authorName,  String fileName,  String mimeType,  int fileSize,  bool hasFile,  bool requiresRepublish,  bool isMine, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  String? previewPath,  String? batchId,  int? width,  int? height,  int? durationSeconds,  bool isLiked)?  $default,) {final _that = this;
switch (_that) {
case _StudyMaterial() when $default != null:
return $default(_that.id,_that.title,_that.subjectName,_that.subjectNames,_that.materialType,_that.downloads,_that.likes,_that.price,_that.pages,_that.authorName,_that.fileName,_that.mimeType,_that.fileSize,_that.hasFile,_that.requiresRepublish,_that.isMine,_that.createdAt,_that.previewPath,_that.batchId,_that.width,_that.height,_that.durationSeconds,_that.isLiked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyMaterial extends StudyMaterial {
  const _StudyMaterial({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.title, this.subjectName = '', final  List<String> subjectNames = const <String>[], this.materialType = 'note', this.downloads = 0, this.likes = 0, this.price = 0, this.pages = 0, this.authorName = '', this.fileName = '', this.mimeType = '', this.fileSize = 0, this.hasFile = false, this.requiresRepublish = false, this.isMine = false, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt, this.previewPath, this.batchId, this.width, this.height, this.durationSeconds, this.isLiked = false}): _subjectNames = subjectNames,super._();
  factory _StudyMaterial.fromJson(Map<String, dynamic> json) => _$StudyMaterialFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String title;
@override@JsonKey() final  String subjectName;
 final  List<String> _subjectNames;
@override@JsonKey() List<String> get subjectNames {
  if (_subjectNames is EqualUnmodifiableListView) return _subjectNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjectNames);
}

@override@JsonKey() final  String materialType;
@override@JsonKey() final  int downloads;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int price;
@override@JsonKey() final  int pages;
@override@JsonKey() final  String authorName;
@override@JsonKey() final  String fileName;
@override@JsonKey() final  String mimeType;
@override@JsonKey() final  int fileSize;
@override@JsonKey() final  bool hasFile;
@override@JsonKey() final  bool requiresRepublish;
@override@JsonKey() final  bool isMine;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;
@override final  String? previewPath;
@override final  String? batchId;
@override final  int? width;
@override final  int? height;
@override final  int? durationSeconds;
@override@JsonKey() final  bool isLiked;

/// Create a copy of StudyMaterial
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyMaterialCopyWith<_StudyMaterial> get copyWith => __$StudyMaterialCopyWithImpl<_StudyMaterial>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyMaterialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyMaterial&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&const DeepCollectionEquality().equals(other._subjectNames, _subjectNames)&&(identical(other.materialType, materialType) || other.materialType == materialType)&&(identical(other.downloads, downloads) || other.downloads == downloads)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.price, price) || other.price == price)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.requiresRepublish, requiresRepublish) || other.requiresRepublish == requiresRepublish)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,subjectName,const DeepCollectionEquality().hash(_subjectNames),materialType,downloads,likes,price,pages,authorName,fileName,mimeType,fileSize,hasFile,requiresRepublish,isMine,createdAt,previewPath,batchId,width,height,durationSeconds,isLiked]);

@override
String toString() {
  return 'StudyMaterial(id: $id, title: $title, subjectName: $subjectName, subjectNames: $subjectNames, materialType: $materialType, downloads: $downloads, likes: $likes, price: $price, pages: $pages, authorName: $authorName, fileName: $fileName, mimeType: $mimeType, fileSize: $fileSize, hasFile: $hasFile, requiresRepublish: $requiresRepublish, isMine: $isMine, createdAt: $createdAt, previewPath: $previewPath, batchId: $batchId, width: $width, height: $height, durationSeconds: $durationSeconds, isLiked: $isLiked)';
}


}

/// @nodoc
abstract mixin class _$StudyMaterialCopyWith<$Res> implements $StudyMaterialCopyWith<$Res> {
  factory _$StudyMaterialCopyWith(_StudyMaterial value, $Res Function(_StudyMaterial) _then) = __$StudyMaterialCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title, String subjectName, List<String> subjectNames, String materialType, int downloads, int likes, int price, int pages, String authorName, String fileName, String mimeType, int fileSize, bool hasFile, bool requiresRepublish, bool isMine,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, String? previewPath, String? batchId, int? width, int? height, int? durationSeconds, bool isLiked
});




}
/// @nodoc
class __$StudyMaterialCopyWithImpl<$Res>
    implements _$StudyMaterialCopyWith<$Res> {
  __$StudyMaterialCopyWithImpl(this._self, this._then);

  final _StudyMaterial _self;
  final $Res Function(_StudyMaterial) _then;

/// Create a copy of StudyMaterial
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subjectName = null,Object? subjectNames = null,Object? materialType = null,Object? downloads = null,Object? likes = null,Object? price = null,Object? pages = null,Object? authorName = null,Object? fileName = null,Object? mimeType = null,Object? fileSize = null,Object? hasFile = null,Object? requiresRepublish = null,Object? isMine = null,Object? createdAt = freezed,Object? previewPath = freezed,Object? batchId = freezed,Object? width = freezed,Object? height = freezed,Object? durationSeconds = freezed,Object? isLiked = null,}) {
  return _then(_StudyMaterial(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,subjectNames: null == subjectNames ? _self._subjectNames : subjectNames // ignore: cast_nullable_to_non_nullable
as List<String>,materialType: null == materialType ? _self.materialType : materialType // ignore: cast_nullable_to_non_nullable
as String,downloads: null == downloads ? _self.downloads : downloads // ignore: cast_nullable_to_non_nullable
as int,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,requiresRepublish: null == requiresRepublish ? _self.requiresRepublish : requiresRepublish // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MaterialAuthor {

@JsonKey(defaultValue: '') String get name; int get downloads; int get materials;
/// Create a copy of MaterialAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialAuthorCopyWith<MaterialAuthor> get copyWith => _$MaterialAuthorCopyWithImpl<MaterialAuthor>(this as MaterialAuthor, _$identity);

  /// Serializes this MaterialAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialAuthor&&(identical(other.name, name) || other.name == name)&&(identical(other.downloads, downloads) || other.downloads == downloads)&&(identical(other.materials, materials) || other.materials == materials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,downloads,materials);

@override
String toString() {
  return 'MaterialAuthor(name: $name, downloads: $downloads, materials: $materials)';
}


}

/// @nodoc
abstract mixin class $MaterialAuthorCopyWith<$Res>  {
  factory $MaterialAuthorCopyWith(MaterialAuthor value, $Res Function(MaterialAuthor) _then) = _$MaterialAuthorCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String name, int downloads, int materials
});




}
/// @nodoc
class _$MaterialAuthorCopyWithImpl<$Res>
    implements $MaterialAuthorCopyWith<$Res> {
  _$MaterialAuthorCopyWithImpl(this._self, this._then);

  final MaterialAuthor _self;
  final $Res Function(MaterialAuthor) _then;

/// Create a copy of MaterialAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? downloads = null,Object? materials = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,downloads: null == downloads ? _self.downloads : downloads // ignore: cast_nullable_to_non_nullable
as int,materials: null == materials ? _self.materials : materials // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MaterialAuthor].
extension MaterialAuthorPatterns on MaterialAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialAuthor value)  $default,){
final _that = this;
switch (_that) {
case _MaterialAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String name,  int downloads,  int materials)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialAuthor() when $default != null:
return $default(_that.name,_that.downloads,_that.materials);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String name,  int downloads,  int materials)  $default,) {final _that = this;
switch (_that) {
case _MaterialAuthor():
return $default(_that.name,_that.downloads,_that.materials);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String name,  int downloads,  int materials)?  $default,) {final _that = this;
switch (_that) {
case _MaterialAuthor() when $default != null:
return $default(_that.name,_that.downloads,_that.materials);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaterialAuthor implements MaterialAuthor {
  const _MaterialAuthor({@JsonKey(defaultValue: '') required this.name, this.downloads = 0, this.materials = 0});
  factory _MaterialAuthor.fromJson(Map<String, dynamic> json) => _$MaterialAuthorFromJson(json);

@override@JsonKey(defaultValue: '') final  String name;
@override@JsonKey() final  int downloads;
@override@JsonKey() final  int materials;

/// Create a copy of MaterialAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialAuthorCopyWith<_MaterialAuthor> get copyWith => __$MaterialAuthorCopyWithImpl<_MaterialAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialAuthor&&(identical(other.name, name) || other.name == name)&&(identical(other.downloads, downloads) || other.downloads == downloads)&&(identical(other.materials, materials) || other.materials == materials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,downloads,materials);

@override
String toString() {
  return 'MaterialAuthor(name: $name, downloads: $downloads, materials: $materials)';
}


}

/// @nodoc
abstract mixin class _$MaterialAuthorCopyWith<$Res> implements $MaterialAuthorCopyWith<$Res> {
  factory _$MaterialAuthorCopyWith(_MaterialAuthor value, $Res Function(_MaterialAuthor) _then) = __$MaterialAuthorCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String name, int downloads, int materials
});




}
/// @nodoc
class __$MaterialAuthorCopyWithImpl<$Res>
    implements _$MaterialAuthorCopyWith<$Res> {
  __$MaterialAuthorCopyWithImpl(this._self, this._then);

  final _MaterialAuthor _self;
  final $Res Function(_MaterialAuthor) _then;

/// Create a copy of MaterialAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? downloads = null,Object? materials = null,}) {
  return _then(_MaterialAuthor(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,downloads: null == downloads ? _self.downloads : downloads // ignore: cast_nullable_to_non_nullable
as int,materials: null == materials ? _self.materials : materials // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
