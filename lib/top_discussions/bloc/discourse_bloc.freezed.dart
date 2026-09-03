// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discourse_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscourseState {

 TopTopicsResponse? get topTopics; DiscourseStatus get status; bool get isLoadingMore; bool get loadMoreFailed; int get page;
/// Create a copy of DiscourseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscourseStateCopyWith<DiscourseState> get copyWith => _$DiscourseStateCopyWithImpl<DiscourseState>(this as DiscourseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscourseState&&(identical(other.topTopics, topTopics) || other.topTopics == topTopics)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreFailed, loadMoreFailed) || other.loadMoreFailed == loadMoreFailed)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode => Object.hash(runtimeType,topTopics,status,isLoadingMore,loadMoreFailed,page);

@override
String toString() {
  return 'DiscourseState(topTopics: $topTopics, status: $status, isLoadingMore: $isLoadingMore, loadMoreFailed: $loadMoreFailed, page: $page)';
}


}

/// @nodoc
abstract mixin class $DiscourseStateCopyWith<$Res>  {
  factory $DiscourseStateCopyWith(DiscourseState value, $Res Function(DiscourseState) _then) = _$DiscourseStateCopyWithImpl;
@useResult
$Res call({
 TopTopicsResponse? topTopics, DiscourseStatus status, bool isLoadingMore, bool loadMoreFailed, int page
});


$TopTopicsResponseCopyWith<$Res>? get topTopics;

}
/// @nodoc
class _$DiscourseStateCopyWithImpl<$Res>
    implements $DiscourseStateCopyWith<$Res> {
  _$DiscourseStateCopyWithImpl(this._self, this._then);

  final DiscourseState _self;
  final $Res Function(DiscourseState) _then;

/// Create a copy of DiscourseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topTopics = freezed,Object? status = null,Object? isLoadingMore = null,Object? loadMoreFailed = null,Object? page = null,}) {
  return _then(_self.copyWith(
topTopics: freezed == topTopics ? _self.topTopics : topTopics // ignore: cast_nullable_to_non_nullable
as TopTopicsResponse?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscourseStatus,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailed: null == loadMoreFailed ? _self.loadMoreFailed : loadMoreFailed // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DiscourseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TopTopicsResponseCopyWith<$Res>? get topTopics {
    if (_self.topTopics == null) {
    return null;
  }

  return $TopTopicsResponseCopyWith<$Res>(_self.topTopics!, (value) {
    return _then(_self.copyWith(topTopics: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiscourseState].
extension DiscourseStatePatterns on DiscourseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscourseState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscourseState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscourseState value)  $default,){
final _that = this;
switch (_that) {
case _DiscourseState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscourseState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscourseState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TopTopicsResponse? topTopics,  DiscourseStatus status,  bool isLoadingMore,  bool loadMoreFailed,  int page)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscourseState() when $default != null:
return $default(_that.topTopics,_that.status,_that.isLoadingMore,_that.loadMoreFailed,_that.page);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TopTopicsResponse? topTopics,  DiscourseStatus status,  bool isLoadingMore,  bool loadMoreFailed,  int page)  $default,) {final _that = this;
switch (_that) {
case _DiscourseState():
return $default(_that.topTopics,_that.status,_that.isLoadingMore,_that.loadMoreFailed,_that.page);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TopTopicsResponse? topTopics,  DiscourseStatus status,  bool isLoadingMore,  bool loadMoreFailed,  int page)?  $default,) {final _that = this;
switch (_that) {
case _DiscourseState() when $default != null:
return $default(_that.topTopics,_that.status,_that.isLoadingMore,_that.loadMoreFailed,_that.page);case _:
  return null;

}
}

}

/// @nodoc


class _DiscourseState extends DiscourseState {
  const _DiscourseState({this.topTopics, this.status = DiscourseStatus.initial, this.isLoadingMore = false, this.loadMoreFailed = false, this.page = 0}): super._();


@override final  TopTopicsResponse? topTopics;
@override@JsonKey() final  DiscourseStatus status;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool loadMoreFailed;
@override@JsonKey() final  int page;

/// Create a copy of DiscourseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscourseStateCopyWith<_DiscourseState> get copyWith => __$DiscourseStateCopyWithImpl<_DiscourseState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscourseState&&(identical(other.topTopics, topTopics) || other.topTopics == topTopics)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreFailed, loadMoreFailed) || other.loadMoreFailed == loadMoreFailed)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode => Object.hash(runtimeType,topTopics,status,isLoadingMore,loadMoreFailed,page);

@override
String toString() {
  return 'DiscourseState(topTopics: $topTopics, status: $status, isLoadingMore: $isLoadingMore, loadMoreFailed: $loadMoreFailed, page: $page)';
}


}

/// @nodoc
abstract mixin class _$DiscourseStateCopyWith<$Res> implements $DiscourseStateCopyWith<$Res> {
  factory _$DiscourseStateCopyWith(_DiscourseState value, $Res Function(_DiscourseState) _then) = __$DiscourseStateCopyWithImpl;
@override @useResult
$Res call({
 TopTopicsResponse? topTopics, DiscourseStatus status, bool isLoadingMore, bool loadMoreFailed, int page
});


@override $TopTopicsResponseCopyWith<$Res>? get topTopics;

}
/// @nodoc
class __$DiscourseStateCopyWithImpl<$Res>
    implements _$DiscourseStateCopyWith<$Res> {
  __$DiscourseStateCopyWithImpl(this._self, this._then);

  final _DiscourseState _self;
  final $Res Function(_DiscourseState) _then;

/// Create a copy of DiscourseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topTopics = freezed,Object? status = null,Object? isLoadingMore = null,Object? loadMoreFailed = null,Object? page = null,}) {
  return _then(_DiscourseState(
topTopics: freezed == topTopics ? _self.topTopics : topTopics // ignore: cast_nullable_to_non_nullable
as TopTopicsResponse?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscourseStatus,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailed: null == loadMoreFailed ? _self.loadMoreFailed : loadMoreFailed // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DiscourseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TopTopicsResponseCopyWith<$Res>? get topTopics {
    if (_self.topTopics == null) {
    return null;
  }

  return $TopTopicsResponseCopyWith<$Res>(_self.topTopics!, (value) {
    return _then(_self.copyWith(topTopics: value));
  });
}
}

// dart format on
