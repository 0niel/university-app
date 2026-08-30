// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Mentor {

 String get userId; String get fullName;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get topics; String get bio; int get sessions; String get level;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get formats; int get price; bool get isMe; int? get course; String? get group; String? get handle;
/// Create a copy of Mentor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentorCopyWith<Mentor> get copyWith => _$MentorCopyWithImpl<Mentor>(this as Mentor, _$identity);

  /// Serializes this Mentor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mentor&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other.topics, topics)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.sessions, sessions) || other.sessions == sessions)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.formats, formats)&&(identical(other.price, price) || other.price == price)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.course, course) || other.course == course)&&(identical(other.group, group) || other.group == group)&&(identical(other.handle, handle) || other.handle == handle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,const DeepCollectionEquality().hash(topics),bio,sessions,level,const DeepCollectionEquality().hash(formats),price,isMe,course,group,handle);

@override
String toString() {
  return 'Mentor(userId: $userId, fullName: $fullName, topics: $topics, bio: $bio, sessions: $sessions, level: $level, formats: $formats, price: $price, isMe: $isMe, course: $course, group: $group, handle: $handle)';
}


}

/// @nodoc
abstract mixin class $MentorCopyWith<$Res>  {
  factory $MentorCopyWith(Mentor value, $Res Function(Mentor) _then) = _$MentorCopyWithImpl;
@useResult
$Res call({
 String userId, String fullName,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> topics, String bio, int sessions, String level,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> formats, int price, bool isMe, int? course, String? group, String? handle
});




}
/// @nodoc
class _$MentorCopyWithImpl<$Res>
    implements $MentorCopyWith<$Res> {
  _$MentorCopyWithImpl(this._self, this._then);

  final Mentor _self;
  final $Res Function(Mentor) _then;

/// Create a copy of Mentor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? fullName = null,Object? topics = null,Object? bio = null,Object? sessions = null,Object? level = null,Object? formats = null,Object? price = null,Object? isMe = null,Object? course = freezed,Object? group = freezed,Object? handle = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,formats: null == formats ? _self.formats : formats // ignore: cast_nullable_to_non_nullable
as List<String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,course: freezed == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as int?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Mentor].
extension MentorPatterns on Mentor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mentor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mentor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mentor value)  $default,){
final _that = this;
switch (_that) {
case _Mentor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mentor value)?  $default,){
final _that = this;
switch (_that) {
case _Mentor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String fullName, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> topics,  String bio,  int sessions,  String level, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> formats,  int price,  bool isMe,  int? course,  String? group,  String? handle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Mentor() when $default != null:
return $default(_that.userId,_that.fullName,_that.topics,_that.bio,_that.sessions,_that.level,_that.formats,_that.price,_that.isMe,_that.course,_that.group,_that.handle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String fullName, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> topics,  String bio,  int sessions,  String level, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> formats,  int price,  bool isMe,  int? course,  String? group,  String? handle)  $default,) {final _that = this;
switch (_that) {
case _Mentor():
return $default(_that.userId,_that.fullName,_that.topics,_that.bio,_that.sessions,_that.level,_that.formats,_that.price,_that.isMe,_that.course,_that.group,_that.handle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String fullName, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> topics,  String bio,  int sessions,  String level, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> formats,  int price,  bool isMe,  int? course,  String? group,  String? handle)?  $default,) {final _that = this;
switch (_that) {
case _Mentor() when $default != null:
return $default(_that.userId,_that.fullName,_that.topics,_that.bio,_that.sessions,_that.level,_that.formats,_that.price,_that.isMe,_that.course,_that.group,_that.handle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Mentor implements Mentor {
  const _Mentor({required this.userId, required this.fullName, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> topics = const <String>[], this.bio = '', this.sessions = 0, this.level = '', @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> formats = const <String>[], this.price = 0, this.isMe = false, this.course, this.group, this.handle}): _topics = topics,_formats = formats;
  factory _Mentor.fromJson(Map<String, dynamic> json) => _$MentorFromJson(json);

@override final  String userId;
@override final  String fullName;
 final  List<String> _topics;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}

@override@JsonKey() final  String bio;
@override@JsonKey() final  int sessions;
@override@JsonKey() final  String level;
 final  List<String> _formats;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get formats {
  if (_formats is EqualUnmodifiableListView) return _formats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_formats);
}

@override@JsonKey() final  int price;
@override@JsonKey() final  bool isMe;
@override final  int? course;
@override final  String? group;
@override final  String? handle;

/// Create a copy of Mentor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentorCopyWith<_Mentor> get copyWith => __$MentorCopyWithImpl<_Mentor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MentorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mentor&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other._topics, _topics)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.sessions, sessions) || other.sessions == sessions)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._formats, _formats)&&(identical(other.price, price) || other.price == price)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.course, course) || other.course == course)&&(identical(other.group, group) || other.group == group)&&(identical(other.handle, handle) || other.handle == handle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,const DeepCollectionEquality().hash(_topics),bio,sessions,level,const DeepCollectionEquality().hash(_formats),price,isMe,course,group,handle);

@override
String toString() {
  return 'Mentor(userId: $userId, fullName: $fullName, topics: $topics, bio: $bio, sessions: $sessions, level: $level, formats: $formats, price: $price, isMe: $isMe, course: $course, group: $group, handle: $handle)';
}


}

/// @nodoc
abstract mixin class _$MentorCopyWith<$Res> implements $MentorCopyWith<$Res> {
  factory _$MentorCopyWith(_Mentor value, $Res Function(_Mentor) _then) = __$MentorCopyWithImpl;
@override @useResult
$Res call({
 String userId, String fullName,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> topics, String bio, int sessions, String level,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> formats, int price, bool isMe, int? course, String? group, String? handle
});




}
/// @nodoc
class __$MentorCopyWithImpl<$Res>
    implements _$MentorCopyWith<$Res> {
  __$MentorCopyWithImpl(this._self, this._then);

  final _Mentor _self;
  final $Res Function(_Mentor) _then;

/// Create a copy of Mentor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = null,Object? topics = null,Object? bio = null,Object? sessions = null,Object? level = null,Object? formats = null,Object? price = null,Object? isMe = null,Object? course = freezed,Object? group = freezed,Object? handle = freezed,}) {
  return _then(_Mentor(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,formats: null == formats ? _self._formats : formats // ignore: cast_nullable_to_non_nullable
as List<String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,course: freezed == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as int?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MentorRequest {

 String get id; String get mentorUserId; String get requesterId; String get topic; MentorWhenSlot get whenSlot; String get message; int get price; String get requesterName; String get mentorName; String? get requesterHandle; String? get mentorHandle; bool get isIncoming; MentorRequestStatus get status; bool get mentorConfirmed; bool get requesterConfirmed;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt;
/// Create a copy of MentorRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentorRequestCopyWith<MentorRequest> get copyWith => _$MentorRequestCopyWithImpl<MentorRequest>(this as MentorRequest, _$identity);

  /// Serializes this MentorRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentorRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.mentorUserId, mentorUserId) || other.mentorUserId == mentorUserId)&&(identical(other.requesterId, requesterId) || other.requesterId == requesterId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.whenSlot, whenSlot) || other.whenSlot == whenSlot)&&(identical(other.message, message) || other.message == message)&&(identical(other.price, price) || other.price == price)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.mentorName, mentorName) || other.mentorName == mentorName)&&(identical(other.requesterHandle, requesterHandle) || other.requesterHandle == requesterHandle)&&(identical(other.mentorHandle, mentorHandle) || other.mentorHandle == mentorHandle)&&(identical(other.isIncoming, isIncoming) || other.isIncoming == isIncoming)&&(identical(other.status, status) || other.status == status)&&(identical(other.mentorConfirmed, mentorConfirmed) || other.mentorConfirmed == mentorConfirmed)&&(identical(other.requesterConfirmed, requesterConfirmed) || other.requesterConfirmed == requesterConfirmed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mentorUserId,requesterId,topic,whenSlot,message,price,requesterName,mentorName,requesterHandle,mentorHandle,isIncoming,status,mentorConfirmed,requesterConfirmed,createdAt);

@override
String toString() {
  return 'MentorRequest(id: $id, mentorUserId: $mentorUserId, requesterId: $requesterId, topic: $topic, whenSlot: $whenSlot, message: $message, price: $price, requesterName: $requesterName, mentorName: $mentorName, requesterHandle: $requesterHandle, mentorHandle: $mentorHandle, isIncoming: $isIncoming, status: $status, mentorConfirmed: $mentorConfirmed, requesterConfirmed: $requesterConfirmed, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MentorRequestCopyWith<$Res>  {
  factory $MentorRequestCopyWith(MentorRequest value, $Res Function(MentorRequest) _then) = _$MentorRequestCopyWithImpl;
@useResult
$Res call({
 String id, String mentorUserId, String requesterId, String topic, MentorWhenSlot whenSlot, String message, int price, String requesterName, String mentorName, String? requesterHandle, String? mentorHandle, bool isIncoming, MentorRequestStatus status, bool mentorConfirmed, bool requesterConfirmed,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class _$MentorRequestCopyWithImpl<$Res>
    implements $MentorRequestCopyWith<$Res> {
  _$MentorRequestCopyWithImpl(this._self, this._then);

  final MentorRequest _self;
  final $Res Function(MentorRequest) _then;

/// Create a copy of MentorRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mentorUserId = null,Object? requesterId = null,Object? topic = null,Object? whenSlot = null,Object? message = null,Object? price = null,Object? requesterName = null,Object? mentorName = null,Object? requesterHandle = freezed,Object? mentorHandle = freezed,Object? isIncoming = null,Object? status = null,Object? mentorConfirmed = null,Object? requesterConfirmed = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mentorUserId: null == mentorUserId ? _self.mentorUserId : mentorUserId // ignore: cast_nullable_to_non_nullable
as String,requesterId: null == requesterId ? _self.requesterId : requesterId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,whenSlot: null == whenSlot ? _self.whenSlot : whenSlot // ignore: cast_nullable_to_non_nullable
as MentorWhenSlot,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,mentorName: null == mentorName ? _self.mentorName : mentorName // ignore: cast_nullable_to_non_nullable
as String,requesterHandle: freezed == requesterHandle ? _self.requesterHandle : requesterHandle // ignore: cast_nullable_to_non_nullable
as String?,mentorHandle: freezed == mentorHandle ? _self.mentorHandle : mentorHandle // ignore: cast_nullable_to_non_nullable
as String?,isIncoming: null == isIncoming ? _self.isIncoming : isIncoming // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MentorRequestStatus,mentorConfirmed: null == mentorConfirmed ? _self.mentorConfirmed : mentorConfirmed // ignore: cast_nullable_to_non_nullable
as bool,requesterConfirmed: null == requesterConfirmed ? _self.requesterConfirmed : requesterConfirmed // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MentorRequest].
extension MentorRequestPatterns on MentorRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentorRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentorRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentorRequest value)  $default,){
final _that = this;
switch (_that) {
case _MentorRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentorRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MentorRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String mentorUserId,  String requesterId,  String topic,  MentorWhenSlot whenSlot,  String message,  int price,  String requesterName,  String mentorName,  String? requesterHandle,  String? mentorHandle,  bool isIncoming,  MentorRequestStatus status,  bool mentorConfirmed,  bool requesterConfirmed, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentorRequest() when $default != null:
return $default(_that.id,_that.mentorUserId,_that.requesterId,_that.topic,_that.whenSlot,_that.message,_that.price,_that.requesterName,_that.mentorName,_that.requesterHandle,_that.mentorHandle,_that.isIncoming,_that.status,_that.mentorConfirmed,_that.requesterConfirmed,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String mentorUserId,  String requesterId,  String topic,  MentorWhenSlot whenSlot,  String message,  int price,  String requesterName,  String mentorName,  String? requesterHandle,  String? mentorHandle,  bool isIncoming,  MentorRequestStatus status,  bool mentorConfirmed,  bool requesterConfirmed, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MentorRequest():
return $default(_that.id,_that.mentorUserId,_that.requesterId,_that.topic,_that.whenSlot,_that.message,_that.price,_that.requesterName,_that.mentorName,_that.requesterHandle,_that.mentorHandle,_that.isIncoming,_that.status,_that.mentorConfirmed,_that.requesterConfirmed,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String mentorUserId,  String requesterId,  String topic,  MentorWhenSlot whenSlot,  String message,  int price,  String requesterName,  String mentorName,  String? requesterHandle,  String? mentorHandle,  bool isIncoming,  MentorRequestStatus status,  bool mentorConfirmed,  bool requesterConfirmed, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MentorRequest() when $default != null:
return $default(_that.id,_that.mentorUserId,_that.requesterId,_that.topic,_that.whenSlot,_that.message,_that.price,_that.requesterName,_that.mentorName,_that.requesterHandle,_that.mentorHandle,_that.isIncoming,_that.status,_that.mentorConfirmed,_that.requesterConfirmed,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MentorRequest extends MentorRequest {
  const _MentorRequest({required this.id, required this.mentorUserId, required this.requesterId, this.topic = '', this.whenSlot = MentorWhenSlot.week, this.message = '', this.price = 0, this.requesterName = '', this.mentorName = '', this.requesterHandle, this.mentorHandle, this.isIncoming = true, this.status = MentorRequestStatus.pending, this.mentorConfirmed = false, this.requesterConfirmed = false, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt}): super._();
  factory _MentorRequest.fromJson(Map<String, dynamic> json) => _$MentorRequestFromJson(json);

@override final  String id;
@override final  String mentorUserId;
@override final  String requesterId;
@override@JsonKey() final  String topic;
@override@JsonKey() final  MentorWhenSlot whenSlot;
@override@JsonKey() final  String message;
@override@JsonKey() final  int price;
@override@JsonKey() final  String requesterName;
@override@JsonKey() final  String mentorName;
@override final  String? requesterHandle;
@override final  String? mentorHandle;
@override@JsonKey() final  bool isIncoming;
@override@JsonKey() final  MentorRequestStatus status;
@override@JsonKey() final  bool mentorConfirmed;
@override@JsonKey() final  bool requesterConfirmed;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;

/// Create a copy of MentorRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentorRequestCopyWith<_MentorRequest> get copyWith => __$MentorRequestCopyWithImpl<_MentorRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MentorRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentorRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.mentorUserId, mentorUserId) || other.mentorUserId == mentorUserId)&&(identical(other.requesterId, requesterId) || other.requesterId == requesterId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.whenSlot, whenSlot) || other.whenSlot == whenSlot)&&(identical(other.message, message) || other.message == message)&&(identical(other.price, price) || other.price == price)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.mentorName, mentorName) || other.mentorName == mentorName)&&(identical(other.requesterHandle, requesterHandle) || other.requesterHandle == requesterHandle)&&(identical(other.mentorHandle, mentorHandle) || other.mentorHandle == mentorHandle)&&(identical(other.isIncoming, isIncoming) || other.isIncoming == isIncoming)&&(identical(other.status, status) || other.status == status)&&(identical(other.mentorConfirmed, mentorConfirmed) || other.mentorConfirmed == mentorConfirmed)&&(identical(other.requesterConfirmed, requesterConfirmed) || other.requesterConfirmed == requesterConfirmed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mentorUserId,requesterId,topic,whenSlot,message,price,requesterName,mentorName,requesterHandle,mentorHandle,isIncoming,status,mentorConfirmed,requesterConfirmed,createdAt);

@override
String toString() {
  return 'MentorRequest(id: $id, mentorUserId: $mentorUserId, requesterId: $requesterId, topic: $topic, whenSlot: $whenSlot, message: $message, price: $price, requesterName: $requesterName, mentorName: $mentorName, requesterHandle: $requesterHandle, mentorHandle: $mentorHandle, isIncoming: $isIncoming, status: $status, mentorConfirmed: $mentorConfirmed, requesterConfirmed: $requesterConfirmed, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MentorRequestCopyWith<$Res> implements $MentorRequestCopyWith<$Res> {
  factory _$MentorRequestCopyWith(_MentorRequest value, $Res Function(_MentorRequest) _then) = __$MentorRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String mentorUserId, String requesterId, String topic, MentorWhenSlot whenSlot, String message, int price, String requesterName, String mentorName, String? requesterHandle, String? mentorHandle, bool isIncoming, MentorRequestStatus status, bool mentorConfirmed, bool requesterConfirmed,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class __$MentorRequestCopyWithImpl<$Res>
    implements _$MentorRequestCopyWith<$Res> {
  __$MentorRequestCopyWithImpl(this._self, this._then);

  final _MentorRequest _self;
  final $Res Function(_MentorRequest) _then;

/// Create a copy of MentorRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mentorUserId = null,Object? requesterId = null,Object? topic = null,Object? whenSlot = null,Object? message = null,Object? price = null,Object? requesterName = null,Object? mentorName = null,Object? requesterHandle = freezed,Object? mentorHandle = freezed,Object? isIncoming = null,Object? status = null,Object? mentorConfirmed = null,Object? requesterConfirmed = null,Object? createdAt = freezed,}) {
  return _then(_MentorRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mentorUserId: null == mentorUserId ? _self.mentorUserId : mentorUserId // ignore: cast_nullable_to_non_nullable
as String,requesterId: null == requesterId ? _self.requesterId : requesterId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,whenSlot: null == whenSlot ? _self.whenSlot : whenSlot // ignore: cast_nullable_to_non_nullable
as MentorWhenSlot,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,mentorName: null == mentorName ? _self.mentorName : mentorName // ignore: cast_nullable_to_non_nullable
as String,requesterHandle: freezed == requesterHandle ? _self.requesterHandle : requesterHandle // ignore: cast_nullable_to_non_nullable
as String?,mentorHandle: freezed == mentorHandle ? _self.mentorHandle : mentorHandle // ignore: cast_nullable_to_non_nullable
as String?,isIncoming: null == isIncoming ? _self.isIncoming : isIncoming // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MentorRequestStatus,mentorConfirmed: null == mentorConfirmed ? _self.mentorConfirmed : mentorConfirmed // ignore: cast_nullable_to_non_nullable
as bool,requesterConfirmed: null == requesterConfirmed ? _self.requesterConfirmed : requesterConfirmed // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
