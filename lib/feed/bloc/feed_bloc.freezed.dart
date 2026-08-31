// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent()';
}


}

/// @nodoc
class $FeedEventCopyWith<$Res>  {
$FeedEventCopyWith(FeedEvent _, $Res Function(FeedEvent) __);
}


/// Adds pattern-matching-related methods to [FeedEvent].
extension FeedEventPatterns on FeedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FeedRequested value)?  requested,TResult Function( FeedRefreshRequested value)?  refreshRequested,TResult Function( FeedResumed value)?  resumed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FeedRequested() when requested != null:
return requested(_that);case FeedRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case FeedResumed() when resumed != null:
return resumed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FeedRequested value)  requested,required TResult Function( FeedRefreshRequested value)  refreshRequested,required TResult Function( FeedResumed value)  resumed,}){
final _that = this;
switch (_that) {
case FeedRequested():
return requested(_that);case FeedRefreshRequested():
return refreshRequested(_that);case FeedResumed():
return resumed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FeedRequested value)?  requested,TResult? Function( FeedRefreshRequested value)?  refreshRequested,TResult? Function( FeedResumed value)?  resumed,}){
final _that = this;
switch (_that) {
case FeedRequested() when requested != null:
return requested(_that);case FeedRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case FeedResumed() when resumed != null:
return resumed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Category category)?  requested,TResult Function( Category category)?  refreshRequested,TResult Function()?  resumed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FeedRequested() when requested != null:
return requested(_that.category);case FeedRefreshRequested() when refreshRequested != null:
return refreshRequested(_that.category);case FeedResumed() when resumed != null:
return resumed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Category category)  requested,required TResult Function( Category category)  refreshRequested,required TResult Function()  resumed,}) {final _that = this;
switch (_that) {
case FeedRequested():
return requested(_that.category);case FeedRefreshRequested():
return refreshRequested(_that.category);case FeedResumed():
return resumed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Category category)?  requested,TResult? Function( Category category)?  refreshRequested,TResult? Function()?  resumed,}) {final _that = this;
switch (_that) {
case FeedRequested() when requested != null:
return requested(_that.category);case FeedRefreshRequested() when refreshRequested != null:
return refreshRequested(_that.category);case FeedResumed() when resumed != null:
return resumed();case _:
  return null;

}
}

}

/// @nodoc


class FeedRequested implements FeedEvent {
  const FeedRequested({required this.category});


 final  Category category;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedRequestedCopyWith<FeedRequested> get copyWith => _$FeedRequestedCopyWithImpl<FeedRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedRequested&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,category);

@override
String toString() {
  return 'FeedEvent.requested(category: $category)';
}


}

/// @nodoc
abstract mixin class $FeedRequestedCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $FeedRequestedCopyWith(FeedRequested value, $Res Function(FeedRequested) _then) = _$FeedRequestedCopyWithImpl;
@useResult
$Res call({
 Category category
});


$CategoryCopyWith<$Res> get category;

}
/// @nodoc
class _$FeedRequestedCopyWithImpl<$Res>
    implements $FeedRequestedCopyWith<$Res> {
  _$FeedRequestedCopyWithImpl(this._self, this._then);

  final FeedRequested _self;
  final $Res Function(FeedRequested) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(FeedRequested(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,
  ));
}

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {

  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

/// @nodoc


class FeedRefreshRequested implements FeedEvent {
  const FeedRefreshRequested({required this.category});


 final  Category category;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedRefreshRequestedCopyWith<FeedRefreshRequested> get copyWith => _$FeedRefreshRequestedCopyWithImpl<FeedRefreshRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedRefreshRequested&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,category);

@override
String toString() {
  return 'FeedEvent.refreshRequested(category: $category)';
}


}

/// @nodoc
abstract mixin class $FeedRefreshRequestedCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $FeedRefreshRequestedCopyWith(FeedRefreshRequested value, $Res Function(FeedRefreshRequested) _then) = _$FeedRefreshRequestedCopyWithImpl;
@useResult
$Res call({
 Category category
});


$CategoryCopyWith<$Res> get category;

}
/// @nodoc
class _$FeedRefreshRequestedCopyWithImpl<$Res>
    implements $FeedRefreshRequestedCopyWith<$Res> {
  _$FeedRefreshRequestedCopyWithImpl(this._self, this._then);

  final FeedRefreshRequested _self;
  final $Res Function(FeedRefreshRequested) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(FeedRefreshRequested(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,
  ));
}

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {

  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

/// @nodoc


class FeedResumed implements FeedEvent {
  const FeedResumed();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedResumed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.resumed()';
}


}





/// @nodoc
mixin _$FeedState {

 FeedStatus get status;@NewsBlockMapConverter() Feed get feed; HasMoreNews get hasMoreNews;
/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedStateCopyWith<FeedState> get copyWith => _$FeedStateCopyWithImpl<FeedState>(this as FeedState, _$identity);

  /// Serializes this FeedState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.feed, feed)&&const DeepCollectionEquality().equals(other.hasMoreNews, hasMoreNews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(feed),const DeepCollectionEquality().hash(hasMoreNews));

@override
String toString() {
  return 'FeedState(status: $status, feed: $feed, hasMoreNews: $hasMoreNews)';
}


}

/// @nodoc
abstract mixin class $FeedStateCopyWith<$Res>  {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) _then) = _$FeedStateCopyWithImpl;
@useResult
$Res call({
 FeedStatus status,@NewsBlockMapConverter() Feed feed, HasMoreNews hasMoreNews
});




}
/// @nodoc
class _$FeedStateCopyWithImpl<$Res>
    implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._self, this._then);

  final FeedState _self;
  final $Res Function(FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? feed = null,Object? hasMoreNews = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedStatus,feed: null == feed ? _self.feed : feed // ignore: cast_nullable_to_non_nullable
as Feed,hasMoreNews: null == hasMoreNews ? _self.hasMoreNews : hasMoreNews // ignore: cast_nullable_to_non_nullable
as HasMoreNews,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedState value)  $default,){
final _that = this;
switch (_that) {
case _FeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FeedStatus status, @NewsBlockMapConverter()  Feed feed,  HasMoreNews hasMoreNews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.status,_that.feed,_that.hasMoreNews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FeedStatus status, @NewsBlockMapConverter()  Feed feed,  HasMoreNews hasMoreNews)  $default,) {final _that = this;
switch (_that) {
case _FeedState():
return $default(_that.status,_that.feed,_that.hasMoreNews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FeedStatus status, @NewsBlockMapConverter()  Feed feed,  HasMoreNews hasMoreNews)?  $default,) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.status,_that.feed,_that.hasMoreNews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedState implements FeedState {
  const _FeedState({this.status = FeedStatus.initial, @NewsBlockMapConverter() final  Feed feed = const <String, List<NewsBlock>>{}, final  HasMoreNews hasMoreNews = const <String, bool>{}}): _feed = feed,_hasMoreNews = hasMoreNews;
  factory _FeedState.fromJson(Map<String, dynamic> json) => _$FeedStateFromJson(json);

@override@JsonKey() final  FeedStatus status;
 final  Feed _feed;
@override@JsonKey()@NewsBlockMapConverter() Feed get feed {
  if (_feed is EqualUnmodifiableMapView) return _feed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_feed);
}

 final  HasMoreNews _hasMoreNews;
@override@JsonKey() HasMoreNews get hasMoreNews {
  if (_hasMoreNews is EqualUnmodifiableMapView) return _hasMoreNews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_hasMoreNews);
}


/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedStateCopyWith<_FeedState> get copyWith => __$FeedStateCopyWithImpl<_FeedState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._feed, _feed)&&const DeepCollectionEquality().equals(other._hasMoreNews, _hasMoreNews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_feed),const DeepCollectionEquality().hash(_hasMoreNews));

@override
String toString() {
  return 'FeedState(status: $status, feed: $feed, hasMoreNews: $hasMoreNews)';
}


}

/// @nodoc
abstract mixin class _$FeedStateCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory _$FeedStateCopyWith(_FeedState value, $Res Function(_FeedState) _then) = __$FeedStateCopyWithImpl;
@override @useResult
$Res call({
 FeedStatus status,@NewsBlockMapConverter() Feed feed, HasMoreNews hasMoreNews
});




}
/// @nodoc
class __$FeedStateCopyWithImpl<$Res>
    implements _$FeedStateCopyWith<$Res> {
  __$FeedStateCopyWithImpl(this._self, this._then);

  final _FeedState _self;
  final $Res Function(_FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? feed = null,Object? hasMoreNews = null,}) {
  return _then(_FeedState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedStatus,feed: null == feed ? _self._feed : feed // ignore: cast_nullable_to_non_nullable
as Feed,hasMoreNews: null == hasMoreNews ? _self._hasMoreNews : hasMoreNews // ignore: cast_nullable_to_non_nullable
as HasMoreNews,
  ));
}


}

// dart format on
