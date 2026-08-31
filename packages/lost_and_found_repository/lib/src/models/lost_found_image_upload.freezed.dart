// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_found_image_upload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LostFoundImageUpload {

 Uint8List get bytes; String get contentType;
/// Create a copy of LostFoundImageUpload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LostFoundImageUploadCopyWith<LostFoundImageUpload> get copyWith => _$LostFoundImageUploadCopyWithImpl<LostFoundImageUpload>(this as LostFoundImageUpload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LostFoundImageUpload&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),contentType);

@override
String toString() {
  return 'LostFoundImageUpload(bytes: $bytes, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class $LostFoundImageUploadCopyWith<$Res>  {
  factory $LostFoundImageUploadCopyWith(LostFoundImageUpload value, $Res Function(LostFoundImageUpload) _then) = _$LostFoundImageUploadCopyWithImpl;
@useResult
$Res call({
 Uint8List bytes, String contentType
});




}
/// @nodoc
class _$LostFoundImageUploadCopyWithImpl<$Res>
    implements $LostFoundImageUploadCopyWith<$Res> {
  _$LostFoundImageUploadCopyWithImpl(this._self, this._then);

  final LostFoundImageUpload _self;
  final $Res Function(LostFoundImageUpload) _then;

/// Create a copy of LostFoundImageUpload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bytes = null,Object? contentType = null,}) {
  return _then(_self.copyWith(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LostFoundImageUpload].
extension LostFoundImageUploadPatterns on LostFoundImageUpload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LostFoundImageUpload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LostFoundImageUpload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LostFoundImageUpload value)  $default,){
final _that = this;
switch (_that) {
case _LostFoundImageUpload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LostFoundImageUpload value)?  $default,){
final _that = this;
switch (_that) {
case _LostFoundImageUpload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List bytes,  String contentType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LostFoundImageUpload() when $default != null:
return $default(_that.bytes,_that.contentType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List bytes,  String contentType)  $default,) {final _that = this;
switch (_that) {
case _LostFoundImageUpload():
return $default(_that.bytes,_that.contentType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List bytes,  String contentType)?  $default,) {final _that = this;
switch (_that) {
case _LostFoundImageUpload() when $default != null:
return $default(_that.bytes,_that.contentType);case _:
  return null;

}
}

}

/// @nodoc


class _LostFoundImageUpload implements LostFoundImageUpload {
  const _LostFoundImageUpload({required this.bytes, required this.contentType});


@override final  Uint8List bytes;
@override final  String contentType;

/// Create a copy of LostFoundImageUpload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LostFoundImageUploadCopyWith<_LostFoundImageUpload> get copyWith => __$LostFoundImageUploadCopyWithImpl<_LostFoundImageUpload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LostFoundImageUpload&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),contentType);

@override
String toString() {
  return 'LostFoundImageUpload(bytes: $bytes, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class _$LostFoundImageUploadCopyWith<$Res> implements $LostFoundImageUploadCopyWith<$Res> {
  factory _$LostFoundImageUploadCopyWith(_LostFoundImageUpload value, $Res Function(_LostFoundImageUpload) _then) = __$LostFoundImageUploadCopyWithImpl;
@override @useResult
$Res call({
 Uint8List bytes, String contentType
});




}
/// @nodoc
class __$LostFoundImageUploadCopyWithImpl<$Res>
    implements _$LostFoundImageUploadCopyWith<$Res> {
  __$LostFoundImageUploadCopyWithImpl(this._self, this._then);

  final _LostFoundImageUpload _self;
  final $Res Function(_LostFoundImageUpload) _then;

/// Create a copy of LostFoundImageUpload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bytes = null,Object? contentType = null,}) {
  return _then(_LostFoundImageUpload(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
