// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_material.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonMaterial {

 String get id; LessonMaterialType get type; String get title; String get fileName; String get filePath; int get fileSize; bool get isPublic; bool get isAnonymous; int get downloadCount; int get likeCount; String get authorName; DateTime get createdAt; String? get mimeType; String? get previewPath; String? get batchId; int? get width; int? get height; int? get durationSeconds; bool get isLiked;
/// Create a copy of LessonMaterial
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonMaterialCopyWith<LessonMaterial> get copyWith => _$LessonMaterialCopyWithImpl<LessonMaterial>(this as LessonMaterial, _$identity);

  /// Serializes this LessonMaterial to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonMaterial&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,fileName,filePath,fileSize,isPublic,isAnonymous,downloadCount,likeCount,authorName,createdAt,mimeType,previewPath,batchId,width,height,durationSeconds,isLiked);

@override
String toString() {
  return 'LessonMaterial(id: $id, type: $type, title: $title, fileName: $fileName, filePath: $filePath, fileSize: $fileSize, isPublic: $isPublic, isAnonymous: $isAnonymous, downloadCount: $downloadCount, likeCount: $likeCount, authorName: $authorName, createdAt: $createdAt, mimeType: $mimeType, previewPath: $previewPath, batchId: $batchId, width: $width, height: $height, durationSeconds: $durationSeconds, isLiked: $isLiked)';
}


}

/// @nodoc
abstract mixin class $LessonMaterialCopyWith<$Res>  {
  factory $LessonMaterialCopyWith(LessonMaterial value, $Res Function(LessonMaterial) _then) = _$LessonMaterialCopyWithImpl;
@useResult
$Res call({
 String id, LessonMaterialType type, String title, String fileName, String filePath, int fileSize, bool isPublic, bool isAnonymous, int downloadCount, int likeCount, String authorName, DateTime createdAt, String? mimeType, String? previewPath, String? batchId, int? width, int? height, int? durationSeconds, bool isLiked
});




}
/// @nodoc
class _$LessonMaterialCopyWithImpl<$Res>
    implements $LessonMaterialCopyWith<$Res> {
  _$LessonMaterialCopyWithImpl(this._self, this._then);

  final LessonMaterial _self;
  final $Res Function(LessonMaterial) _then;

/// Create a copy of LessonMaterial
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? fileName = null,Object? filePath = null,Object? fileSize = null,Object? isPublic = null,Object? isAnonymous = null,Object? downloadCount = null,Object? likeCount = null,Object? authorName = null,Object? createdAt = null,Object? mimeType = freezed,Object? previewPath = freezed,Object? batchId = freezed,Object? width = freezed,Object? height = freezed,Object? durationSeconds = freezed,Object? isLiked = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LessonMaterialType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonMaterial].
extension LessonMaterialPatterns on LessonMaterial {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonMaterial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonMaterial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonMaterial value)  $default,){
final _that = this;
switch (_that) {
case _LessonMaterial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonMaterial value)?  $default,){
final _that = this;
switch (_that) {
case _LessonMaterial() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LessonMaterialType type,  String title,  String fileName,  String filePath,  int fileSize,  bool isPublic,  bool isAnonymous,  int downloadCount,  int likeCount,  String authorName,  DateTime createdAt,  String? mimeType,  String? previewPath,  String? batchId,  int? width,  int? height,  int? durationSeconds,  bool isLiked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonMaterial() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.fileName,_that.filePath,_that.fileSize,_that.isPublic,_that.isAnonymous,_that.downloadCount,_that.likeCount,_that.authorName,_that.createdAt,_that.mimeType,_that.previewPath,_that.batchId,_that.width,_that.height,_that.durationSeconds,_that.isLiked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LessonMaterialType type,  String title,  String fileName,  String filePath,  int fileSize,  bool isPublic,  bool isAnonymous,  int downloadCount,  int likeCount,  String authorName,  DateTime createdAt,  String? mimeType,  String? previewPath,  String? batchId,  int? width,  int? height,  int? durationSeconds,  bool isLiked)  $default,) {final _that = this;
switch (_that) {
case _LessonMaterial():
return $default(_that.id,_that.type,_that.title,_that.fileName,_that.filePath,_that.fileSize,_that.isPublic,_that.isAnonymous,_that.downloadCount,_that.likeCount,_that.authorName,_that.createdAt,_that.mimeType,_that.previewPath,_that.batchId,_that.width,_that.height,_that.durationSeconds,_that.isLiked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LessonMaterialType type,  String title,  String fileName,  String filePath,  int fileSize,  bool isPublic,  bool isAnonymous,  int downloadCount,  int likeCount,  String authorName,  DateTime createdAt,  String? mimeType,  String? previewPath,  String? batchId,  int? width,  int? height,  int? durationSeconds,  bool isLiked)?  $default,) {final _that = this;
switch (_that) {
case _LessonMaterial() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.fileName,_that.filePath,_that.fileSize,_that.isPublic,_that.isAnonymous,_that.downloadCount,_that.likeCount,_that.authorName,_that.createdAt,_that.mimeType,_that.previewPath,_that.batchId,_that.width,_that.height,_that.durationSeconds,_that.isLiked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonMaterial implements LessonMaterial {
  const _LessonMaterial({required this.id, required this.type, required this.title, required this.fileName, required this.filePath, required this.fileSize, required this.isPublic, required this.isAnonymous, required this.downloadCount, required this.likeCount, required this.authorName, required this.createdAt, this.mimeType, this.previewPath, this.batchId, this.width, this.height, this.durationSeconds, this.isLiked = false});
  factory _LessonMaterial.fromJson(Map<String, dynamic> json) => _$LessonMaterialFromJson(json);

@override final  String id;
@override final  LessonMaterialType type;
@override final  String title;
@override final  String fileName;
@override final  String filePath;
@override final  int fileSize;
@override final  bool isPublic;
@override final  bool isAnonymous;
@override final  int downloadCount;
@override final  int likeCount;
@override final  String authorName;
@override final  DateTime createdAt;
@override final  String? mimeType;
@override final  String? previewPath;
@override final  String? batchId;
@override final  int? width;
@override final  int? height;
@override final  int? durationSeconds;
@override@JsonKey() final  bool isLiked;

/// Create a copy of LessonMaterial
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonMaterialCopyWith<_LessonMaterial> get copyWith => __$LessonMaterialCopyWithImpl<_LessonMaterial>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonMaterialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonMaterial&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,fileName,filePath,fileSize,isPublic,isAnonymous,downloadCount,likeCount,authorName,createdAt,mimeType,previewPath,batchId,width,height,durationSeconds,isLiked);

@override
String toString() {
  return 'LessonMaterial(id: $id, type: $type, title: $title, fileName: $fileName, filePath: $filePath, fileSize: $fileSize, isPublic: $isPublic, isAnonymous: $isAnonymous, downloadCount: $downloadCount, likeCount: $likeCount, authorName: $authorName, createdAt: $createdAt, mimeType: $mimeType, previewPath: $previewPath, batchId: $batchId, width: $width, height: $height, durationSeconds: $durationSeconds, isLiked: $isLiked)';
}


}

/// @nodoc
abstract mixin class _$LessonMaterialCopyWith<$Res> implements $LessonMaterialCopyWith<$Res> {
  factory _$LessonMaterialCopyWith(_LessonMaterial value, $Res Function(_LessonMaterial) _then) = __$LessonMaterialCopyWithImpl;
@override @useResult
$Res call({
 String id, LessonMaterialType type, String title, String fileName, String filePath, int fileSize, bool isPublic, bool isAnonymous, int downloadCount, int likeCount, String authorName, DateTime createdAt, String? mimeType, String? previewPath, String? batchId, int? width, int? height, int? durationSeconds, bool isLiked
});




}
/// @nodoc
class __$LessonMaterialCopyWithImpl<$Res>
    implements _$LessonMaterialCopyWith<$Res> {
  __$LessonMaterialCopyWithImpl(this._self, this._then);

  final _LessonMaterial _self;
  final $Res Function(_LessonMaterial) _then;

/// Create a copy of LessonMaterial
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? fileName = null,Object? filePath = null,Object? fileSize = null,Object? isPublic = null,Object? isAnonymous = null,Object? downloadCount = null,Object? likeCount = null,Object? authorName = null,Object? createdAt = null,Object? mimeType = freezed,Object? previewPath = freezed,Object? batchId = freezed,Object? width = freezed,Object? height = freezed,Object? durationSeconds = freezed,Object? isLiked = null,}) {
  return _then(_LessonMaterial(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LessonMaterialType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
