// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_catalog_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommunityCatalogState {

 CommunityCatalogStatus get status; CommunityCatalog? get catalog; bool get isRefreshing; String? get selectedSectionKey; String get query;
/// Create a copy of CommunityCatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityCatalogStateCopyWith<CommunityCatalogState> get copyWith => _$CommunityCatalogStateCopyWithImpl<CommunityCatalogState>(this as CommunityCatalogState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityCatalogState&&(identical(other.status, status) || other.status == status)&&(identical(other.catalog, catalog) || other.catalog == catalog)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.selectedSectionKey, selectedSectionKey) || other.selectedSectionKey == selectedSectionKey)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,status,catalog,isRefreshing,selectedSectionKey,query);

@override
String toString() {
  return 'CommunityCatalogState(status: $status, catalog: $catalog, isRefreshing: $isRefreshing, selectedSectionKey: $selectedSectionKey, query: $query)';
}


}

/// @nodoc
abstract mixin class $CommunityCatalogStateCopyWith<$Res>  {
  factory $CommunityCatalogStateCopyWith(CommunityCatalogState value, $Res Function(CommunityCatalogState) _then) = _$CommunityCatalogStateCopyWithImpl;
@useResult
$Res call({
 CommunityCatalogStatus status, CommunityCatalog? catalog, bool isRefreshing, String? selectedSectionKey, String query
});


$CommunityCatalogCopyWith<$Res>? get catalog;

}
/// @nodoc
class _$CommunityCatalogStateCopyWithImpl<$Res>
    implements $CommunityCatalogStateCopyWith<$Res> {
  _$CommunityCatalogStateCopyWithImpl(this._self, this._then);

  final CommunityCatalogState _self;
  final $Res Function(CommunityCatalogState) _then;

/// Create a copy of CommunityCatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? catalog = freezed,Object? isRefreshing = null,Object? selectedSectionKey = freezed,Object? query = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommunityCatalogStatus,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as CommunityCatalog?,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,selectedSectionKey: freezed == selectedSectionKey ? _self.selectedSectionKey : selectedSectionKey // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of CommunityCatalogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityCatalogCopyWith<$Res>? get catalog {
    if (_self.catalog == null) {
    return null;
  }

  return $CommunityCatalogCopyWith<$Res>(_self.catalog!, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommunityCatalogState].
extension CommunityCatalogStatePatterns on CommunityCatalogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityCatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityCatalogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityCatalogState value)  $default,){
final _that = this;
switch (_that) {
case _CommunityCatalogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityCatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityCatalogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CommunityCatalogStatus status,  CommunityCatalog? catalog,  bool isRefreshing,  String? selectedSectionKey,  String query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityCatalogState() when $default != null:
return $default(_that.status,_that.catalog,_that.isRefreshing,_that.selectedSectionKey,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CommunityCatalogStatus status,  CommunityCatalog? catalog,  bool isRefreshing,  String? selectedSectionKey,  String query)  $default,) {final _that = this;
switch (_that) {
case _CommunityCatalogState():
return $default(_that.status,_that.catalog,_that.isRefreshing,_that.selectedSectionKey,_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CommunityCatalogStatus status,  CommunityCatalog? catalog,  bool isRefreshing,  String? selectedSectionKey,  String query)?  $default,) {final _that = this;
switch (_that) {
case _CommunityCatalogState() when $default != null:
return $default(_that.status,_that.catalog,_that.isRefreshing,_that.selectedSectionKey,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _CommunityCatalogState extends CommunityCatalogState {
  const _CommunityCatalogState({this.status = CommunityCatalogStatus.initial, this.catalog, this.isRefreshing = false, this.selectedSectionKey, this.query = ''}): super._();


@override@JsonKey() final  CommunityCatalogStatus status;
@override final  CommunityCatalog? catalog;
@override@JsonKey() final  bool isRefreshing;
@override final  String? selectedSectionKey;
@override@JsonKey() final  String query;

/// Create a copy of CommunityCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityCatalogStateCopyWith<_CommunityCatalogState> get copyWith => __$CommunityCatalogStateCopyWithImpl<_CommunityCatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityCatalogState&&(identical(other.status, status) || other.status == status)&&(identical(other.catalog, catalog) || other.catalog == catalog)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.selectedSectionKey, selectedSectionKey) || other.selectedSectionKey == selectedSectionKey)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,status,catalog,isRefreshing,selectedSectionKey,query);

@override
String toString() {
  return 'CommunityCatalogState(status: $status, catalog: $catalog, isRefreshing: $isRefreshing, selectedSectionKey: $selectedSectionKey, query: $query)';
}


}

/// @nodoc
abstract mixin class _$CommunityCatalogStateCopyWith<$Res> implements $CommunityCatalogStateCopyWith<$Res> {
  factory _$CommunityCatalogStateCopyWith(_CommunityCatalogState value, $Res Function(_CommunityCatalogState) _then) = __$CommunityCatalogStateCopyWithImpl;
@override @useResult
$Res call({
 CommunityCatalogStatus status, CommunityCatalog? catalog, bool isRefreshing, String? selectedSectionKey, String query
});


@override $CommunityCatalogCopyWith<$Res>? get catalog;

}
/// @nodoc
class __$CommunityCatalogStateCopyWithImpl<$Res>
    implements _$CommunityCatalogStateCopyWith<$Res> {
  __$CommunityCatalogStateCopyWithImpl(this._self, this._then);

  final _CommunityCatalogState _self;
  final $Res Function(_CommunityCatalogState) _then;

/// Create a copy of CommunityCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? catalog = freezed,Object? isRefreshing = null,Object? selectedSectionKey = freezed,Object? query = null,}) {
  return _then(_CommunityCatalogState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommunityCatalogStatus,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as CommunityCatalog?,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,selectedSectionKey: freezed == selectedSectionKey ? _self.selectedSectionKey : selectedSectionKey // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CommunityCatalogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityCatalogCopyWith<$Res>? get catalog {
    if (_self.catalog == null) {
    return null;
  }

  return $CommunityCatalogCopyWith<$Res>(_self.catalog!, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}
}

// dart format on
