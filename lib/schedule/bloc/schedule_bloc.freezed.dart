// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleState implements DiagnosticableTreeMixin {

@JsonKey(includeFromJson: false, includeToJson: false) ScheduleStatus get status;@JsonKey(fromJson: _classroomSchedulesFromJson, toJson: _classroomSchedulesToJson) List<(UID, Classroom, List<SchedulePart>)> get classroomsSchedule;@JsonKey(fromJson: _teacherSchedulesFromJson, toJson: _teacherSchedulesToJson) List<(UID, Teacher, List<SchedulePart>)> get teachersSchedule;@JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson) List<(UID, Group, List<SchedulePart>)> get groupsSchedule;@SelectedScheduleConverter() SelectedSchedule? get selectedSchedule;/// When the active schedule was last successfully synced from the server.
/// Persisted so the offline banner can show a truthful "updated at" time.
 DateTime? get lastSyncedAt;/// Last successful fetch time of every saved schedule, keyed by its
/// identifier (`uid ?? name`). Lets the hub show a truthful "обновлено …"
/// line for each saved schedule, not just the active one.
 Map<UID, DateTime> get scheduleSyncedAt;/// Whether the schedule on screen is stale cached data shown because the
/// last refresh failed (no network). Transient — never persisted.
@JsonKey(includeFromJson: false, includeToJson: false) bool get isOffline;
/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleStateCopyWith<ScheduleState> get copyWith => _$ScheduleStateCopyWithImpl<ScheduleState>(this as ScheduleState, _$identity);

  /// Serializes this ScheduleState to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ScheduleState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('classroomsSchedule', classroomsSchedule))..add(DiagnosticsProperty('teachersSchedule', teachersSchedule))..add(DiagnosticsProperty('groupsSchedule', groupsSchedule))..add(DiagnosticsProperty('selectedSchedule', selectedSchedule))..add(DiagnosticsProperty('lastSyncedAt', lastSyncedAt))..add(DiagnosticsProperty('scheduleSyncedAt', scheduleSyncedAt))..add(DiagnosticsProperty('isOffline', isOffline));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.classroomsSchedule, classroomsSchedule)&&const DeepCollectionEquality().equals(other.teachersSchedule, teachersSchedule)&&const DeepCollectionEquality().equals(other.groupsSchedule, groupsSchedule)&&(identical(other.selectedSchedule, selectedSchedule) || other.selectedSchedule == selectedSchedule)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&const DeepCollectionEquality().equals(other.scheduleSyncedAt, scheduleSyncedAt)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(classroomsSchedule),const DeepCollectionEquality().hash(teachersSchedule),const DeepCollectionEquality().hash(groupsSchedule),selectedSchedule,lastSyncedAt,const DeepCollectionEquality().hash(scheduleSyncedAt),isOffline);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ScheduleState(status: $status, classroomsSchedule: $classroomsSchedule, teachersSchedule: $teachersSchedule, groupsSchedule: $groupsSchedule, selectedSchedule: $selectedSchedule, lastSyncedAt: $lastSyncedAt, scheduleSyncedAt: $scheduleSyncedAt, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class $ScheduleStateCopyWith<$Res>  {
  factory $ScheduleStateCopyWith(ScheduleState value, $Res Function(ScheduleState) _then) = _$ScheduleStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) ScheduleStatus status,@JsonKey(fromJson: _classroomSchedulesFromJson, toJson: _classroomSchedulesToJson) List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule,@JsonKey(fromJson: _teacherSchedulesFromJson, toJson: _teacherSchedulesToJson) List<(UID, Teacher, List<SchedulePart>)> teachersSchedule,@JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson) List<(UID, Group, List<SchedulePart>)> groupsSchedule,@SelectedScheduleConverter() SelectedSchedule? selectedSchedule, DateTime? lastSyncedAt, Map<UID, DateTime> scheduleSyncedAt,@JsonKey(includeFromJson: false, includeToJson: false) bool isOffline
});


$SelectedScheduleCopyWith<$Res>? get selectedSchedule;

}
/// @nodoc
class _$ScheduleStateCopyWithImpl<$Res>
    implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._self, this._then);

  final ScheduleState _self;
  final $Res Function(ScheduleState) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? classroomsSchedule = null,Object? teachersSchedule = null,Object? groupsSchedule = null,Object? selectedSchedule = freezed,Object? lastSyncedAt = freezed,Object? scheduleSyncedAt = null,Object? isOffline = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleStatus,classroomsSchedule: null == classroomsSchedule ? _self.classroomsSchedule : classroomsSchedule // ignore: cast_nullable_to_non_nullable
as List<(UID, Classroom, List<SchedulePart>)>,teachersSchedule: null == teachersSchedule ? _self.teachersSchedule : teachersSchedule // ignore: cast_nullable_to_non_nullable
as List<(UID, Teacher, List<SchedulePart>)>,groupsSchedule: null == groupsSchedule ? _self.groupsSchedule : groupsSchedule // ignore: cast_nullable_to_non_nullable
as List<(UID, Group, List<SchedulePart>)>,selectedSchedule: freezed == selectedSchedule ? _self.selectedSchedule : selectedSchedule // ignore: cast_nullable_to_non_nullable
as SelectedSchedule?,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduleSyncedAt: null == scheduleSyncedAt ? _self.scheduleSyncedAt : scheduleSyncedAt // ignore: cast_nullable_to_non_nullable
as Map<UID, DateTime>,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectedScheduleCopyWith<$Res>? get selectedSchedule {
    if (_self.selectedSchedule == null) {
    return null;
  }

  return $SelectedScheduleCopyWith<$Res>(_self.selectedSchedule!, (value) {
    return _then(_self.copyWith(selectedSchedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleState].
extension ScheduleStatePatterns on ScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  ScheduleStatus status, @JsonKey(fromJson: _classroomSchedulesFromJson, toJson: _classroomSchedulesToJson)  List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule, @JsonKey(fromJson: _teacherSchedulesFromJson, toJson: _teacherSchedulesToJson)  List<(UID, Teacher, List<SchedulePart>)> teachersSchedule, @JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson)  List<(UID, Group, List<SchedulePart>)> groupsSchedule, @SelectedScheduleConverter()  SelectedSchedule? selectedSchedule,  DateTime? lastSyncedAt,  Map<UID, DateTime> scheduleSyncedAt, @JsonKey(includeFromJson: false, includeToJson: false)  bool isOffline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
return $default(_that.status,_that.classroomsSchedule,_that.teachersSchedule,_that.groupsSchedule,_that.selectedSchedule,_that.lastSyncedAt,_that.scheduleSyncedAt,_that.isOffline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  ScheduleStatus status, @JsonKey(fromJson: _classroomSchedulesFromJson, toJson: _classroomSchedulesToJson)  List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule, @JsonKey(fromJson: _teacherSchedulesFromJson, toJson: _teacherSchedulesToJson)  List<(UID, Teacher, List<SchedulePart>)> teachersSchedule, @JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson)  List<(UID, Group, List<SchedulePart>)> groupsSchedule, @SelectedScheduleConverter()  SelectedSchedule? selectedSchedule,  DateTime? lastSyncedAt,  Map<UID, DateTime> scheduleSyncedAt, @JsonKey(includeFromJson: false, includeToJson: false)  bool isOffline)  $default,) {final _that = this;
switch (_that) {
case _ScheduleState():
return $default(_that.status,_that.classroomsSchedule,_that.teachersSchedule,_that.groupsSchedule,_that.selectedSchedule,_that.lastSyncedAt,_that.scheduleSyncedAt,_that.isOffline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  ScheduleStatus status, @JsonKey(fromJson: _classroomSchedulesFromJson, toJson: _classroomSchedulesToJson)  List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule, @JsonKey(fromJson: _teacherSchedulesFromJson, toJson: _teacherSchedulesToJson)  List<(UID, Teacher, List<SchedulePart>)> teachersSchedule, @JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson)  List<(UID, Group, List<SchedulePart>)> groupsSchedule, @SelectedScheduleConverter()  SelectedSchedule? selectedSchedule,  DateTime? lastSyncedAt,  Map<UID, DateTime> scheduleSyncedAt, @JsonKey(includeFromJson: false, includeToJson: false)  bool isOffline)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
return $default(_that.status,_that.classroomsSchedule,_that.teachersSchedule,_that.groupsSchedule,_that.selectedSchedule,_that.lastSyncedAt,_that.scheduleSyncedAt,_that.isOffline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleState extends ScheduleState with DiagnosticableTreeMixin {
  const _ScheduleState({@JsonKey(includeFromJson: false, includeToJson: false) this.status = ScheduleStatus.initial, @JsonKey(fromJson: _classroomSchedulesFromJson, toJson: _classroomSchedulesToJson) final  List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule = const [], @JsonKey(fromJson: _teacherSchedulesFromJson, toJson: _teacherSchedulesToJson) final  List<(UID, Teacher, List<SchedulePart>)> teachersSchedule = const [], @JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson) final  List<(UID, Group, List<SchedulePart>)> groupsSchedule = const [], @SelectedScheduleConverter() this.selectedSchedule, this.lastSyncedAt, final  Map<UID, DateTime> scheduleSyncedAt = const <UID, DateTime>{}, @JsonKey(includeFromJson: false, includeToJson: false) this.isOffline = false}): _classroomsSchedule = classroomsSchedule,_teachersSchedule = teachersSchedule,_groupsSchedule = groupsSchedule,_scheduleSyncedAt = scheduleSyncedAt,super._();
  factory _ScheduleState.fromJson(Map<String, dynamic> json) => _$ScheduleStateFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  ScheduleStatus status;
 final  List<(UID, Classroom, List<SchedulePart>)> _classroomsSchedule;
@override@JsonKey(fromJson: _classroomSchedulesFromJson, toJson: _classroomSchedulesToJson) List<(UID, Classroom, List<SchedulePart>)> get classroomsSchedule {
  if (_classroomsSchedule is EqualUnmodifiableListView) return _classroomsSchedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classroomsSchedule);
}

 final  List<(UID, Teacher, List<SchedulePart>)> _teachersSchedule;
@override@JsonKey(fromJson: _teacherSchedulesFromJson, toJson: _teacherSchedulesToJson) List<(UID, Teacher, List<SchedulePart>)> get teachersSchedule {
  if (_teachersSchedule is EqualUnmodifiableListView) return _teachersSchedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teachersSchedule);
}

 final  List<(UID, Group, List<SchedulePart>)> _groupsSchedule;
@override@JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson) List<(UID, Group, List<SchedulePart>)> get groupsSchedule {
  if (_groupsSchedule is EqualUnmodifiableListView) return _groupsSchedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupsSchedule);
}

@override@SelectedScheduleConverter() final  SelectedSchedule? selectedSchedule;
/// When the active schedule was last successfully synced from the server.
/// Persisted so the offline banner can show a truthful "updated at" time.
@override final  DateTime? lastSyncedAt;
/// Last successful fetch time of every saved schedule, keyed by its
/// identifier (`uid ?? name`). Lets the hub show a truthful "обновлено …"
/// line for each saved schedule, not just the active one.
 final  Map<UID, DateTime> _scheduleSyncedAt;
/// Last successful fetch time of every saved schedule, keyed by its
/// identifier (`uid ?? name`). Lets the hub show a truthful "обновлено …"
/// line for each saved schedule, not just the active one.
@override@JsonKey() Map<UID, DateTime> get scheduleSyncedAt {
  if (_scheduleSyncedAt is EqualUnmodifiableMapView) return _scheduleSyncedAt;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_scheduleSyncedAt);
}

/// Whether the schedule on screen is stale cached data shown because the
/// last refresh failed (no network). Transient — never persisted.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isOffline;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleStateCopyWith<_ScheduleState> get copyWith => __$ScheduleStateCopyWithImpl<_ScheduleState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleStateToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ScheduleState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('classroomsSchedule', classroomsSchedule))..add(DiagnosticsProperty('teachersSchedule', teachersSchedule))..add(DiagnosticsProperty('groupsSchedule', groupsSchedule))..add(DiagnosticsProperty('selectedSchedule', selectedSchedule))..add(DiagnosticsProperty('lastSyncedAt', lastSyncedAt))..add(DiagnosticsProperty('scheduleSyncedAt', scheduleSyncedAt))..add(DiagnosticsProperty('isOffline', isOffline));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._classroomsSchedule, _classroomsSchedule)&&const DeepCollectionEquality().equals(other._teachersSchedule, _teachersSchedule)&&const DeepCollectionEquality().equals(other._groupsSchedule, _groupsSchedule)&&(identical(other.selectedSchedule, selectedSchedule) || other.selectedSchedule == selectedSchedule)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&const DeepCollectionEquality().equals(other._scheduleSyncedAt, _scheduleSyncedAt)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_classroomsSchedule),const DeepCollectionEquality().hash(_teachersSchedule),const DeepCollectionEquality().hash(_groupsSchedule),selectedSchedule,lastSyncedAt,const DeepCollectionEquality().hash(_scheduleSyncedAt),isOffline);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ScheduleState(status: $status, classroomsSchedule: $classroomsSchedule, teachersSchedule: $teachersSchedule, groupsSchedule: $groupsSchedule, selectedSchedule: $selectedSchedule, lastSyncedAt: $lastSyncedAt, scheduleSyncedAt: $scheduleSyncedAt, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class _$ScheduleStateCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory _$ScheduleStateCopyWith(_ScheduleState value, $Res Function(_ScheduleState) _then) = __$ScheduleStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) ScheduleStatus status,@JsonKey(fromJson: _classroomSchedulesFromJson, toJson: _classroomSchedulesToJson) List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule,@JsonKey(fromJson: _teacherSchedulesFromJson, toJson: _teacherSchedulesToJson) List<(UID, Teacher, List<SchedulePart>)> teachersSchedule,@JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson) List<(UID, Group, List<SchedulePart>)> groupsSchedule,@SelectedScheduleConverter() SelectedSchedule? selectedSchedule, DateTime? lastSyncedAt, Map<UID, DateTime> scheduleSyncedAt,@JsonKey(includeFromJson: false, includeToJson: false) bool isOffline
});


@override $SelectedScheduleCopyWith<$Res>? get selectedSchedule;

}
/// @nodoc
class __$ScheduleStateCopyWithImpl<$Res>
    implements _$ScheduleStateCopyWith<$Res> {
  __$ScheduleStateCopyWithImpl(this._self, this._then);

  final _ScheduleState _self;
  final $Res Function(_ScheduleState) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? classroomsSchedule = null,Object? teachersSchedule = null,Object? groupsSchedule = null,Object? selectedSchedule = freezed,Object? lastSyncedAt = freezed,Object? scheduleSyncedAt = null,Object? isOffline = null,}) {
  return _then(_ScheduleState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleStatus,classroomsSchedule: null == classroomsSchedule ? _self._classroomsSchedule : classroomsSchedule // ignore: cast_nullable_to_non_nullable
as List<(UID, Classroom, List<SchedulePart>)>,teachersSchedule: null == teachersSchedule ? _self._teachersSchedule : teachersSchedule // ignore: cast_nullable_to_non_nullable
as List<(UID, Teacher, List<SchedulePart>)>,groupsSchedule: null == groupsSchedule ? _self._groupsSchedule : groupsSchedule // ignore: cast_nullable_to_non_nullable
as List<(UID, Group, List<SchedulePart>)>,selectedSchedule: freezed == selectedSchedule ? _self.selectedSchedule : selectedSchedule // ignore: cast_nullable_to_non_nullable
as SelectedSchedule?,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduleSyncedAt: null == scheduleSyncedAt ? _self._scheduleSyncedAt : scheduleSyncedAt // ignore: cast_nullable_to_non_nullable
as Map<UID, DateTime>,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectedScheduleCopyWith<$Res>? get selectedSchedule {
    if (_self.selectedSchedule == null) {
    return null;
  }

  return $SelectedScheduleCopyWith<$Res>(_self.selectedSchedule!, (value) {
    return _then(_self.copyWith(selectedSchedule: value));
  });
}
}

// dart format on
