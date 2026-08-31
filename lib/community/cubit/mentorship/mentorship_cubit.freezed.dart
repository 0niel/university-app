// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentorship_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MentorshipState {

 MentorshipStatus get status; MentorRequestsStatus get requestsStatus; List<Mentor> get mentors; List<MentorRequest> get requests; Set<String> get pendingMentorIds; Set<String> get pendingRequestIds; bool get isSavingProfile;
/// Create a copy of MentorshipState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentorshipStateCopyWith<MentorshipState> get copyWith => _$MentorshipStateCopyWithImpl<MentorshipState>(this as MentorshipState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentorshipState&&(identical(other.status, status) || other.status == status)&&(identical(other.requestsStatus, requestsStatus) || other.requestsStatus == requestsStatus)&&const DeepCollectionEquality().equals(other.mentors, mentors)&&const DeepCollectionEquality().equals(other.requests, requests)&&const DeepCollectionEquality().equals(other.pendingMentorIds, pendingMentorIds)&&const DeepCollectionEquality().equals(other.pendingRequestIds, pendingRequestIds)&&(identical(other.isSavingProfile, isSavingProfile) || other.isSavingProfile == isSavingProfile));
}


@override
int get hashCode => Object.hash(runtimeType,status,requestsStatus,const DeepCollectionEquality().hash(mentors),const DeepCollectionEquality().hash(requests),const DeepCollectionEquality().hash(pendingMentorIds),const DeepCollectionEquality().hash(pendingRequestIds),isSavingProfile);

@override
String toString() {
  return 'MentorshipState(status: $status, requestsStatus: $requestsStatus, mentors: $mentors, requests: $requests, pendingMentorIds: $pendingMentorIds, pendingRequestIds: $pendingRequestIds, isSavingProfile: $isSavingProfile)';
}


}

/// @nodoc
abstract mixin class $MentorshipStateCopyWith<$Res>  {
  factory $MentorshipStateCopyWith(MentorshipState value, $Res Function(MentorshipState) _then) = _$MentorshipStateCopyWithImpl;
@useResult
$Res call({
 MentorshipStatus status, MentorRequestsStatus requestsStatus, List<Mentor> mentors, List<MentorRequest> requests, Set<String> pendingMentorIds, Set<String> pendingRequestIds, bool isSavingProfile
});




}
/// @nodoc
class _$MentorshipStateCopyWithImpl<$Res>
    implements $MentorshipStateCopyWith<$Res> {
  _$MentorshipStateCopyWithImpl(this._self, this._then);

  final MentorshipState _self;
  final $Res Function(MentorshipState) _then;

/// Create a copy of MentorshipState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? requestsStatus = null,Object? mentors = null,Object? requests = null,Object? pendingMentorIds = null,Object? pendingRequestIds = null,Object? isSavingProfile = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MentorshipStatus,requestsStatus: null == requestsStatus ? _self.requestsStatus : requestsStatus // ignore: cast_nullable_to_non_nullable
as MentorRequestsStatus,mentors: null == mentors ? _self.mentors : mentors // ignore: cast_nullable_to_non_nullable
as List<Mentor>,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as List<MentorRequest>,pendingMentorIds: null == pendingMentorIds ? _self.pendingMentorIds : pendingMentorIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingRequestIds: null == pendingRequestIds ? _self.pendingRequestIds : pendingRequestIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isSavingProfile: null == isSavingProfile ? _self.isSavingProfile : isSavingProfile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MentorshipState].
extension MentorshipStatePatterns on MentorshipState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentorshipState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentorshipState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentorshipState value)  $default,){
final _that = this;
switch (_that) {
case _MentorshipState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentorshipState value)?  $default,){
final _that = this;
switch (_that) {
case _MentorshipState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MentorshipStatus status,  MentorRequestsStatus requestsStatus,  List<Mentor> mentors,  List<MentorRequest> requests,  Set<String> pendingMentorIds,  Set<String> pendingRequestIds,  bool isSavingProfile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentorshipState() when $default != null:
return $default(_that.status,_that.requestsStatus,_that.mentors,_that.requests,_that.pendingMentorIds,_that.pendingRequestIds,_that.isSavingProfile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MentorshipStatus status,  MentorRequestsStatus requestsStatus,  List<Mentor> mentors,  List<MentorRequest> requests,  Set<String> pendingMentorIds,  Set<String> pendingRequestIds,  bool isSavingProfile)  $default,) {final _that = this;
switch (_that) {
case _MentorshipState():
return $default(_that.status,_that.requestsStatus,_that.mentors,_that.requests,_that.pendingMentorIds,_that.pendingRequestIds,_that.isSavingProfile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MentorshipStatus status,  MentorRequestsStatus requestsStatus,  List<Mentor> mentors,  List<MentorRequest> requests,  Set<String> pendingMentorIds,  Set<String> pendingRequestIds,  bool isSavingProfile)?  $default,) {final _that = this;
switch (_that) {
case _MentorshipState() when $default != null:
return $default(_that.status,_that.requestsStatus,_that.mentors,_that.requests,_that.pendingMentorIds,_that.pendingRequestIds,_that.isSavingProfile);case _:
  return null;

}
}

}

/// @nodoc


class _MentorshipState extends MentorshipState {
  const _MentorshipState({this.status = MentorshipStatus.initial, this.requestsStatus = MentorRequestsStatus.notNeeded, final  List<Mentor> mentors = const <Mentor>[], final  List<MentorRequest> requests = const <MentorRequest>[], final  Set<String> pendingMentorIds = const <String>{}, final  Set<String> pendingRequestIds = const <String>{}, this.isSavingProfile = false}): _mentors = mentors,_requests = requests,_pendingMentorIds = pendingMentorIds,_pendingRequestIds = pendingRequestIds,super._();


@override@JsonKey() final  MentorshipStatus status;
@override@JsonKey() final  MentorRequestsStatus requestsStatus;
 final  List<Mentor> _mentors;
@override@JsonKey() List<Mentor> get mentors {
  if (_mentors is EqualUnmodifiableListView) return _mentors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentors);
}

 final  List<MentorRequest> _requests;
@override@JsonKey() List<MentorRequest> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}

 final  Set<String> _pendingMentorIds;
@override@JsonKey() Set<String> get pendingMentorIds {
  if (_pendingMentorIds is EqualUnmodifiableSetView) return _pendingMentorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingMentorIds);
}

 final  Set<String> _pendingRequestIds;
@override@JsonKey() Set<String> get pendingRequestIds {
  if (_pendingRequestIds is EqualUnmodifiableSetView) return _pendingRequestIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingRequestIds);
}

@override@JsonKey() final  bool isSavingProfile;

/// Create a copy of MentorshipState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentorshipStateCopyWith<_MentorshipState> get copyWith => __$MentorshipStateCopyWithImpl<_MentorshipState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentorshipState&&(identical(other.status, status) || other.status == status)&&(identical(other.requestsStatus, requestsStatus) || other.requestsStatus == requestsStatus)&&const DeepCollectionEquality().equals(other._mentors, _mentors)&&const DeepCollectionEquality().equals(other._requests, _requests)&&const DeepCollectionEquality().equals(other._pendingMentorIds, _pendingMentorIds)&&const DeepCollectionEquality().equals(other._pendingRequestIds, _pendingRequestIds)&&(identical(other.isSavingProfile, isSavingProfile) || other.isSavingProfile == isSavingProfile));
}


@override
int get hashCode => Object.hash(runtimeType,status,requestsStatus,const DeepCollectionEquality().hash(_mentors),const DeepCollectionEquality().hash(_requests),const DeepCollectionEquality().hash(_pendingMentorIds),const DeepCollectionEquality().hash(_pendingRequestIds),isSavingProfile);

@override
String toString() {
  return 'MentorshipState(status: $status, requestsStatus: $requestsStatus, mentors: $mentors, requests: $requests, pendingMentorIds: $pendingMentorIds, pendingRequestIds: $pendingRequestIds, isSavingProfile: $isSavingProfile)';
}


}

/// @nodoc
abstract mixin class _$MentorshipStateCopyWith<$Res> implements $MentorshipStateCopyWith<$Res> {
  factory _$MentorshipStateCopyWith(_MentorshipState value, $Res Function(_MentorshipState) _then) = __$MentorshipStateCopyWithImpl;
@override @useResult
$Res call({
 MentorshipStatus status, MentorRequestsStatus requestsStatus, List<Mentor> mentors, List<MentorRequest> requests, Set<String> pendingMentorIds, Set<String> pendingRequestIds, bool isSavingProfile
});




}
/// @nodoc
class __$MentorshipStateCopyWithImpl<$Res>
    implements _$MentorshipStateCopyWith<$Res> {
  __$MentorshipStateCopyWithImpl(this._self, this._then);

  final _MentorshipState _self;
  final $Res Function(_MentorshipState) _then;

/// Create a copy of MentorshipState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? requestsStatus = null,Object? mentors = null,Object? requests = null,Object? pendingMentorIds = null,Object? pendingRequestIds = null,Object? isSavingProfile = null,}) {
  return _then(_MentorshipState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MentorshipStatus,requestsStatus: null == requestsStatus ? _self.requestsStatus : requestsStatus // ignore: cast_nullable_to_non_nullable
as MentorRequestsStatus,mentors: null == mentors ? _self._mentors : mentors // ignore: cast_nullable_to_non_nullable
as List<Mentor>,requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<MentorRequest>,pendingMentorIds: null == pendingMentorIds ? _self._pendingMentorIds : pendingMentorIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingRequestIds: null == pendingRequestIds ? _self._pendingRequestIds : pendingRequestIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isSavingProfile: null == isSavingProfile ? _self.isSavingProfile : isSavingProfile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
