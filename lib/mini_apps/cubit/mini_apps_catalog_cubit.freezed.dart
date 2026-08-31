// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_apps_catalog_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MiniAppsCatalogState {

 MiniAppsCatalogStatus get status; List<MiniApp> get apps; List<MiniApp> get myApps; List<MiniApp> get recents; MiniAppSort get sort; MiniAppCategory? get category; String get query; bool get isSearching; bool get showHidden; bool get isModerator;
/// Create a copy of MiniAppsCatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppsCatalogStateCopyWith<MiniAppsCatalogState> get copyWith => _$MiniAppsCatalogStateCopyWithImpl<MiniAppsCatalogState>(this as MiniAppsCatalogState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppsCatalogState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.apps, apps)&&const DeepCollectionEquality().equals(other.myApps, myApps)&&const DeepCollectionEquality().equals(other.recents, recents)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.category, category) || other.category == category)&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.showHidden, showHidden) || other.showHidden == showHidden)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(apps),const DeepCollectionEquality().hash(myApps),const DeepCollectionEquality().hash(recents),sort,category,query,isSearching,showHidden,isModerator);

@override
String toString() {
  return 'MiniAppsCatalogState(status: $status, apps: $apps, myApps: $myApps, recents: $recents, sort: $sort, category: $category, query: $query, isSearching: $isSearching, showHidden: $showHidden, isModerator: $isModerator)';
}


}

/// @nodoc
abstract mixin class $MiniAppsCatalogStateCopyWith<$Res>  {
  factory $MiniAppsCatalogStateCopyWith(MiniAppsCatalogState value, $Res Function(MiniAppsCatalogState) _then) = _$MiniAppsCatalogStateCopyWithImpl;
@useResult
$Res call({
 MiniAppsCatalogStatus status, List<MiniApp> apps, List<MiniApp> myApps, List<MiniApp> recents, MiniAppSort sort, MiniAppCategory? category, String query, bool isSearching, bool showHidden, bool isModerator
});




}
/// @nodoc
class _$MiniAppsCatalogStateCopyWithImpl<$Res>
    implements $MiniAppsCatalogStateCopyWith<$Res> {
  _$MiniAppsCatalogStateCopyWithImpl(this._self, this._then);

  final MiniAppsCatalogState _self;
  final $Res Function(MiniAppsCatalogState) _then;

/// Create a copy of MiniAppsCatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? apps = null,Object? myApps = null,Object? recents = null,Object? sort = null,Object? category = freezed,Object? query = null,Object? isSearching = null,Object? showHidden = null,Object? isModerator = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppsCatalogStatus,apps: null == apps ? _self.apps : apps // ignore: cast_nullable_to_non_nullable
as List<MiniApp>,myApps: null == myApps ? _self.myApps : myApps // ignore: cast_nullable_to_non_nullable
as List<MiniApp>,recents: null == recents ? _self.recents : recents // ignore: cast_nullable_to_non_nullable
as List<MiniApp>,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as MiniAppSort,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MiniAppCategory?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,showHidden: null == showHidden ? _self.showHidden : showHidden // ignore: cast_nullable_to_non_nullable
as bool,isModerator: null == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppsCatalogState].
extension MiniAppsCatalogStatePatterns on MiniAppsCatalogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppsCatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppsCatalogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppsCatalogState value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppsCatalogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppsCatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppsCatalogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MiniAppsCatalogStatus status,  List<MiniApp> apps,  List<MiniApp> myApps,  List<MiniApp> recents,  MiniAppSort sort,  MiniAppCategory? category,  String query,  bool isSearching,  bool showHidden,  bool isModerator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppsCatalogState() when $default != null:
return $default(_that.status,_that.apps,_that.myApps,_that.recents,_that.sort,_that.category,_that.query,_that.isSearching,_that.showHidden,_that.isModerator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MiniAppsCatalogStatus status,  List<MiniApp> apps,  List<MiniApp> myApps,  List<MiniApp> recents,  MiniAppSort sort,  MiniAppCategory? category,  String query,  bool isSearching,  bool showHidden,  bool isModerator)  $default,) {final _that = this;
switch (_that) {
case _MiniAppsCatalogState():
return $default(_that.status,_that.apps,_that.myApps,_that.recents,_that.sort,_that.category,_that.query,_that.isSearching,_that.showHidden,_that.isModerator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MiniAppsCatalogStatus status,  List<MiniApp> apps,  List<MiniApp> myApps,  List<MiniApp> recents,  MiniAppSort sort,  MiniAppCategory? category,  String query,  bool isSearching,  bool showHidden,  bool isModerator)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppsCatalogState() when $default != null:
return $default(_that.status,_that.apps,_that.myApps,_that.recents,_that.sort,_that.category,_that.query,_that.isSearching,_that.showHidden,_that.isModerator);case _:
  return null;

}
}

}

/// @nodoc


class _MiniAppsCatalogState implements MiniAppsCatalogState {
  const _MiniAppsCatalogState({this.status = MiniAppsCatalogStatus.initial, final  List<MiniApp> apps = const <MiniApp>[], final  List<MiniApp> myApps = const <MiniApp>[], final  List<MiniApp> recents = const <MiniApp>[], this.sort = MiniAppSort.popular, this.category, this.query = '', this.isSearching = false, this.showHidden = false, this.isModerator = false}): _apps = apps,_myApps = myApps,_recents = recents;


@override@JsonKey() final  MiniAppsCatalogStatus status;
 final  List<MiniApp> _apps;
@override@JsonKey() List<MiniApp> get apps {
  if (_apps is EqualUnmodifiableListView) return _apps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_apps);
}

 final  List<MiniApp> _myApps;
@override@JsonKey() List<MiniApp> get myApps {
  if (_myApps is EqualUnmodifiableListView) return _myApps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_myApps);
}

 final  List<MiniApp> _recents;
@override@JsonKey() List<MiniApp> get recents {
  if (_recents is EqualUnmodifiableListView) return _recents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recents);
}

@override@JsonKey() final  MiniAppSort sort;
@override final  MiniAppCategory? category;
@override@JsonKey() final  String query;
@override@JsonKey() final  bool isSearching;
@override@JsonKey() final  bool showHidden;
@override@JsonKey() final  bool isModerator;

/// Create a copy of MiniAppsCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppsCatalogStateCopyWith<_MiniAppsCatalogState> get copyWith => __$MiniAppsCatalogStateCopyWithImpl<_MiniAppsCatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppsCatalogState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._apps, _apps)&&const DeepCollectionEquality().equals(other._myApps, _myApps)&&const DeepCollectionEquality().equals(other._recents, _recents)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.category, category) || other.category == category)&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.showHidden, showHidden) || other.showHidden == showHidden)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_apps),const DeepCollectionEquality().hash(_myApps),const DeepCollectionEquality().hash(_recents),sort,category,query,isSearching,showHidden,isModerator);

@override
String toString() {
  return 'MiniAppsCatalogState(status: $status, apps: $apps, myApps: $myApps, recents: $recents, sort: $sort, category: $category, query: $query, isSearching: $isSearching, showHidden: $showHidden, isModerator: $isModerator)';
}


}

/// @nodoc
abstract mixin class _$MiniAppsCatalogStateCopyWith<$Res> implements $MiniAppsCatalogStateCopyWith<$Res> {
  factory _$MiniAppsCatalogStateCopyWith(_MiniAppsCatalogState value, $Res Function(_MiniAppsCatalogState) _then) = __$MiniAppsCatalogStateCopyWithImpl;
@override @useResult
$Res call({
 MiniAppsCatalogStatus status, List<MiniApp> apps, List<MiniApp> myApps, List<MiniApp> recents, MiniAppSort sort, MiniAppCategory? category, String query, bool isSearching, bool showHidden, bool isModerator
});




}
/// @nodoc
class __$MiniAppsCatalogStateCopyWithImpl<$Res>
    implements _$MiniAppsCatalogStateCopyWith<$Res> {
  __$MiniAppsCatalogStateCopyWithImpl(this._self, this._then);

  final _MiniAppsCatalogState _self;
  final $Res Function(_MiniAppsCatalogState) _then;

/// Create a copy of MiniAppsCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? apps = null,Object? myApps = null,Object? recents = null,Object? sort = null,Object? category = freezed,Object? query = null,Object? isSearching = null,Object? showHidden = null,Object? isModerator = null,}) {
  return _then(_MiniAppsCatalogState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppsCatalogStatus,apps: null == apps ? _self._apps : apps // ignore: cast_nullable_to_non_nullable
as List<MiniApp>,myApps: null == myApps ? _self._myApps : myApps // ignore: cast_nullable_to_non_nullable
as List<MiniApp>,recents: null == recents ? _self._recents : recents // ignore: cast_nullable_to_non_nullable
as List<MiniApp>,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as MiniAppSort,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MiniAppCategory?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,showHidden: null == showHidden ? _self.showHidden : showHidden // ignore: cast_nullable_to_non_nullable
as bool,isModerator: null == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
