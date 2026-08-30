// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_catalog_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceCatalogSection {

 String get key; String get title; int get sortOrder; List<ServiceCatalogEntry> get items;
/// Create a copy of ServiceCatalogSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCatalogSectionCopyWith<ServiceCatalogSection> get copyWith => _$ServiceCatalogSectionCopyWithImpl<ServiceCatalogSection>(this as ServiceCatalogSection, _$identity);

  /// Serializes this ServiceCatalogSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceCatalogSection&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,title,sortOrder,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ServiceCatalogSection(key: $key, title: $title, sortOrder: $sortOrder, items: $items)';
}


}

/// @nodoc
abstract mixin class $ServiceCatalogSectionCopyWith<$Res>  {
  factory $ServiceCatalogSectionCopyWith(ServiceCatalogSection value, $Res Function(ServiceCatalogSection) _then) = _$ServiceCatalogSectionCopyWithImpl;
@useResult
$Res call({
 String key, String title, int sortOrder, List<ServiceCatalogEntry> items
});




}
/// @nodoc
class _$ServiceCatalogSectionCopyWithImpl<$Res>
    implements $ServiceCatalogSectionCopyWith<$Res> {
  _$ServiceCatalogSectionCopyWithImpl(this._self, this._then);

  final ServiceCatalogSection _self;
  final $Res Function(ServiceCatalogSection) _then;

/// Create a copy of ServiceCatalogSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? title = null,Object? sortOrder = null,Object? items = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ServiceCatalogEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceCatalogSection].
extension ServiceCatalogSectionPatterns on ServiceCatalogSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceCatalogSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceCatalogSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceCatalogSection value)  $default,){
final _that = this;
switch (_that) {
case _ServiceCatalogSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceCatalogSection value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceCatalogSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String title,  int sortOrder,  List<ServiceCatalogEntry> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceCatalogSection() when $default != null:
return $default(_that.key,_that.title,_that.sortOrder,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String title,  int sortOrder,  List<ServiceCatalogEntry> items)  $default,) {final _that = this;
switch (_that) {
case _ServiceCatalogSection():
return $default(_that.key,_that.title,_that.sortOrder,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String title,  int sortOrder,  List<ServiceCatalogEntry> items)?  $default,) {final _that = this;
switch (_that) {
case _ServiceCatalogSection() when $default != null:
return $default(_that.key,_that.title,_that.sortOrder,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceCatalogSection implements ServiceCatalogSection {
  const _ServiceCatalogSection({required this.key, required this.title, required this.sortOrder, required final  List<ServiceCatalogEntry> items}): _items = items;
  factory _ServiceCatalogSection.fromJson(Map<String, dynamic> json) => _$ServiceCatalogSectionFromJson(json);

@override final  String key;
@override final  String title;
@override final  int sortOrder;
 final  List<ServiceCatalogEntry> _items;
@override List<ServiceCatalogEntry> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ServiceCatalogSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCatalogSectionCopyWith<_ServiceCatalogSection> get copyWith => __$ServiceCatalogSectionCopyWithImpl<_ServiceCatalogSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceCatalogSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceCatalogSection&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,title,sortOrder,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ServiceCatalogSection(key: $key, title: $title, sortOrder: $sortOrder, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ServiceCatalogSectionCopyWith<$Res> implements $ServiceCatalogSectionCopyWith<$Res> {
  factory _$ServiceCatalogSectionCopyWith(_ServiceCatalogSection value, $Res Function(_ServiceCatalogSection) _then) = __$ServiceCatalogSectionCopyWithImpl;
@override @useResult
$Res call({
 String key, String title, int sortOrder, List<ServiceCatalogEntry> items
});




}
/// @nodoc
class __$ServiceCatalogSectionCopyWithImpl<$Res>
    implements _$ServiceCatalogSectionCopyWith<$Res> {
  __$ServiceCatalogSectionCopyWithImpl(this._self, this._then);

  final _ServiceCatalogSection _self;
  final $Res Function(_ServiceCatalogSection) _then;

/// Create a copy of ServiceCatalogSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? sortOrder = null,Object? items = null,}) {
  return _then(_ServiceCatalogSection(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ServiceCatalogEntry>,
  ));
}


}

// dart format on
