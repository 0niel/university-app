// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchItem {

 int get id; String get targetTitle; String get fullTitle; int get scheduleTarget; String get iCalLink;
/// Create a copy of SearchItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchItemCopyWith<SearchItem> get copyWith => _$SearchItemCopyWithImpl<SearchItem>(this as SearchItem, _$identity);

  /// Serializes this SearchItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchItem&&(identical(other.id, id) || other.id == id)&&(identical(other.targetTitle, targetTitle) || other.targetTitle == targetTitle)&&(identical(other.fullTitle, fullTitle) || other.fullTitle == fullTitle)&&(identical(other.scheduleTarget, scheduleTarget) || other.scheduleTarget == scheduleTarget)&&(identical(other.iCalLink, iCalLink) || other.iCalLink == iCalLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,targetTitle,fullTitle,scheduleTarget,iCalLink);

@override
String toString() {
  return 'SearchItem(id: $id, targetTitle: $targetTitle, fullTitle: $fullTitle, scheduleTarget: $scheduleTarget, iCalLink: $iCalLink)';
}


}

/// @nodoc
abstract mixin class $SearchItemCopyWith<$Res>  {
  factory $SearchItemCopyWith(SearchItem value, $Res Function(SearchItem) _then) = _$SearchItemCopyWithImpl;
@useResult
$Res call({
 int id, String targetTitle, String fullTitle, int scheduleTarget, String iCalLink
});




}
/// @nodoc
class _$SearchItemCopyWithImpl<$Res>
    implements $SearchItemCopyWith<$Res> {
  _$SearchItemCopyWithImpl(this._self, this._then);

  final SearchItem _self;
  final $Res Function(SearchItem) _then;

/// Create a copy of SearchItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? targetTitle = null,Object? fullTitle = null,Object? scheduleTarget = null,Object? iCalLink = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,targetTitle: null == targetTitle ? _self.targetTitle : targetTitle // ignore: cast_nullable_to_non_nullable
as String,fullTitle: null == fullTitle ? _self.fullTitle : fullTitle // ignore: cast_nullable_to_non_nullable
as String,scheduleTarget: null == scheduleTarget ? _self.scheduleTarget : scheduleTarget // ignore: cast_nullable_to_non_nullable
as int,iCalLink: null == iCalLink ? _self.iCalLink : iCalLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchItem].
extension SearchItemPatterns on SearchItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchItem value)  $default,){
final _that = this;
switch (_that) {
case _SearchItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchItem value)?  $default,){
final _that = this;
switch (_that) {
case _SearchItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String targetTitle,  String fullTitle,  int scheduleTarget,  String iCalLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchItem() when $default != null:
return $default(_that.id,_that.targetTitle,_that.fullTitle,_that.scheduleTarget,_that.iCalLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String targetTitle,  String fullTitle,  int scheduleTarget,  String iCalLink)  $default,) {final _that = this;
switch (_that) {
case _SearchItem():
return $default(_that.id,_that.targetTitle,_that.fullTitle,_that.scheduleTarget,_that.iCalLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String targetTitle,  String fullTitle,  int scheduleTarget,  String iCalLink)?  $default,) {final _that = this;
switch (_that) {
case _SearchItem() when $default != null:
return $default(_that.id,_that.targetTitle,_that.fullTitle,_that.scheduleTarget,_that.iCalLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchItem implements SearchItem {
  const _SearchItem({required this.id, required this.targetTitle, required this.fullTitle, required this.scheduleTarget, required this.iCalLink});
  factory _SearchItem.fromJson(Map<String, dynamic> json) => _$SearchItemFromJson(json);

@override final  int id;
@override final  String targetTitle;
@override final  String fullTitle;
@override final  int scheduleTarget;
@override final  String iCalLink;

/// Create a copy of SearchItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchItemCopyWith<_SearchItem> get copyWith => __$SearchItemCopyWithImpl<_SearchItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchItem&&(identical(other.id, id) || other.id == id)&&(identical(other.targetTitle, targetTitle) || other.targetTitle == targetTitle)&&(identical(other.fullTitle, fullTitle) || other.fullTitle == fullTitle)&&(identical(other.scheduleTarget, scheduleTarget) || other.scheduleTarget == scheduleTarget)&&(identical(other.iCalLink, iCalLink) || other.iCalLink == iCalLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,targetTitle,fullTitle,scheduleTarget,iCalLink);

@override
String toString() {
  return 'SearchItem(id: $id, targetTitle: $targetTitle, fullTitle: $fullTitle, scheduleTarget: $scheduleTarget, iCalLink: $iCalLink)';
}


}

/// @nodoc
abstract mixin class _$SearchItemCopyWith<$Res> implements $SearchItemCopyWith<$Res> {
  factory _$SearchItemCopyWith(_SearchItem value, $Res Function(_SearchItem) _then) = __$SearchItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String targetTitle, String fullTitle, int scheduleTarget, String iCalLink
});




}
/// @nodoc
class __$SearchItemCopyWithImpl<$Res>
    implements _$SearchItemCopyWith<$Res> {
  __$SearchItemCopyWithImpl(this._self, this._then);

  final _SearchItem _self;
  final $Res Function(_SearchItem) _then;

/// Create a copy of SearchItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? targetTitle = null,Object? fullTitle = null,Object? scheduleTarget = null,Object? iCalLink = null,}) {
  return _then(_SearchItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,targetTitle: null == targetTitle ? _self.targetTitle : targetTitle // ignore: cast_nullable_to_non_nullable
as String,fullTitle: null == fullTitle ? _self.fullTitle : fullTitle // ignore: cast_nullable_to_non_nullable
as String,scheduleTarget: null == scheduleTarget ? _self.scheduleTarget : scheduleTarget // ignore: cast_nullable_to_non_nullable
as int,iCalLink: null == iCalLink ? _self.iCalLink : iCalLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
