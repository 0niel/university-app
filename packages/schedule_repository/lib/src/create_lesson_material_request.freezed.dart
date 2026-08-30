// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_lesson_material_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateLessonMaterialRequest {

 String get subjectName; DateTime get lessonDate; int get lessonBellsNumber; LessonMaterialType get materialType; String get title; String get fileName; List<int> get bytes; bool get isPublic; bool get isAnonymous; String? get lessonUid; String? get mimeType;
/// Create a copy of CreateLessonMaterialRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateLessonMaterialRequestCopyWith<CreateLessonMaterialRequest> get copyWith => _$CreateLessonMaterialRequestCopyWithImpl<CreateLessonMaterialRequest>(this as CreateLessonMaterialRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateLessonMaterialRequest&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBellsNumber, lessonBellsNumber) || other.lessonBellsNumber == lessonBellsNumber)&&(identical(other.materialType, materialType) || other.materialType == materialType)&&(identical(other.title, title) || other.title == title)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.lessonUid, lessonUid) || other.lessonUid == lessonUid)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}


@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBellsNumber,materialType,title,fileName,const DeepCollectionEquality().hash(bytes),isPublic,isAnonymous,lessonUid,mimeType);

@override
String toString() {
  return 'CreateLessonMaterialRequest(subjectName: $subjectName, lessonDate: $lessonDate, lessonBellsNumber: $lessonBellsNumber, materialType: $materialType, title: $title, fileName: $fileName, bytes: $bytes, isPublic: $isPublic, isAnonymous: $isAnonymous, lessonUid: $lessonUid, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class $CreateLessonMaterialRequestCopyWith<$Res>  {
  factory $CreateLessonMaterialRequestCopyWith(CreateLessonMaterialRequest value, $Res Function(CreateLessonMaterialRequest) _then) = _$CreateLessonMaterialRequestCopyWithImpl;
@useResult
$Res call({
 String subjectName, DateTime lessonDate, int lessonBellsNumber, LessonMaterialType materialType, String title, String fileName, List<int> bytes, bool isPublic, bool isAnonymous, String? lessonUid, String? mimeType
});




}
/// @nodoc
class _$CreateLessonMaterialRequestCopyWithImpl<$Res>
    implements $CreateLessonMaterialRequestCopyWith<$Res> {
  _$CreateLessonMaterialRequestCopyWithImpl(this._self, this._then);

  final CreateLessonMaterialRequest _self;
  final $Res Function(CreateLessonMaterialRequest) _then;

/// Create a copy of CreateLessonMaterialRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBellsNumber = null,Object? materialType = null,Object? title = null,Object? fileName = null,Object? bytes = null,Object? isPublic = null,Object? isAnonymous = null,Object? lessonUid = freezed,Object? mimeType = freezed,}) {
  return _then(_self.copyWith(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBellsNumber: null == lessonBellsNumber ? _self.lessonBellsNumber : lessonBellsNumber // ignore: cast_nullable_to_non_nullable
as int,materialType: null == materialType ? _self.materialType : materialType // ignore: cast_nullable_to_non_nullable
as LessonMaterialType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as List<int>,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,lessonUid: freezed == lessonUid ? _self.lessonUid : lessonUid // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateLessonMaterialRequest].
extension CreateLessonMaterialRequestPatterns on CreateLessonMaterialRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateLessonMaterialRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateLessonMaterialRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateLessonMaterialRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateLessonMaterialRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateLessonMaterialRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateLessonMaterialRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  int lessonBellsNumber,  LessonMaterialType materialType,  String title,  String fileName,  List<int> bytes,  bool isPublic,  bool isAnonymous,  String? lessonUid,  String? mimeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateLessonMaterialRequest() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBellsNumber,_that.materialType,_that.title,_that.fileName,_that.bytes,_that.isPublic,_that.isAnonymous,_that.lessonUid,_that.mimeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  int lessonBellsNumber,  LessonMaterialType materialType,  String title,  String fileName,  List<int> bytes,  bool isPublic,  bool isAnonymous,  String? lessonUid,  String? mimeType)  $default,) {final _that = this;
switch (_that) {
case _CreateLessonMaterialRequest():
return $default(_that.subjectName,_that.lessonDate,_that.lessonBellsNumber,_that.materialType,_that.title,_that.fileName,_that.bytes,_that.isPublic,_that.isAnonymous,_that.lessonUid,_that.mimeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectName,  DateTime lessonDate,  int lessonBellsNumber,  LessonMaterialType materialType,  String title,  String fileName,  List<int> bytes,  bool isPublic,  bool isAnonymous,  String? lessonUid,  String? mimeType)?  $default,) {final _that = this;
switch (_that) {
case _CreateLessonMaterialRequest() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBellsNumber,_that.materialType,_that.title,_that.fileName,_that.bytes,_that.isPublic,_that.isAnonymous,_that.lessonUid,_that.mimeType);case _:
  return null;

}
}

}

/// @nodoc


class _CreateLessonMaterialRequest implements CreateLessonMaterialRequest {
  const _CreateLessonMaterialRequest({required this.subjectName, required this.lessonDate, required this.lessonBellsNumber, required this.materialType, required this.title, required this.fileName, required final  List<int> bytes, required this.isPublic, required this.isAnonymous, this.lessonUid, this.mimeType}): _bytes = bytes;


@override final  String subjectName;
@override final  DateTime lessonDate;
@override final  int lessonBellsNumber;
@override final  LessonMaterialType materialType;
@override final  String title;
@override final  String fileName;
 final  List<int> _bytes;
@override List<int> get bytes {
  if (_bytes is EqualUnmodifiableListView) return _bytes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bytes);
}

@override final  bool isPublic;
@override final  bool isAnonymous;
@override final  String? lessonUid;
@override final  String? mimeType;

/// Create a copy of CreateLessonMaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateLessonMaterialRequestCopyWith<_CreateLessonMaterialRequest> get copyWith => __$CreateLessonMaterialRequestCopyWithImpl<_CreateLessonMaterialRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateLessonMaterialRequest&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBellsNumber, lessonBellsNumber) || other.lessonBellsNumber == lessonBellsNumber)&&(identical(other.materialType, materialType) || other.materialType == materialType)&&(identical(other.title, title) || other.title == title)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&const DeepCollectionEquality().equals(other._bytes, _bytes)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.lessonUid, lessonUid) || other.lessonUid == lessonUid)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}


@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBellsNumber,materialType,title,fileName,const DeepCollectionEquality().hash(_bytes),isPublic,isAnonymous,lessonUid,mimeType);

@override
String toString() {
  return 'CreateLessonMaterialRequest(subjectName: $subjectName, lessonDate: $lessonDate, lessonBellsNumber: $lessonBellsNumber, materialType: $materialType, title: $title, fileName: $fileName, bytes: $bytes, isPublic: $isPublic, isAnonymous: $isAnonymous, lessonUid: $lessonUid, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class _$CreateLessonMaterialRequestCopyWith<$Res> implements $CreateLessonMaterialRequestCopyWith<$Res> {
  factory _$CreateLessonMaterialRequestCopyWith(_CreateLessonMaterialRequest value, $Res Function(_CreateLessonMaterialRequest) _then) = __$CreateLessonMaterialRequestCopyWithImpl;
@override @useResult
$Res call({
 String subjectName, DateTime lessonDate, int lessonBellsNumber, LessonMaterialType materialType, String title, String fileName, List<int> bytes, bool isPublic, bool isAnonymous, String? lessonUid, String? mimeType
});




}
/// @nodoc
class __$CreateLessonMaterialRequestCopyWithImpl<$Res>
    implements _$CreateLessonMaterialRequestCopyWith<$Res> {
  __$CreateLessonMaterialRequestCopyWithImpl(this._self, this._then);

  final _CreateLessonMaterialRequest _self;
  final $Res Function(_CreateLessonMaterialRequest) _then;

/// Create a copy of CreateLessonMaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBellsNumber = null,Object? materialType = null,Object? title = null,Object? fileName = null,Object? bytes = null,Object? isPublic = null,Object? isAnonymous = null,Object? lessonUid = freezed,Object? mimeType = freezed,}) {
  return _then(_CreateLessonMaterialRequest(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBellsNumber: null == lessonBellsNumber ? _self.lessonBellsNumber : lessonBellsNumber // ignore: cast_nullable_to_non_nullable
as int,materialType: null == materialType ? _self.materialType : materialType // ignore: cast_nullable_to_non_nullable
as LessonMaterialType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self._bytes : bytes // ignore: cast_nullable_to_non_nullable
as List<int>,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,lessonUid: freezed == lessonUid ? _self.lessonUid : lessonUid // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
