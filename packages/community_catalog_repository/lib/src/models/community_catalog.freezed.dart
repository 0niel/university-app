// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommunityCatalog {

 String get organizationId; List<CommunityCatalogSection> get sections; String? get suggestionUrl;
/// Create a copy of CommunityCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityCatalogCopyWith<CommunityCatalog> get copyWith => _$CommunityCatalogCopyWithImpl<CommunityCatalog>(this as CommunityCatalog, _$identity);

  /// Serializes this CommunityCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityCatalog&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.suggestionUrl, suggestionUrl) || other.suggestionUrl == suggestionUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organizationId,const DeepCollectionEquality().hash(sections),suggestionUrl);

@override
String toString() {
  return 'CommunityCatalog(organizationId: $organizationId, sections: $sections, suggestionUrl: $suggestionUrl)';
}


}

/// @nodoc
abstract mixin class $CommunityCatalogCopyWith<$Res>  {
  factory $CommunityCatalogCopyWith(CommunityCatalog value, $Res Function(CommunityCatalog) _then) = _$CommunityCatalogCopyWithImpl;
@useResult
$Res call({
 String organizationId, List<CommunityCatalogSection> sections, String? suggestionUrl
});




}
/// @nodoc
class _$CommunityCatalogCopyWithImpl<$Res>
    implements $CommunityCatalogCopyWith<$Res> {
  _$CommunityCatalogCopyWithImpl(this._self, this._then);

  final CommunityCatalog _self;
  final $Res Function(CommunityCatalog) _then;

/// Create a copy of CommunityCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizationId = null,Object? sections = null,Object? suggestionUrl = freezed,}) {
  return _then(_self.copyWith(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<CommunityCatalogSection>,suggestionUrl: freezed == suggestionUrl ? _self.suggestionUrl : suggestionUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityCatalog].
extension CommunityCatalogPatterns on CommunityCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityCatalog value)  $default,){
final _that = this;
switch (_that) {
case _CommunityCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityCatalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String organizationId,  List<CommunityCatalogSection> sections,  String? suggestionUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityCatalog() when $default != null:
return $default(_that.organizationId,_that.sections,_that.suggestionUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String organizationId,  List<CommunityCatalogSection> sections,  String? suggestionUrl)  $default,) {final _that = this;
switch (_that) {
case _CommunityCatalog():
return $default(_that.organizationId,_that.sections,_that.suggestionUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String organizationId,  List<CommunityCatalogSection> sections,  String? suggestionUrl)?  $default,) {final _that = this;
switch (_that) {
case _CommunityCatalog() when $default != null:
return $default(_that.organizationId,_that.sections,_that.suggestionUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommunityCatalog extends CommunityCatalog {
  const _CommunityCatalog({required this.organizationId, required final  List<CommunityCatalogSection> sections, this.suggestionUrl}): _sections = sections,super._();
  factory _CommunityCatalog.fromJson(Map<String, dynamic> json) => _$CommunityCatalogFromJson(json);

@override final  String organizationId;
 final  List<CommunityCatalogSection> _sections;
@override List<CommunityCatalogSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override final  String? suggestionUrl;

/// Create a copy of CommunityCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityCatalogCopyWith<_CommunityCatalog> get copyWith => __$CommunityCatalogCopyWithImpl<_CommunityCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunityCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityCatalog&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.suggestionUrl, suggestionUrl) || other.suggestionUrl == suggestionUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organizationId,const DeepCollectionEquality().hash(_sections),suggestionUrl);

@override
String toString() {
  return 'CommunityCatalog(organizationId: $organizationId, sections: $sections, suggestionUrl: $suggestionUrl)';
}


}

/// @nodoc
abstract mixin class _$CommunityCatalogCopyWith<$Res> implements $CommunityCatalogCopyWith<$Res> {
  factory _$CommunityCatalogCopyWith(_CommunityCatalog value, $Res Function(_CommunityCatalog) _then) = __$CommunityCatalogCopyWithImpl;
@override @useResult
$Res call({
 String organizationId, List<CommunityCatalogSection> sections, String? suggestionUrl
});




}
/// @nodoc
class __$CommunityCatalogCopyWithImpl<$Res>
    implements _$CommunityCatalogCopyWith<$Res> {
  __$CommunityCatalogCopyWithImpl(this._self, this._then);

  final _CommunityCatalog _self;
  final $Res Function(_CommunityCatalog) _then;

/// Create a copy of CommunityCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizationId = null,Object? sections = null,Object? suggestionUrl = freezed,}) {
  return _then(_CommunityCatalog(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<CommunityCatalogSection>,suggestionUrl: freezed == suggestionUrl ? _self.suggestionUrl : suggestionUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
