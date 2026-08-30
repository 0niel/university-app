// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_catalog_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommunityCatalogSection {

 String get key; String get title; String get emoji; List<CommunityCatalogEntry> get items; int get sortOrder;
/// Create a copy of CommunityCatalogSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityCatalogSectionCopyWith<CommunityCatalogSection> get copyWith => _$CommunityCatalogSectionCopyWithImpl<CommunityCatalogSection>(this as CommunityCatalogSection, _$identity);

  /// Serializes this CommunityCatalogSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityCatalogSection&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,title,emoji,const DeepCollectionEquality().hash(items),sortOrder);

@override
String toString() {
  return 'CommunityCatalogSection(key: $key, title: $title, emoji: $emoji, items: $items, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $CommunityCatalogSectionCopyWith<$Res>  {
  factory $CommunityCatalogSectionCopyWith(CommunityCatalogSection value, $Res Function(CommunityCatalogSection) _then) = _$CommunityCatalogSectionCopyWithImpl;
@useResult
$Res call({
 String key, String title, String emoji, List<CommunityCatalogEntry> items, int sortOrder
});




}
/// @nodoc
class _$CommunityCatalogSectionCopyWithImpl<$Res>
    implements $CommunityCatalogSectionCopyWith<$Res> {
  _$CommunityCatalogSectionCopyWithImpl(this._self, this._then);

  final CommunityCatalogSection _self;
  final $Res Function(CommunityCatalogSection) _then;

/// Create a copy of CommunityCatalogSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? title = null,Object? emoji = null,Object? items = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CommunityCatalogEntry>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityCatalogSection].
extension CommunityCatalogSectionPatterns on CommunityCatalogSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityCatalogSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityCatalogSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityCatalogSection value)  $default,){
final _that = this;
switch (_that) {
case _CommunityCatalogSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityCatalogSection value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityCatalogSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String title,  String emoji,  List<CommunityCatalogEntry> items,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityCatalogSection() when $default != null:
return $default(_that.key,_that.title,_that.emoji,_that.items,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String title,  String emoji,  List<CommunityCatalogEntry> items,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _CommunityCatalogSection():
return $default(_that.key,_that.title,_that.emoji,_that.items,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String title,  String emoji,  List<CommunityCatalogEntry> items,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _CommunityCatalogSection() when $default != null:
return $default(_that.key,_that.title,_that.emoji,_that.items,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommunityCatalogSection implements CommunityCatalogSection {
  const _CommunityCatalogSection({required this.key, required this.title, required this.emoji, required final  List<CommunityCatalogEntry> items, this.sortOrder = 0}): _items = items;
  factory _CommunityCatalogSection.fromJson(Map<String, dynamic> json) => _$CommunityCatalogSectionFromJson(json);

@override final  String key;
@override final  String title;
@override final  String emoji;
 final  List<CommunityCatalogEntry> _items;
@override List<CommunityCatalogEntry> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int sortOrder;

/// Create a copy of CommunityCatalogSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityCatalogSectionCopyWith<_CommunityCatalogSection> get copyWith => __$CommunityCatalogSectionCopyWithImpl<_CommunityCatalogSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunityCatalogSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityCatalogSection&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,title,emoji,const DeepCollectionEquality().hash(_items),sortOrder);

@override
String toString() {
  return 'CommunityCatalogSection(key: $key, title: $title, emoji: $emoji, items: $items, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$CommunityCatalogSectionCopyWith<$Res> implements $CommunityCatalogSectionCopyWith<$Res> {
  factory _$CommunityCatalogSectionCopyWith(_CommunityCatalogSection value, $Res Function(_CommunityCatalogSection) _then) = __$CommunityCatalogSectionCopyWithImpl;
@override @useResult
$Res call({
 String key, String title, String emoji, List<CommunityCatalogEntry> items, int sortOrder
});




}
/// @nodoc
class __$CommunityCatalogSectionCopyWithImpl<$Res>
    implements _$CommunityCatalogSectionCopyWith<$Res> {
  __$CommunityCatalogSectionCopyWithImpl(this._self, this._then);

  final _CommunityCatalogSection _self;
  final $Res Function(_CommunityCatalogSection) _then;

/// Create a copy of CommunityCatalogSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? emoji = null,Object? items = null,Object? sortOrder = null,}) {
  return _then(_CommunityCatalogSection(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CommunityCatalogEntry>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
