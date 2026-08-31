// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Team {

 String get id; String get title; String get eventName; String get description;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get neededRoles; int get capacity; String get kind;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get deadlineAt; bool get isBoosted;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt; bool get isMine; bool get isMember; bool get hasApplied; String? get myApplicationId; TeamStatus get status; int get applicationsCount; int get memberCount;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get memberNames;
/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamCopyWith<Team> get copyWith => _$TeamCopyWithImpl<Team>(this as Team, _$identity);

  /// Serializes this Team to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Team&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.neededRoles, neededRoles)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.isBoosted, isBoosted) || other.isBoosted == isBoosted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.isMember, isMember) || other.isMember == isMember)&&(identical(other.hasApplied, hasApplied) || other.hasApplied == hasApplied)&&(identical(other.myApplicationId, myApplicationId) || other.myApplicationId == myApplicationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.applicationsCount, applicationsCount) || other.applicationsCount == applicationsCount)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other.memberNames, memberNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,eventName,description,const DeepCollectionEquality().hash(neededRoles),capacity,kind,deadlineAt,isBoosted,createdAt,isMine,isMember,hasApplied,myApplicationId,status,applicationsCount,memberCount,const DeepCollectionEquality().hash(memberNames));

@override
String toString() {
  return 'Team(id: $id, title: $title, eventName: $eventName, description: $description, neededRoles: $neededRoles, capacity: $capacity, kind: $kind, deadlineAt: $deadlineAt, isBoosted: $isBoosted, createdAt: $createdAt, isMine: $isMine, isMember: $isMember, hasApplied: $hasApplied, myApplicationId: $myApplicationId, status: $status, applicationsCount: $applicationsCount, memberCount: $memberCount, memberNames: $memberNames)';
}


}

/// @nodoc
abstract mixin class $TeamCopyWith<$Res>  {
  factory $TeamCopyWith(Team value, $Res Function(Team) _then) = _$TeamCopyWithImpl;
@useResult
$Res call({
 String id, String title, String eventName, String description,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> neededRoles, int capacity, String kind,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? deadlineAt, bool isBoosted,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isMine, bool isMember, bool hasApplied, String? myApplicationId, TeamStatus status, int applicationsCount, int memberCount,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> memberNames
});




}
/// @nodoc
class _$TeamCopyWithImpl<$Res>
    implements $TeamCopyWith<$Res> {
  _$TeamCopyWithImpl(this._self, this._then);

  final Team _self;
  final $Res Function(Team) _then;

/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? eventName = null,Object? description = null,Object? neededRoles = null,Object? capacity = null,Object? kind = null,Object? deadlineAt = freezed,Object? isBoosted = null,Object? createdAt = freezed,Object? isMine = null,Object? isMember = null,Object? hasApplied = null,Object? myApplicationId = freezed,Object? status = null,Object? applicationsCount = null,Object? memberCount = null,Object? memberNames = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,neededRoles: null == neededRoles ? _self.neededRoles : neededRoles // ignore: cast_nullable_to_non_nullable
as List<String>,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isBoosted: null == isBoosted ? _self.isBoosted : isBoosted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,isMember: null == isMember ? _self.isMember : isMember // ignore: cast_nullable_to_non_nullable
as bool,hasApplied: null == hasApplied ? _self.hasApplied : hasApplied // ignore: cast_nullable_to_non_nullable
as bool,myApplicationId: freezed == myApplicationId ? _self.myApplicationId : myApplicationId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeamStatus,applicationsCount: null == applicationsCount ? _self.applicationsCount : applicationsCount // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,memberNames: null == memberNames ? _self.memberNames : memberNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Team].
extension TeamPatterns on Team {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Team value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Team() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Team value)  $default,){
final _that = this;
switch (_that) {
case _Team():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Team value)?  $default,){
final _that = this;
switch (_that) {
case _Team() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String eventName,  String description, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> neededRoles,  int capacity,  String kind, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? deadlineAt,  bool isBoosted, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  bool isMember,  bool hasApplied,  String? myApplicationId,  TeamStatus status,  int applicationsCount,  int memberCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> memberNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Team() when $default != null:
return $default(_that.id,_that.title,_that.eventName,_that.description,_that.neededRoles,_that.capacity,_that.kind,_that.deadlineAt,_that.isBoosted,_that.createdAt,_that.isMine,_that.isMember,_that.hasApplied,_that.myApplicationId,_that.status,_that.applicationsCount,_that.memberCount,_that.memberNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String eventName,  String description, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> neededRoles,  int capacity,  String kind, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? deadlineAt,  bool isBoosted, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  bool isMember,  bool hasApplied,  String? myApplicationId,  TeamStatus status,  int applicationsCount,  int memberCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> memberNames)  $default,) {final _that = this;
switch (_that) {
case _Team():
return $default(_that.id,_that.title,_that.eventName,_that.description,_that.neededRoles,_that.capacity,_that.kind,_that.deadlineAt,_that.isBoosted,_that.createdAt,_that.isMine,_that.isMember,_that.hasApplied,_that.myApplicationId,_that.status,_that.applicationsCount,_that.memberCount,_that.memberNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String eventName,  String description, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> neededRoles,  int capacity,  String kind, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? deadlineAt,  bool isBoosted, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  bool isMember,  bool hasApplied,  String? myApplicationId,  TeamStatus status,  int applicationsCount,  int memberCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> memberNames)?  $default,) {final _that = this;
switch (_that) {
case _Team() when $default != null:
return $default(_that.id,_that.title,_that.eventName,_that.description,_that.neededRoles,_that.capacity,_that.kind,_that.deadlineAt,_that.isBoosted,_that.createdAt,_that.isMine,_that.isMember,_that.hasApplied,_that.myApplicationId,_that.status,_that.applicationsCount,_that.memberCount,_that.memberNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Team extends Team {
  const _Team({required this.id, required this.title, this.eventName = '', this.description = '', @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> neededRoles = const <String>[], this.capacity = 5, this.kind = 'hackathon', @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.deadlineAt, this.isBoosted = false, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt, this.isMine = false, this.isMember = false, this.hasApplied = false, this.myApplicationId, this.status = TeamStatus.open, this.applicationsCount = 0, this.memberCount = 1, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> memberNames = const <String>[]}): _neededRoles = neededRoles,_memberNames = memberNames,super._();
  factory _Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String eventName;
@override@JsonKey() final  String description;
 final  List<String> _neededRoles;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get neededRoles {
  if (_neededRoles is EqualUnmodifiableListView) return _neededRoles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_neededRoles);
}

@override@JsonKey() final  int capacity;
@override@JsonKey() final  String kind;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? deadlineAt;
@override@JsonKey() final  bool isBoosted;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  bool isMember;
@override@JsonKey() final  bool hasApplied;
@override final  String? myApplicationId;
@override@JsonKey() final  TeamStatus status;
@override@JsonKey() final  int applicationsCount;
@override@JsonKey() final  int memberCount;
 final  List<String> _memberNames;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get memberNames {
  if (_memberNames is EqualUnmodifiableListView) return _memberNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberNames);
}


/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamCopyWith<_Team> get copyWith => __$TeamCopyWithImpl<_Team>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Team&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._neededRoles, _neededRoles)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.isBoosted, isBoosted) || other.isBoosted == isBoosted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.isMember, isMember) || other.isMember == isMember)&&(identical(other.hasApplied, hasApplied) || other.hasApplied == hasApplied)&&(identical(other.myApplicationId, myApplicationId) || other.myApplicationId == myApplicationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.applicationsCount, applicationsCount) || other.applicationsCount == applicationsCount)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other._memberNames, _memberNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,eventName,description,const DeepCollectionEquality().hash(_neededRoles),capacity,kind,deadlineAt,isBoosted,createdAt,isMine,isMember,hasApplied,myApplicationId,status,applicationsCount,memberCount,const DeepCollectionEquality().hash(_memberNames));

@override
String toString() {
  return 'Team(id: $id, title: $title, eventName: $eventName, description: $description, neededRoles: $neededRoles, capacity: $capacity, kind: $kind, deadlineAt: $deadlineAt, isBoosted: $isBoosted, createdAt: $createdAt, isMine: $isMine, isMember: $isMember, hasApplied: $hasApplied, myApplicationId: $myApplicationId, status: $status, applicationsCount: $applicationsCount, memberCount: $memberCount, memberNames: $memberNames)';
}


}

/// @nodoc
abstract mixin class _$TeamCopyWith<$Res> implements $TeamCopyWith<$Res> {
  factory _$TeamCopyWith(_Team value, $Res Function(_Team) _then) = __$TeamCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String eventName, String description,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> neededRoles, int capacity, String kind,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? deadlineAt, bool isBoosted,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isMine, bool isMember, bool hasApplied, String? myApplicationId, TeamStatus status, int applicationsCount, int memberCount,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> memberNames
});




}
/// @nodoc
class __$TeamCopyWithImpl<$Res>
    implements _$TeamCopyWith<$Res> {
  __$TeamCopyWithImpl(this._self, this._then);

  final _Team _self;
  final $Res Function(_Team) _then;

/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? eventName = null,Object? description = null,Object? neededRoles = null,Object? capacity = null,Object? kind = null,Object? deadlineAt = freezed,Object? isBoosted = null,Object? createdAt = freezed,Object? isMine = null,Object? isMember = null,Object? hasApplied = null,Object? myApplicationId = freezed,Object? status = null,Object? applicationsCount = null,Object? memberCount = null,Object? memberNames = null,}) {
  return _then(_Team(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,neededRoles: null == neededRoles ? _self._neededRoles : neededRoles // ignore: cast_nullable_to_non_nullable
as List<String>,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isBoosted: null == isBoosted ? _self.isBoosted : isBoosted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,isMember: null == isMember ? _self.isMember : isMember // ignore: cast_nullable_to_non_nullable
as bool,hasApplied: null == hasApplied ? _self.hasApplied : hasApplied // ignore: cast_nullable_to_non_nullable
as bool,myApplicationId: freezed == myApplicationId ? _self.myApplicationId : myApplicationId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeamStatus,applicationsCount: null == applicationsCount ? _self.applicationsCount : applicationsCount // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,memberNames: null == memberNames ? _self._memberNames : memberNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TeamApplication {

 String get id; String get teamId; String get applicantId; String get role; String get message; String get applicantName; String? get applicantHandle; String? get applicantGroup; bool get attachProfile; TeamApplicationStatus get status;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt;
/// Create a copy of TeamApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamApplicationCopyWith<TeamApplication> get copyWith => _$TeamApplicationCopyWithImpl<TeamApplication>(this as TeamApplication, _$identity);

  /// Serializes this TeamApplication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.applicantId, applicantId) || other.applicantId == applicantId)&&(identical(other.role, role) || other.role == role)&&(identical(other.message, message) || other.message == message)&&(identical(other.applicantName, applicantName) || other.applicantName == applicantName)&&(identical(other.applicantHandle, applicantHandle) || other.applicantHandle == applicantHandle)&&(identical(other.applicantGroup, applicantGroup) || other.applicantGroup == applicantGroup)&&(identical(other.attachProfile, attachProfile) || other.attachProfile == attachProfile)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teamId,applicantId,role,message,applicantName,applicantHandle,applicantGroup,attachProfile,status,createdAt);

@override
String toString() {
  return 'TeamApplication(id: $id, teamId: $teamId, applicantId: $applicantId, role: $role, message: $message, applicantName: $applicantName, applicantHandle: $applicantHandle, applicantGroup: $applicantGroup, attachProfile: $attachProfile, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TeamApplicationCopyWith<$Res>  {
  factory $TeamApplicationCopyWith(TeamApplication value, $Res Function(TeamApplication) _then) = _$TeamApplicationCopyWithImpl;
@useResult
$Res call({
 String id, String teamId, String applicantId, String role, String message, String applicantName, String? applicantHandle, String? applicantGroup, bool attachProfile, TeamApplicationStatus status,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class _$TeamApplicationCopyWithImpl<$Res>
    implements $TeamApplicationCopyWith<$Res> {
  _$TeamApplicationCopyWithImpl(this._self, this._then);

  final TeamApplication _self;
  final $Res Function(TeamApplication) _then;

/// Create a copy of TeamApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? teamId = null,Object? applicantId = null,Object? role = null,Object? message = null,Object? applicantName = null,Object? applicantHandle = freezed,Object? applicantGroup = freezed,Object? attachProfile = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,applicantId: null == applicantId ? _self.applicantId : applicantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,applicantName: null == applicantName ? _self.applicantName : applicantName // ignore: cast_nullable_to_non_nullable
as String,applicantHandle: freezed == applicantHandle ? _self.applicantHandle : applicantHandle // ignore: cast_nullable_to_non_nullable
as String?,applicantGroup: freezed == applicantGroup ? _self.applicantGroup : applicantGroup // ignore: cast_nullable_to_non_nullable
as String?,attachProfile: null == attachProfile ? _self.attachProfile : attachProfile // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeamApplicationStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamApplication].
extension TeamApplicationPatterns on TeamApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamApplication value)  $default,){
final _that = this;
switch (_that) {
case _TeamApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamApplication value)?  $default,){
final _that = this;
switch (_that) {
case _TeamApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String teamId,  String applicantId,  String role,  String message,  String applicantName,  String? applicantHandle,  String? applicantGroup,  bool attachProfile,  TeamApplicationStatus status, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamApplication() when $default != null:
return $default(_that.id,_that.teamId,_that.applicantId,_that.role,_that.message,_that.applicantName,_that.applicantHandle,_that.applicantGroup,_that.attachProfile,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String teamId,  String applicantId,  String role,  String message,  String applicantName,  String? applicantHandle,  String? applicantGroup,  bool attachProfile,  TeamApplicationStatus status, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TeamApplication():
return $default(_that.id,_that.teamId,_that.applicantId,_that.role,_that.message,_that.applicantName,_that.applicantHandle,_that.applicantGroup,_that.attachProfile,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String teamId,  String applicantId,  String role,  String message,  String applicantName,  String? applicantHandle,  String? applicantGroup,  bool attachProfile,  TeamApplicationStatus status, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TeamApplication() when $default != null:
return $default(_that.id,_that.teamId,_that.applicantId,_that.role,_that.message,_that.applicantName,_that.applicantHandle,_that.applicantGroup,_that.attachProfile,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamApplication implements TeamApplication {
  const _TeamApplication({required this.id, required this.teamId, required this.applicantId, this.role = '', this.message = '', this.applicantName = '', this.applicantHandle, this.applicantGroup, this.attachProfile = false, this.status = TeamApplicationStatus.pending, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt});
  factory _TeamApplication.fromJson(Map<String, dynamic> json) => _$TeamApplicationFromJson(json);

@override final  String id;
@override final  String teamId;
@override final  String applicantId;
@override@JsonKey() final  String role;
@override@JsonKey() final  String message;
@override@JsonKey() final  String applicantName;
@override final  String? applicantHandle;
@override final  String? applicantGroup;
@override@JsonKey() final  bool attachProfile;
@override@JsonKey() final  TeamApplicationStatus status;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;

/// Create a copy of TeamApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamApplicationCopyWith<_TeamApplication> get copyWith => __$TeamApplicationCopyWithImpl<_TeamApplication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamApplicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.applicantId, applicantId) || other.applicantId == applicantId)&&(identical(other.role, role) || other.role == role)&&(identical(other.message, message) || other.message == message)&&(identical(other.applicantName, applicantName) || other.applicantName == applicantName)&&(identical(other.applicantHandle, applicantHandle) || other.applicantHandle == applicantHandle)&&(identical(other.applicantGroup, applicantGroup) || other.applicantGroup == applicantGroup)&&(identical(other.attachProfile, attachProfile) || other.attachProfile == attachProfile)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teamId,applicantId,role,message,applicantName,applicantHandle,applicantGroup,attachProfile,status,createdAt);

@override
String toString() {
  return 'TeamApplication(id: $id, teamId: $teamId, applicantId: $applicantId, role: $role, message: $message, applicantName: $applicantName, applicantHandle: $applicantHandle, applicantGroup: $applicantGroup, attachProfile: $attachProfile, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TeamApplicationCopyWith<$Res> implements $TeamApplicationCopyWith<$Res> {
  factory _$TeamApplicationCopyWith(_TeamApplication value, $Res Function(_TeamApplication) _then) = __$TeamApplicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String teamId, String applicantId, String role, String message, String applicantName, String? applicantHandle, String? applicantGroup, bool attachProfile, TeamApplicationStatus status,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class __$TeamApplicationCopyWithImpl<$Res>
    implements _$TeamApplicationCopyWith<$Res> {
  __$TeamApplicationCopyWithImpl(this._self, this._then);

  final _TeamApplication _self;
  final $Res Function(_TeamApplication) _then;

/// Create a copy of TeamApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? teamId = null,Object? applicantId = null,Object? role = null,Object? message = null,Object? applicantName = null,Object? applicantHandle = freezed,Object? applicantGroup = freezed,Object? attachProfile = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_TeamApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,applicantId: null == applicantId ? _self.applicantId : applicantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,applicantName: null == applicantName ? _self.applicantName : applicantName // ignore: cast_nullable_to_non_nullable
as String,applicantHandle: freezed == applicantHandle ? _self.applicantHandle : applicantHandle // ignore: cast_nullable_to_non_nullable
as String?,applicantGroup: freezed == applicantGroup ? _self.applicantGroup : applicantGroup // ignore: cast_nullable_to_non_nullable
as String?,attachProfile: null == attachProfile ? _self.attachProfile : attachProfile // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeamApplicationStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
