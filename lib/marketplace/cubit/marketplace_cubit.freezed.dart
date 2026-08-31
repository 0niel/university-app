// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketplaceState {

 MarketplaceStatus get status; List<MarketListing> get items; String get filterKey; Set<String> get pendingSoldIds; Set<String> get pendingDeleteIds; bool get isCreating;
/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketplaceStateCopyWith<MarketplaceState> get copyWith => _$MarketplaceStateCopyWithImpl<MarketplaceState>(this as MarketplaceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketplaceState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&const DeepCollectionEquality().equals(other.pendingSoldIds, pendingSoldIds)&&const DeepCollectionEquality().equals(other.pendingDeleteIds, pendingDeleteIds)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),filterKey,const DeepCollectionEquality().hash(pendingSoldIds),const DeepCollectionEquality().hash(pendingDeleteIds),isCreating);

@override
String toString() {
  return 'MarketplaceState(status: $status, items: $items, filterKey: $filterKey, pendingSoldIds: $pendingSoldIds, pendingDeleteIds: $pendingDeleteIds, isCreating: $isCreating)';
}


}

/// @nodoc
abstract mixin class $MarketplaceStateCopyWith<$Res>  {
  factory $MarketplaceStateCopyWith(MarketplaceState value, $Res Function(MarketplaceState) _then) = _$MarketplaceStateCopyWithImpl;
@useResult
$Res call({
 MarketplaceStatus status, List<MarketListing> items, String filterKey, Set<String> pendingSoldIds, Set<String> pendingDeleteIds, bool isCreating
});




}
/// @nodoc
class _$MarketplaceStateCopyWithImpl<$Res>
    implements $MarketplaceStateCopyWith<$Res> {
  _$MarketplaceStateCopyWithImpl(this._self, this._then);

  final MarketplaceState _self;
  final $Res Function(MarketplaceState) _then;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? filterKey = null,Object? pendingSoldIds = null,Object? pendingDeleteIds = null,Object? isCreating = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MarketplaceStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MarketListing>,filterKey: null == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String,pendingSoldIds: null == pendingSoldIds ? _self.pendingSoldIds : pendingSoldIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingDeleteIds: null == pendingDeleteIds ? _self.pendingDeleteIds : pendingDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketplaceState].
extension MarketplaceStatePatterns on MarketplaceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketplaceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketplaceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketplaceState value)  $default,){
final _that = this;
switch (_that) {
case _MarketplaceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketplaceState value)?  $default,){
final _that = this;
switch (_that) {
case _MarketplaceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MarketplaceStatus status,  List<MarketListing> items,  String filterKey,  Set<String> pendingSoldIds,  Set<String> pendingDeleteIds,  bool isCreating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketplaceState() when $default != null:
return $default(_that.status,_that.items,_that.filterKey,_that.pendingSoldIds,_that.pendingDeleteIds,_that.isCreating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MarketplaceStatus status,  List<MarketListing> items,  String filterKey,  Set<String> pendingSoldIds,  Set<String> pendingDeleteIds,  bool isCreating)  $default,) {final _that = this;
switch (_that) {
case _MarketplaceState():
return $default(_that.status,_that.items,_that.filterKey,_that.pendingSoldIds,_that.pendingDeleteIds,_that.isCreating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MarketplaceStatus status,  List<MarketListing> items,  String filterKey,  Set<String> pendingSoldIds,  Set<String> pendingDeleteIds,  bool isCreating)?  $default,) {final _that = this;
switch (_that) {
case _MarketplaceState() when $default != null:
return $default(_that.status,_that.items,_that.filterKey,_that.pendingSoldIds,_that.pendingDeleteIds,_that.isCreating);case _:
  return null;

}
}

}

/// @nodoc


class _MarketplaceState extends MarketplaceState {
  const _MarketplaceState({this.status = MarketplaceStatus.initial, final  List<MarketListing> items = const <MarketListing>[], this.filterKey = 'all', final  Set<String> pendingSoldIds = const <String>{}, final  Set<String> pendingDeleteIds = const <String>{}, this.isCreating = false}): _items = items,_pendingSoldIds = pendingSoldIds,_pendingDeleteIds = pendingDeleteIds,super._();


@override@JsonKey() final  MarketplaceStatus status;
 final  List<MarketListing> _items;
@override@JsonKey() List<MarketListing> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String filterKey;
 final  Set<String> _pendingSoldIds;
@override@JsonKey() Set<String> get pendingSoldIds {
  if (_pendingSoldIds is EqualUnmodifiableSetView) return _pendingSoldIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingSoldIds);
}

 final  Set<String> _pendingDeleteIds;
@override@JsonKey() Set<String> get pendingDeleteIds {
  if (_pendingDeleteIds is EqualUnmodifiableSetView) return _pendingDeleteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingDeleteIds);
}

@override@JsonKey() final  bool isCreating;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketplaceStateCopyWith<_MarketplaceState> get copyWith => __$MarketplaceStateCopyWithImpl<_MarketplaceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketplaceState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&const DeepCollectionEquality().equals(other._pendingSoldIds, _pendingSoldIds)&&const DeepCollectionEquality().equals(other._pendingDeleteIds, _pendingDeleteIds)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),filterKey,const DeepCollectionEquality().hash(_pendingSoldIds),const DeepCollectionEquality().hash(_pendingDeleteIds),isCreating);

@override
String toString() {
  return 'MarketplaceState(status: $status, items: $items, filterKey: $filterKey, pendingSoldIds: $pendingSoldIds, pendingDeleteIds: $pendingDeleteIds, isCreating: $isCreating)';
}


}

/// @nodoc
abstract mixin class _$MarketplaceStateCopyWith<$Res> implements $MarketplaceStateCopyWith<$Res> {
  factory _$MarketplaceStateCopyWith(_MarketplaceState value, $Res Function(_MarketplaceState) _then) = __$MarketplaceStateCopyWithImpl;
@override @useResult
$Res call({
 MarketplaceStatus status, List<MarketListing> items, String filterKey, Set<String> pendingSoldIds, Set<String> pendingDeleteIds, bool isCreating
});




}
/// @nodoc
class __$MarketplaceStateCopyWithImpl<$Res>
    implements _$MarketplaceStateCopyWith<$Res> {
  __$MarketplaceStateCopyWithImpl(this._self, this._then);

  final _MarketplaceState _self;
  final $Res Function(_MarketplaceState) _then;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? filterKey = null,Object? pendingSoldIds = null,Object? pendingDeleteIds = null,Object? isCreating = null,}) {
  return _then(_MarketplaceState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MarketplaceStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MarketListing>,filterKey: null == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String,pendingSoldIds: null == pendingSoldIds ? _self._pendingSoldIds : pendingSoldIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingDeleteIds: null == pendingDeleteIds ? _self._pendingDeleteIds : pendingDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
