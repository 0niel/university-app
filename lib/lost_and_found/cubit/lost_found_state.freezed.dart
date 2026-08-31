// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_found_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LostFoundState {

 LostFoundStatus get status; List<LostFoundItem> get items; LostFoundItemStatus get tab; String get category; String get query; bool get isSearching; Set<String> get pendingStatusIds; Set<String> get pendingDeleteIds; bool get isCreating; int get cleanupWarningRevision;
/// Create a copy of LostFoundState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LostFoundStateCopyWith<LostFoundState> get copyWith => _$LostFoundStateCopyWithImpl<LostFoundState>(this as LostFoundState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LostFoundState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.category, category) || other.category == category)&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&const DeepCollectionEquality().equals(other.pendingStatusIds, pendingStatusIds)&&const DeepCollectionEquality().equals(other.pendingDeleteIds, pendingDeleteIds)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating)&&(identical(other.cleanupWarningRevision, cleanupWarningRevision) || other.cleanupWarningRevision == cleanupWarningRevision));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),tab,category,query,isSearching,const DeepCollectionEquality().hash(pendingStatusIds),const DeepCollectionEquality().hash(pendingDeleteIds),isCreating,cleanupWarningRevision);

@override
String toString() {
  return 'LostFoundState(status: $status, items: $items, tab: $tab, category: $category, query: $query, isSearching: $isSearching, pendingStatusIds: $pendingStatusIds, pendingDeleteIds: $pendingDeleteIds, isCreating: $isCreating, cleanupWarningRevision: $cleanupWarningRevision)';
}


}

/// @nodoc
abstract mixin class $LostFoundStateCopyWith<$Res>  {
  factory $LostFoundStateCopyWith(LostFoundState value, $Res Function(LostFoundState) _then) = _$LostFoundStateCopyWithImpl;
@useResult
$Res call({
 LostFoundStatus status, List<LostFoundItem> items, LostFoundItemStatus tab, String category, String query, bool isSearching, Set<String> pendingStatusIds, Set<String> pendingDeleteIds, bool isCreating, int cleanupWarningRevision
});




}
/// @nodoc
class _$LostFoundStateCopyWithImpl<$Res>
    implements $LostFoundStateCopyWith<$Res> {
  _$LostFoundStateCopyWithImpl(this._self, this._then);

  final LostFoundState _self;
  final $Res Function(LostFoundState) _then;

/// Create a copy of LostFoundState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? tab = null,Object? category = null,Object? query = null,Object? isSearching = null,Object? pendingStatusIds = null,Object? pendingDeleteIds = null,Object? isCreating = null,Object? cleanupWarningRevision = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LostFoundStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LostFoundItem>,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as LostFoundItemStatus,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,pendingStatusIds: null == pendingStatusIds ? _self.pendingStatusIds : pendingStatusIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingDeleteIds: null == pendingDeleteIds ? _self.pendingDeleteIds : pendingDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,cleanupWarningRevision: null == cleanupWarningRevision ? _self.cleanupWarningRevision : cleanupWarningRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LostFoundState].
extension LostFoundStatePatterns on LostFoundState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LostFoundState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LostFoundState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LostFoundState value)  $default,){
final _that = this;
switch (_that) {
case _LostFoundState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LostFoundState value)?  $default,){
final _that = this;
switch (_that) {
case _LostFoundState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LostFoundStatus status,  List<LostFoundItem> items,  LostFoundItemStatus tab,  String category,  String query,  bool isSearching,  Set<String> pendingStatusIds,  Set<String> pendingDeleteIds,  bool isCreating,  int cleanupWarningRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LostFoundState() when $default != null:
return $default(_that.status,_that.items,_that.tab,_that.category,_that.query,_that.isSearching,_that.pendingStatusIds,_that.pendingDeleteIds,_that.isCreating,_that.cleanupWarningRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LostFoundStatus status,  List<LostFoundItem> items,  LostFoundItemStatus tab,  String category,  String query,  bool isSearching,  Set<String> pendingStatusIds,  Set<String> pendingDeleteIds,  bool isCreating,  int cleanupWarningRevision)  $default,) {final _that = this;
switch (_that) {
case _LostFoundState():
return $default(_that.status,_that.items,_that.tab,_that.category,_that.query,_that.isSearching,_that.pendingStatusIds,_that.pendingDeleteIds,_that.isCreating,_that.cleanupWarningRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LostFoundStatus status,  List<LostFoundItem> items,  LostFoundItemStatus tab,  String category,  String query,  bool isSearching,  Set<String> pendingStatusIds,  Set<String> pendingDeleteIds,  bool isCreating,  int cleanupWarningRevision)?  $default,) {final _that = this;
switch (_that) {
case _LostFoundState() when $default != null:
return $default(_that.status,_that.items,_that.tab,_that.category,_that.query,_that.isSearching,_that.pendingStatusIds,_that.pendingDeleteIds,_that.isCreating,_that.cleanupWarningRevision);case _:
  return null;

}
}

}

/// @nodoc


class _LostFoundState extends LostFoundState {
  const _LostFoundState({this.status = LostFoundStatus.initial, final  List<LostFoundItem> items = const <LostFoundItem>[], this.tab = LostFoundItemStatus.found, this.category = 'all', this.query = '', this.isSearching = false, final  Set<String> pendingStatusIds = const <String>{}, final  Set<String> pendingDeleteIds = const <String>{}, this.isCreating = false, this.cleanupWarningRevision = 0}): _items = items,_pendingStatusIds = pendingStatusIds,_pendingDeleteIds = pendingDeleteIds,super._();


@override@JsonKey() final  LostFoundStatus status;
 final  List<LostFoundItem> _items;
@override@JsonKey() List<LostFoundItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  LostFoundItemStatus tab;
@override@JsonKey() final  String category;
@override@JsonKey() final  String query;
@override@JsonKey() final  bool isSearching;
 final  Set<String> _pendingStatusIds;
@override@JsonKey() Set<String> get pendingStatusIds {
  if (_pendingStatusIds is EqualUnmodifiableSetView) return _pendingStatusIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingStatusIds);
}

 final  Set<String> _pendingDeleteIds;
@override@JsonKey() Set<String> get pendingDeleteIds {
  if (_pendingDeleteIds is EqualUnmodifiableSetView) return _pendingDeleteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingDeleteIds);
}

@override@JsonKey() final  bool isCreating;
@override@JsonKey() final  int cleanupWarningRevision;

/// Create a copy of LostFoundState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LostFoundStateCopyWith<_LostFoundState> get copyWith => __$LostFoundStateCopyWithImpl<_LostFoundState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LostFoundState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.category, category) || other.category == category)&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&const DeepCollectionEquality().equals(other._pendingStatusIds, _pendingStatusIds)&&const DeepCollectionEquality().equals(other._pendingDeleteIds, _pendingDeleteIds)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating)&&(identical(other.cleanupWarningRevision, cleanupWarningRevision) || other.cleanupWarningRevision == cleanupWarningRevision));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),tab,category,query,isSearching,const DeepCollectionEquality().hash(_pendingStatusIds),const DeepCollectionEquality().hash(_pendingDeleteIds),isCreating,cleanupWarningRevision);

@override
String toString() {
  return 'LostFoundState(status: $status, items: $items, tab: $tab, category: $category, query: $query, isSearching: $isSearching, pendingStatusIds: $pendingStatusIds, pendingDeleteIds: $pendingDeleteIds, isCreating: $isCreating, cleanupWarningRevision: $cleanupWarningRevision)';
}


}

/// @nodoc
abstract mixin class _$LostFoundStateCopyWith<$Res> implements $LostFoundStateCopyWith<$Res> {
  factory _$LostFoundStateCopyWith(_LostFoundState value, $Res Function(_LostFoundState) _then) = __$LostFoundStateCopyWithImpl;
@override @useResult
$Res call({
 LostFoundStatus status, List<LostFoundItem> items, LostFoundItemStatus tab, String category, String query, bool isSearching, Set<String> pendingStatusIds, Set<String> pendingDeleteIds, bool isCreating, int cleanupWarningRevision
});




}
/// @nodoc
class __$LostFoundStateCopyWithImpl<$Res>
    implements _$LostFoundStateCopyWith<$Res> {
  __$LostFoundStateCopyWithImpl(this._self, this._then);

  final _LostFoundState _self;
  final $Res Function(_LostFoundState) _then;

/// Create a copy of LostFoundState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? tab = null,Object? category = null,Object? query = null,Object? isSearching = null,Object? pendingStatusIds = null,Object? pendingDeleteIds = null,Object? isCreating = null,Object? cleanupWarningRevision = null,}) {
  return _then(_LostFoundState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LostFoundStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LostFoundItem>,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as LostFoundItemStatus,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,pendingStatusIds: null == pendingStatusIds ? _self._pendingStatusIds : pendingStatusIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingDeleteIds: null == pendingDeleteIds ? _self._pendingDeleteIds : pendingDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,cleanupWarningRevision: null == cleanupWarningRevision ? _self.cleanupWarningRevision : cleanupWarningRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
