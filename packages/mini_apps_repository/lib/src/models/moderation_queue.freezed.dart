// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_queue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportedMiniApp {

 MiniApp get app; List<MiniAppReport> get reports;
/// Create a copy of ReportedMiniApp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportedMiniAppCopyWith<ReportedMiniApp> get copyWith => _$ReportedMiniAppCopyWithImpl<ReportedMiniApp>(this as ReportedMiniApp, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportedMiniApp&&(identical(other.app, app) || other.app == app)&&const DeepCollectionEquality().equals(other.reports, reports));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,app,const DeepCollectionEquality().hash(reports));

@override
String toString() {
  return 'ReportedMiniApp(app: $app, reports: $reports)';
}


}

/// @nodoc
abstract mixin class $ReportedMiniAppCopyWith<$Res>  {
  factory $ReportedMiniAppCopyWith(ReportedMiniApp value, $Res Function(ReportedMiniApp) _then) = _$ReportedMiniAppCopyWithImpl;
@useResult
$Res call({
 MiniApp app, List<MiniAppReport> reports
});


$MiniAppCopyWith<$Res> get app;

}
/// @nodoc
class _$ReportedMiniAppCopyWithImpl<$Res>
    implements $ReportedMiniAppCopyWith<$Res> {
  _$ReportedMiniAppCopyWithImpl(this._self, this._then);

  final ReportedMiniApp _self;
  final $Res Function(ReportedMiniApp) _then;

/// Create a copy of ReportedMiniApp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? app = null,Object? reports = null,}) {
  return _then(_self.copyWith(
app: null == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as MiniApp,reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as List<MiniAppReport>,
  ));
}
/// Create a copy of ReportedMiniApp
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MiniAppCopyWith<$Res> get app {

  return $MiniAppCopyWith<$Res>(_self.app, (value) {
    return _then(_self.copyWith(app: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportedMiniApp].
extension ReportedMiniAppPatterns on ReportedMiniApp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportedMiniApp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportedMiniApp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportedMiniApp value)  $default,){
final _that = this;
switch (_that) {
case _ReportedMiniApp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportedMiniApp value)?  $default,){
final _that = this;
switch (_that) {
case _ReportedMiniApp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MiniApp app,  List<MiniAppReport> reports)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportedMiniApp() when $default != null:
return $default(_that.app,_that.reports);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MiniApp app,  List<MiniAppReport> reports)  $default,) {final _that = this;
switch (_that) {
case _ReportedMiniApp():
return $default(_that.app,_that.reports);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MiniApp app,  List<MiniAppReport> reports)?  $default,) {final _that = this;
switch (_that) {
case _ReportedMiniApp() when $default != null:
return $default(_that.app,_that.reports);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ReportedMiniApp implements ReportedMiniApp {
  const _ReportedMiniApp({required this.app, final  List<MiniAppReport> reports = const <MiniAppReport>[]}): _reports = reports;
  factory _ReportedMiniApp.fromJson(Map<String, dynamic> json) => _$ReportedMiniAppFromJson(json);

@override final  MiniApp app;
 final  List<MiniAppReport> _reports;
@override@JsonKey() List<MiniAppReport> get reports {
  if (_reports is EqualUnmodifiableListView) return _reports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reports);
}


/// Create a copy of ReportedMiniApp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportedMiniAppCopyWith<_ReportedMiniApp> get copyWith => __$ReportedMiniAppCopyWithImpl<_ReportedMiniApp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportedMiniApp&&(identical(other.app, app) || other.app == app)&&const DeepCollectionEquality().equals(other._reports, _reports));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,app,const DeepCollectionEquality().hash(_reports));

@override
String toString() {
  return 'ReportedMiniApp(app: $app, reports: $reports)';
}


}

/// @nodoc
abstract mixin class _$ReportedMiniAppCopyWith<$Res> implements $ReportedMiniAppCopyWith<$Res> {
  factory _$ReportedMiniAppCopyWith(_ReportedMiniApp value, $Res Function(_ReportedMiniApp) _then) = __$ReportedMiniAppCopyWithImpl;
@override @useResult
$Res call({
 MiniApp app, List<MiniAppReport> reports
});


@override $MiniAppCopyWith<$Res> get app;

}
/// @nodoc
class __$ReportedMiniAppCopyWithImpl<$Res>
    implements _$ReportedMiniAppCopyWith<$Res> {
  __$ReportedMiniAppCopyWithImpl(this._self, this._then);

  final _ReportedMiniApp _self;
  final $Res Function(_ReportedMiniApp) _then;

/// Create a copy of ReportedMiniApp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? app = null,Object? reports = null,}) {
  return _then(_ReportedMiniApp(
app: null == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as MiniApp,reports: null == reports ? _self._reports : reports // ignore: cast_nullable_to_non_nullable
as List<MiniAppReport>,
  ));
}

/// Create a copy of ReportedMiniApp
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MiniAppCopyWith<$Res> get app {

  return $MiniAppCopyWith<$Res>(_self.app, (value) {
    return _then(_self.copyWith(app: value));
  });
}
}


/// @nodoc
mixin _$MiniAppsModerationQueue {

 List<MiniApp> get pending; List<ReportedMiniApp> get reported;
/// Create a copy of MiniAppsModerationQueue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppsModerationQueueCopyWith<MiniAppsModerationQueue> get copyWith => _$MiniAppsModerationQueueCopyWithImpl<MiniAppsModerationQueue>(this as MiniAppsModerationQueue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppsModerationQueue&&const DeepCollectionEquality().equals(other.pending, pending)&&const DeepCollectionEquality().equals(other.reported, reported));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pending),const DeepCollectionEquality().hash(reported));

@override
String toString() {
  return 'MiniAppsModerationQueue(pending: $pending, reported: $reported)';
}


}

/// @nodoc
abstract mixin class $MiniAppsModerationQueueCopyWith<$Res>  {
  factory $MiniAppsModerationQueueCopyWith(MiniAppsModerationQueue value, $Res Function(MiniAppsModerationQueue) _then) = _$MiniAppsModerationQueueCopyWithImpl;
@useResult
$Res call({
 List<MiniApp> pending, List<ReportedMiniApp> reported
});




}
/// @nodoc
class _$MiniAppsModerationQueueCopyWithImpl<$Res>
    implements $MiniAppsModerationQueueCopyWith<$Res> {
  _$MiniAppsModerationQueueCopyWithImpl(this._self, this._then);

  final MiniAppsModerationQueue _self;
  final $Res Function(MiniAppsModerationQueue) _then;

/// Create a copy of MiniAppsModerationQueue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pending = null,Object? reported = null,}) {
  return _then(_self.copyWith(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as List<MiniApp>,reported: null == reported ? _self.reported : reported // ignore: cast_nullable_to_non_nullable
as List<ReportedMiniApp>,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppsModerationQueue].
extension MiniAppsModerationQueuePatterns on MiniAppsModerationQueue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppsModerationQueue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppsModerationQueue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppsModerationQueue value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppsModerationQueue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppsModerationQueue value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppsModerationQueue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MiniApp> pending,  List<ReportedMiniApp> reported)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppsModerationQueue() when $default != null:
return $default(_that.pending,_that.reported);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MiniApp> pending,  List<ReportedMiniApp> reported)  $default,) {final _that = this;
switch (_that) {
case _MiniAppsModerationQueue():
return $default(_that.pending,_that.reported);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MiniApp> pending,  List<ReportedMiniApp> reported)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppsModerationQueue() when $default != null:
return $default(_that.pending,_that.reported);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _MiniAppsModerationQueue extends MiniAppsModerationQueue {
  const _MiniAppsModerationQueue({final  List<MiniApp> pending = const <MiniApp>[], final  List<ReportedMiniApp> reported = const <ReportedMiniApp>[]}): _pending = pending,_reported = reported,super._();
  factory _MiniAppsModerationQueue.fromJson(Map<String, dynamic> json) => _$MiniAppsModerationQueueFromJson(json);

 final  List<MiniApp> _pending;
@override@JsonKey() List<MiniApp> get pending {
  if (_pending is EqualUnmodifiableListView) return _pending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pending);
}

 final  List<ReportedMiniApp> _reported;
@override@JsonKey() List<ReportedMiniApp> get reported {
  if (_reported is EqualUnmodifiableListView) return _reported;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reported);
}


/// Create a copy of MiniAppsModerationQueue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppsModerationQueueCopyWith<_MiniAppsModerationQueue> get copyWith => __$MiniAppsModerationQueueCopyWithImpl<_MiniAppsModerationQueue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppsModerationQueue&&const DeepCollectionEquality().equals(other._pending, _pending)&&const DeepCollectionEquality().equals(other._reported, _reported));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pending),const DeepCollectionEquality().hash(_reported));

@override
String toString() {
  return 'MiniAppsModerationQueue(pending: $pending, reported: $reported)';
}


}

/// @nodoc
abstract mixin class _$MiniAppsModerationQueueCopyWith<$Res> implements $MiniAppsModerationQueueCopyWith<$Res> {
  factory _$MiniAppsModerationQueueCopyWith(_MiniAppsModerationQueue value, $Res Function(_MiniAppsModerationQueue) _then) = __$MiniAppsModerationQueueCopyWithImpl;
@override @useResult
$Res call({
 List<MiniApp> pending, List<ReportedMiniApp> reported
});




}
/// @nodoc
class __$MiniAppsModerationQueueCopyWithImpl<$Res>
    implements _$MiniAppsModerationQueueCopyWith<$Res> {
  __$MiniAppsModerationQueueCopyWithImpl(this._self, this._then);

  final _MiniAppsModerationQueue _self;
  final $Res Function(_MiniAppsModerationQueue) _then;

/// Create a copy of MiniAppsModerationQueue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pending = null,Object? reported = null,}) {
  return _then(_MiniAppsModerationQueue(
pending: null == pending ? _self._pending : pending // ignore: cast_nullable_to_non_nullable
as List<MiniApp>,reported: null == reported ? _self._reported : reported // ignore: cast_nullable_to_non_nullable
as List<ReportedMiniApp>,
  ));
}


}

// dart format on
