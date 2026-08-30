// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceCatalog {

 String get organizationId; List<ServiceCatalogSection> get sections;
/// Create a copy of ServiceCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCatalogCopyWith<ServiceCatalog> get copyWith => _$ServiceCatalogCopyWithImpl<ServiceCatalog>(this as ServiceCatalog, _$identity);

  /// Serializes this ServiceCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceCatalog&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&const DeepCollectionEquality().equals(other.sections, sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organizationId,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'ServiceCatalog(organizationId: $organizationId, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $ServiceCatalogCopyWith<$Res>  {
  factory $ServiceCatalogCopyWith(ServiceCatalog value, $Res Function(ServiceCatalog) _then) = _$ServiceCatalogCopyWithImpl;
@useResult
$Res call({
 String organizationId, List<ServiceCatalogSection> sections
});




}
/// @nodoc
class _$ServiceCatalogCopyWithImpl<$Res>
    implements $ServiceCatalogCopyWith<$Res> {
  _$ServiceCatalogCopyWithImpl(this._self, this._then);

  final ServiceCatalog _self;
  final $Res Function(ServiceCatalog) _then;

/// Create a copy of ServiceCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizationId = null,Object? sections = null,}) {
  return _then(_self.copyWith(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<ServiceCatalogSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceCatalog].
extension ServiceCatalogPatterns on ServiceCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceCatalog value)  $default,){
final _that = this;
switch (_that) {
case _ServiceCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceCatalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String organizationId,  List<ServiceCatalogSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceCatalog() when $default != null:
return $default(_that.organizationId,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String organizationId,  List<ServiceCatalogSection> sections)  $default,) {final _that = this;
switch (_that) {
case _ServiceCatalog():
return $default(_that.organizationId,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String organizationId,  List<ServiceCatalogSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _ServiceCatalog() when $default != null:
return $default(_that.organizationId,_that.sections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceCatalog implements ServiceCatalog {
  const _ServiceCatalog({required this.organizationId, required final  List<ServiceCatalogSection> sections}): _sections = sections;
  factory _ServiceCatalog.fromJson(Map<String, dynamic> json) => _$ServiceCatalogFromJson(json);

@override final  String organizationId;
 final  List<ServiceCatalogSection> _sections;
@override List<ServiceCatalogSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of ServiceCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCatalogCopyWith<_ServiceCatalog> get copyWith => __$ServiceCatalogCopyWithImpl<_ServiceCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceCatalog&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&const DeepCollectionEquality().equals(other._sections, _sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organizationId,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'ServiceCatalog(organizationId: $organizationId, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$ServiceCatalogCopyWith<$Res> implements $ServiceCatalogCopyWith<$Res> {
  factory _$ServiceCatalogCopyWith(_ServiceCatalog value, $Res Function(_ServiceCatalog) _then) = __$ServiceCatalogCopyWithImpl;
@override @useResult
$Res call({
 String organizationId, List<ServiceCatalogSection> sections
});




}
/// @nodoc
class __$ServiceCatalogCopyWithImpl<$Res>
    implements _$ServiceCatalogCopyWith<$Res> {
  __$ServiceCatalogCopyWithImpl(this._self, this._then);

  final _ServiceCatalog _self;
  final $Res Function(_ServiceCatalog) _then;

/// Create a copy of ServiceCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizationId = null,Object? sections = null,}) {
  return _then(_ServiceCatalog(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<ServiceCatalogSection>,
  ));
}


}

// dart format on
