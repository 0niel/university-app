// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_schedule_part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarSchedulePart {

 String get title;@DatesConverter() List<DateTime> get dates;@JsonKey(readValue: _readKind) String get kind; String? get description;@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get startsAt;@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get endsAt; bool get isAllDay; String? get location; String? get uid; Map<String, Object?>? get sourceLinks;@JsonKey(fromJson: _normalizeType) String get type;
/// Create a copy of CalendarSchedulePart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarSchedulePartCopyWith<CalendarSchedulePart> get copyWith => _$CalendarSchedulePartCopyWithImpl<CalendarSchedulePart>(this as CalendarSchedulePart, _$identity);

  /// Serializes this CalendarSchedulePart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarSchedulePart&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.dates, dates)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.isAllDay, isAllDay) || other.isAllDay == isAllDay)&&(identical(other.location, location) || other.location == location)&&(identical(other.uid, uid) || other.uid == uid)&&const DeepCollectionEquality().equals(other.sourceLinks, sourceLinks)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(dates),kind,description,startsAt,endsAt,isAllDay,location,uid,const DeepCollectionEquality().hash(sourceLinks),type);

@override
String toString() {
  return 'CalendarSchedulePart(title: $title, dates: $dates, kind: $kind, description: $description, startsAt: $startsAt, endsAt: $endsAt, isAllDay: $isAllDay, location: $location, uid: $uid, sourceLinks: $sourceLinks, type: $type)';
}


}

/// @nodoc
abstract mixin class $CalendarSchedulePartCopyWith<$Res>  {
  factory $CalendarSchedulePartCopyWith(CalendarSchedulePart value, $Res Function(CalendarSchedulePart) _then) = _$CalendarSchedulePartCopyWithImpl;
@useResult
$Res call({
 String title,@DatesConverter() List<DateTime> dates,@JsonKey(readValue: _readKind) String kind, String? description,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? startsAt,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? endsAt, bool isAllDay, String? location, String? uid, Map<String, Object?>? sourceLinks,@JsonKey(fromJson: _normalizeType) String type
});




}
/// @nodoc
class _$CalendarSchedulePartCopyWithImpl<$Res>
    implements $CalendarSchedulePartCopyWith<$Res> {
  _$CalendarSchedulePartCopyWithImpl(this._self, this._then);

  final CalendarSchedulePart _self;
  final $Res Function(CalendarSchedulePart) _then;

/// Create a copy of CalendarSchedulePart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? dates = null,Object? kind = null,Object? description = freezed,Object? startsAt = freezed,Object? endsAt = freezed,Object? isAllDay = null,Object? location = freezed,Object? uid = freezed,Object? sourceLinks = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAllDay: null == isAllDay ? _self.isAllDay : isAllDay // ignore: cast_nullable_to_non_nullable
as bool,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,sourceLinks: freezed == sourceLinks ? _self.sourceLinks : sourceLinks // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarSchedulePart].
extension CalendarSchedulePartPatterns on CalendarSchedulePart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarSchedulePart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarSchedulePart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarSchedulePart value)  $default,){
final _that = this;
switch (_that) {
case _CalendarSchedulePart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarSchedulePart value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarSchedulePart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @DatesConverter()  List<DateTime> dates, @JsonKey(readValue: _readKind)  String kind,  String? description, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? startsAt, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? endsAt,  bool isAllDay,  String? location,  String? uid,  Map<String, Object?>? sourceLinks, @JsonKey(fromJson: _normalizeType)  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarSchedulePart() when $default != null:
return $default(_that.title,_that.dates,_that.kind,_that.description,_that.startsAt,_that.endsAt,_that.isAllDay,_that.location,_that.uid,_that.sourceLinks,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @DatesConverter()  List<DateTime> dates, @JsonKey(readValue: _readKind)  String kind,  String? description, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? startsAt, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? endsAt,  bool isAllDay,  String? location,  String? uid,  Map<String, Object?>? sourceLinks, @JsonKey(fromJson: _normalizeType)  String type)  $default,) {final _that = this;
switch (_that) {
case _CalendarSchedulePart():
return $default(_that.title,_that.dates,_that.kind,_that.description,_that.startsAt,_that.endsAt,_that.isAllDay,_that.location,_that.uid,_that.sourceLinks,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @DatesConverter()  List<DateTime> dates, @JsonKey(readValue: _readKind)  String kind,  String? description, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? startsAt, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? endsAt,  bool isAllDay,  String? location,  String? uid,  Map<String, Object?>? sourceLinks, @JsonKey(fromJson: _normalizeType)  String type)?  $default,) {final _that = this;
switch (_that) {
case _CalendarSchedulePart() when $default != null:
return $default(_that.title,_that.dates,_that.kind,_that.description,_that.startsAt,_that.endsAt,_that.isAllDay,_that.location,_that.uid,_that.sourceLinks,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarSchedulePart implements CalendarSchedulePart {
  const _CalendarSchedulePart({required this.title, @DatesConverter() required final  List<DateTime> dates, @JsonKey(readValue: _readKind) this.kind = 'event', this.description, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.startsAt, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.endsAt, this.isAllDay = false, this.location, this.uid, final  Map<String, Object?>? sourceLinks, @JsonKey(fromJson: _normalizeType) this.type = CalendarSchedulePart.identifier}): _dates = dates,_sourceLinks = sourceLinks;
  factory _CalendarSchedulePart.fromJson(Map<String, dynamic> json) => _$CalendarSchedulePartFromJson(json);

@override final  String title;
 final  List<DateTime> _dates;
@override@DatesConverter() List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

@override@JsonKey(readValue: _readKind) final  String kind;
@override final  String? description;
@override@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? startsAt;
@override@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? endsAt;
@override@JsonKey() final  bool isAllDay;
@override final  String? location;
@override final  String? uid;
 final  Map<String, Object?>? _sourceLinks;
@override Map<String, Object?>? get sourceLinks {
  final value = _sourceLinks;
  if (value == null) return null;
  if (_sourceLinks is EqualUnmodifiableMapView) return _sourceLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(fromJson: _normalizeType) final  String type;

/// Create a copy of CalendarSchedulePart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarSchedulePartCopyWith<_CalendarSchedulePart> get copyWith => __$CalendarSchedulePartCopyWithImpl<_CalendarSchedulePart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarSchedulePartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarSchedulePart&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._dates, _dates)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.isAllDay, isAllDay) || other.isAllDay == isAllDay)&&(identical(other.location, location) || other.location == location)&&(identical(other.uid, uid) || other.uid == uid)&&const DeepCollectionEquality().equals(other._sourceLinks, _sourceLinks)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_dates),kind,description,startsAt,endsAt,isAllDay,location,uid,const DeepCollectionEquality().hash(_sourceLinks),type);

@override
String toString() {
  return 'CalendarSchedulePart(title: $title, dates: $dates, kind: $kind, description: $description, startsAt: $startsAt, endsAt: $endsAt, isAllDay: $isAllDay, location: $location, uid: $uid, sourceLinks: $sourceLinks, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CalendarSchedulePartCopyWith<$Res> implements $CalendarSchedulePartCopyWith<$Res> {
  factory _$CalendarSchedulePartCopyWith(_CalendarSchedulePart value, $Res Function(_CalendarSchedulePart) _then) = __$CalendarSchedulePartCopyWithImpl;
@override @useResult
$Res call({
 String title,@DatesConverter() List<DateTime> dates,@JsonKey(readValue: _readKind) String kind, String? description,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? startsAt,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? endsAt, bool isAllDay, String? location, String? uid, Map<String, Object?>? sourceLinks,@JsonKey(fromJson: _normalizeType) String type
});




}
/// @nodoc
class __$CalendarSchedulePartCopyWithImpl<$Res>
    implements _$CalendarSchedulePartCopyWith<$Res> {
  __$CalendarSchedulePartCopyWithImpl(this._self, this._then);

  final _CalendarSchedulePart _self;
  final $Res Function(_CalendarSchedulePart) _then;

/// Create a copy of CalendarSchedulePart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? dates = null,Object? kind = null,Object? description = freezed,Object? startsAt = freezed,Object? endsAt = freezed,Object? isAllDay = null,Object? location = freezed,Object? uid = freezed,Object? sourceLinks = freezed,Object? type = null,}) {
  return _then(_CalendarSchedulePart(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAllDay: null == isAllDay ? _self.isAllDay : isAllDay // ignore: cast_nullable_to_non_nullable
as bool,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,sourceLinks: freezed == sourceLinks ? _self._sourceLinks : sourceLinks // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
