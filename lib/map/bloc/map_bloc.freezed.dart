// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MapEvent()';
}


}

/// @nodoc
class $MapEventCopyWith<$Res>  {
$MapEventCopyWith(MapEvent _, $Res Function(MapEvent) __);
}


/// Adds pattern-matching-related methods to [MapEvent].
extension MapEventPatterns on MapEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MapInitialized value)?  initialized,TResult Function( CampusSelected value)?  campusSelected,TResult Function( FloorSelected value)?  floorSelected,TResult Function( RoomTapped value)?  roomTapped,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MapInitialized() when initialized != null:
return initialized(_that);case CampusSelected() when campusSelected != null:
return campusSelected(_that);case FloorSelected() when floorSelected != null:
return floorSelected(_that);case RoomTapped() when roomTapped != null:
return roomTapped(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MapInitialized value)  initialized,required TResult Function( CampusSelected value)  campusSelected,required TResult Function( FloorSelected value)  floorSelected,required TResult Function( RoomTapped value)  roomTapped,}){
final _that = this;
switch (_that) {
case MapInitialized():
return initialized(_that);case CampusSelected():
return campusSelected(_that);case FloorSelected():
return floorSelected(_that);case RoomTapped():
return roomTapped(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MapInitialized value)?  initialized,TResult? Function( CampusSelected value)?  campusSelected,TResult? Function( FloorSelected value)?  floorSelected,TResult? Function( RoomTapped value)?  roomTapped,}){
final _that = this;
switch (_that) {
case MapInitialized() when initialized != null:
return initialized(_that);case CampusSelected() when campusSelected != null:
return campusSelected(_that);case FloorSelected() when floorSelected != null:
return floorSelected(_that);case RoomTapped() when roomTapped != null:
return roomTapped(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initialized,TResult Function( CampusModel campus)?  campusSelected,TResult Function( FloorModel floor,  CampusModel campus)?  floorSelected,TResult Function( String roomId)?  roomTapped,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MapInitialized() when initialized != null:
return initialized();case CampusSelected() when campusSelected != null:
return campusSelected(_that.campus);case FloorSelected() when floorSelected != null:
return floorSelected(_that.floor,_that.campus);case RoomTapped() when roomTapped != null:
return roomTapped(_that.roomId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initialized,required TResult Function( CampusModel campus)  campusSelected,required TResult Function( FloorModel floor,  CampusModel campus)  floorSelected,required TResult Function( String roomId)  roomTapped,}) {final _that = this;
switch (_that) {
case MapInitialized():
return initialized();case CampusSelected():
return campusSelected(_that.campus);case FloorSelected():
return floorSelected(_that.floor,_that.campus);case RoomTapped():
return roomTapped(_that.roomId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initialized,TResult? Function( CampusModel campus)?  campusSelected,TResult? Function( FloorModel floor,  CampusModel campus)?  floorSelected,TResult? Function( String roomId)?  roomTapped,}) {final _that = this;
switch (_that) {
case MapInitialized() when initialized != null:
return initialized();case CampusSelected() when campusSelected != null:
return campusSelected(_that.campus);case FloorSelected() when floorSelected != null:
return floorSelected(_that.floor,_that.campus);case RoomTapped() when roomTapped != null:
return roomTapped(_that.roomId);case _:
  return null;

}
}

}

/// @nodoc


class MapInitialized implements MapEvent {
  const MapInitialized();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapInitialized);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MapEvent.initialized()';
}


}




/// @nodoc


class CampusSelected implements MapEvent {
  const CampusSelected(this.campus);


 final  CampusModel campus;

/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampusSelectedCopyWith<CampusSelected> get copyWith => _$CampusSelectedCopyWithImpl<CampusSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampusSelected&&(identical(other.campus, campus) || other.campus == campus));
}


@override
int get hashCode => Object.hash(runtimeType,campus);

@override
String toString() {
  return 'MapEvent.campusSelected(campus: $campus)';
}


}

/// @nodoc
abstract mixin class $CampusSelectedCopyWith<$Res> implements $MapEventCopyWith<$Res> {
  factory $CampusSelectedCopyWith(CampusSelected value, $Res Function(CampusSelected) _then) = _$CampusSelectedCopyWithImpl;
@useResult
$Res call({
 CampusModel campus
});


$CampusModelCopyWith<$Res> get campus;

}
/// @nodoc
class _$CampusSelectedCopyWithImpl<$Res>
    implements $CampusSelectedCopyWith<$Res> {
  _$CampusSelectedCopyWithImpl(this._self, this._then);

  final CampusSelected _self;
  final $Res Function(CampusSelected) _then;

/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? campus = null,}) {
  return _then(CampusSelected(
null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as CampusModel,
  ));
}

/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampusModelCopyWith<$Res> get campus {

  return $CampusModelCopyWith<$Res>(_self.campus, (value) {
    return _then(_self.copyWith(campus: value));
  });
}
}

/// @nodoc


class FloorSelected implements MapEvent {
  const FloorSelected({required this.floor, required this.campus});


 final  FloorModel floor;
 final  CampusModel campus;

/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorSelectedCopyWith<FloorSelected> get copyWith => _$FloorSelectedCopyWithImpl<FloorSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorSelected&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.campus, campus) || other.campus == campus));
}


@override
int get hashCode => Object.hash(runtimeType,floor,campus);

@override
String toString() {
  return 'MapEvent.floorSelected(floor: $floor, campus: $campus)';
}


}

/// @nodoc
abstract mixin class $FloorSelectedCopyWith<$Res> implements $MapEventCopyWith<$Res> {
  factory $FloorSelectedCopyWith(FloorSelected value, $Res Function(FloorSelected) _then) = _$FloorSelectedCopyWithImpl;
@useResult
$Res call({
 FloorModel floor, CampusModel campus
});


$FloorModelCopyWith<$Res> get floor;$CampusModelCopyWith<$Res> get campus;

}
/// @nodoc
class _$FloorSelectedCopyWithImpl<$Res>
    implements $FloorSelectedCopyWith<$Res> {
  _$FloorSelectedCopyWithImpl(this._self, this._then);

  final FloorSelected _self;
  final $Res Function(FloorSelected) _then;

/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? floor = null,Object? campus = null,}) {
  return _then(FloorSelected(
floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as FloorModel,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as CampusModel,
  ));
}

/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloorModelCopyWith<$Res> get floor {

  return $FloorModelCopyWith<$Res>(_self.floor, (value) {
    return _then(_self.copyWith(floor: value));
  });
}/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampusModelCopyWith<$Res> get campus {

  return $CampusModelCopyWith<$Res>(_self.campus, (value) {
    return _then(_self.copyWith(campus: value));
  });
}
}

/// @nodoc


class RoomTapped implements MapEvent {
  const RoomTapped(this.roomId);


 final  String roomId;

/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomTappedCopyWith<RoomTapped> get copyWith => _$RoomTappedCopyWithImpl<RoomTapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomTapped&&(identical(other.roomId, roomId) || other.roomId == roomId));
}


@override
int get hashCode => Object.hash(runtimeType,roomId);

@override
String toString() {
  return 'MapEvent.roomTapped(roomId: $roomId)';
}


}

/// @nodoc
abstract mixin class $RoomTappedCopyWith<$Res> implements $MapEventCopyWith<$Res> {
  factory $RoomTappedCopyWith(RoomTapped value, $Res Function(RoomTapped) _then) = _$RoomTappedCopyWithImpl;
@useResult
$Res call({
 String roomId
});




}
/// @nodoc
class _$RoomTappedCopyWithImpl<$Res>
    implements $RoomTappedCopyWith<$Res> {
  _$RoomTappedCopyWithImpl(this._self, this._then);

  final RoomTapped _self;
  final $Res Function(RoomTapped) _then;

/// Create a copy of MapEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roomId = null,}) {
  return _then(RoomTapped(
null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$MapState {

 MapStatus get status; List<CampusModel> get availableCampuses; CampusModel? get selectedCampus; FloorModel? get selectedFloor; List<RoomModel> get rooms; Rect? get boundingRect; String? get errorMessage;
/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapStateCopyWith<MapState> get copyWith => _$MapStateCopyWithImpl<MapState>(this as MapState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.availableCampuses, availableCampuses)&&(identical(other.selectedCampus, selectedCampus) || other.selectedCampus == selectedCampus)&&(identical(other.selectedFloor, selectedFloor) || other.selectedFloor == selectedFloor)&&const DeepCollectionEquality().equals(other.rooms, rooms)&&(identical(other.boundingRect, boundingRect) || other.boundingRect == boundingRect)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(availableCampuses),selectedCampus,selectedFloor,const DeepCollectionEquality().hash(rooms),boundingRect,errorMessage);

@override
String toString() {
  return 'MapState(status: $status, availableCampuses: $availableCampuses, selectedCampus: $selectedCampus, selectedFloor: $selectedFloor, rooms: $rooms, boundingRect: $boundingRect, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $MapStateCopyWith<$Res>  {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) _then) = _$MapStateCopyWithImpl;
@useResult
$Res call({
 MapStatus status, List<CampusModel> availableCampuses, CampusModel? selectedCampus, FloorModel? selectedFloor, List<RoomModel> rooms, Rect? boundingRect, String? errorMessage
});


$CampusModelCopyWith<$Res>? get selectedCampus;$FloorModelCopyWith<$Res>? get selectedFloor;

}
/// @nodoc
class _$MapStateCopyWithImpl<$Res>
    implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._self, this._then);

  final MapState _self;
  final $Res Function(MapState) _then;

/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? availableCampuses = null,Object? selectedCampus = freezed,Object? selectedFloor = freezed,Object? rooms = null,Object? boundingRect = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MapStatus,availableCampuses: null == availableCampuses ? _self.availableCampuses : availableCampuses // ignore: cast_nullable_to_non_nullable
as List<CampusModel>,selectedCampus: freezed == selectedCampus ? _self.selectedCampus : selectedCampus // ignore: cast_nullable_to_non_nullable
as CampusModel?,selectedFloor: freezed == selectedFloor ? _self.selectedFloor : selectedFloor // ignore: cast_nullable_to_non_nullable
as FloorModel?,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<RoomModel>,boundingRect: freezed == boundingRect ? _self.boundingRect : boundingRect // ignore: cast_nullable_to_non_nullable
as Rect?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampusModelCopyWith<$Res>? get selectedCampus {
    if (_self.selectedCampus == null) {
    return null;
  }

  return $CampusModelCopyWith<$Res>(_self.selectedCampus!, (value) {
    return _then(_self.copyWith(selectedCampus: value));
  });
}/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloorModelCopyWith<$Res>? get selectedFloor {
    if (_self.selectedFloor == null) {
    return null;
  }

  return $FloorModelCopyWith<$Res>(_self.selectedFloor!, (value) {
    return _then(_self.copyWith(selectedFloor: value));
  });
}
}


/// Adds pattern-matching-related methods to [MapState].
extension MapStatePatterns on MapState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapState value)  $default,){
final _that = this;
switch (_that) {
case _MapState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapState value)?  $default,){
final _that = this;
switch (_that) {
case _MapState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapStatus status,  List<CampusModel> availableCampuses,  CampusModel? selectedCampus,  FloorModel? selectedFloor,  List<RoomModel> rooms,  Rect? boundingRect,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapState() when $default != null:
return $default(_that.status,_that.availableCampuses,_that.selectedCampus,_that.selectedFloor,_that.rooms,_that.boundingRect,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapStatus status,  List<CampusModel> availableCampuses,  CampusModel? selectedCampus,  FloorModel? selectedFloor,  List<RoomModel> rooms,  Rect? boundingRect,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _MapState():
return $default(_that.status,_that.availableCampuses,_that.selectedCampus,_that.selectedFloor,_that.rooms,_that.boundingRect,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapStatus status,  List<CampusModel> availableCampuses,  CampusModel? selectedCampus,  FloorModel? selectedFloor,  List<RoomModel> rooms,  Rect? boundingRect,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _MapState() when $default != null:
return $default(_that.status,_that.availableCampuses,_that.selectedCampus,_that.selectedFloor,_that.rooms,_that.boundingRect,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _MapState implements MapState {
  const _MapState({this.status = MapStatus.initial, final  List<CampusModel> availableCampuses = const <CampusModel>[], this.selectedCampus, this.selectedFloor, final  List<RoomModel> rooms = const <RoomModel>[], this.boundingRect, this.errorMessage}): _availableCampuses = availableCampuses,_rooms = rooms;


@override@JsonKey() final  MapStatus status;
 final  List<CampusModel> _availableCampuses;
@override@JsonKey() List<CampusModel> get availableCampuses {
  if (_availableCampuses is EqualUnmodifiableListView) return _availableCampuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableCampuses);
}

@override final  CampusModel? selectedCampus;
@override final  FloorModel? selectedFloor;
 final  List<RoomModel> _rooms;
@override@JsonKey() List<RoomModel> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}

@override final  Rect? boundingRect;
@override final  String? errorMessage;

/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapStateCopyWith<_MapState> get copyWith => __$MapStateCopyWithImpl<_MapState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._availableCampuses, _availableCampuses)&&(identical(other.selectedCampus, selectedCampus) || other.selectedCampus == selectedCampus)&&(identical(other.selectedFloor, selectedFloor) || other.selectedFloor == selectedFloor)&&const DeepCollectionEquality().equals(other._rooms, _rooms)&&(identical(other.boundingRect, boundingRect) || other.boundingRect == boundingRect)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_availableCampuses),selectedCampus,selectedFloor,const DeepCollectionEquality().hash(_rooms),boundingRect,errorMessage);

@override
String toString() {
  return 'MapState(status: $status, availableCampuses: $availableCampuses, selectedCampus: $selectedCampus, selectedFloor: $selectedFloor, rooms: $rooms, boundingRect: $boundingRect, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$MapStateCopyWith<$Res> implements $MapStateCopyWith<$Res> {
  factory _$MapStateCopyWith(_MapState value, $Res Function(_MapState) _then) = __$MapStateCopyWithImpl;
@override @useResult
$Res call({
 MapStatus status, List<CampusModel> availableCampuses, CampusModel? selectedCampus, FloorModel? selectedFloor, List<RoomModel> rooms, Rect? boundingRect, String? errorMessage
});


@override $CampusModelCopyWith<$Res>? get selectedCampus;@override $FloorModelCopyWith<$Res>? get selectedFloor;

}
/// @nodoc
class __$MapStateCopyWithImpl<$Res>
    implements _$MapStateCopyWith<$Res> {
  __$MapStateCopyWithImpl(this._self, this._then);

  final _MapState _self;
  final $Res Function(_MapState) _then;

/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? availableCampuses = null,Object? selectedCampus = freezed,Object? selectedFloor = freezed,Object? rooms = null,Object? boundingRect = freezed,Object? errorMessage = freezed,}) {
  return _then(_MapState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MapStatus,availableCampuses: null == availableCampuses ? _self._availableCampuses : availableCampuses // ignore: cast_nullable_to_non_nullable
as List<CampusModel>,selectedCampus: freezed == selectedCampus ? _self.selectedCampus : selectedCampus // ignore: cast_nullable_to_non_nullable
as CampusModel?,selectedFloor: freezed == selectedFloor ? _self.selectedFloor : selectedFloor // ignore: cast_nullable_to_non_nullable
as FloorModel?,rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<RoomModel>,boundingRect: freezed == boundingRect ? _self.boundingRect : boundingRect // ignore: cast_nullable_to_non_nullable
as Rect?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampusModelCopyWith<$Res>? get selectedCampus {
    if (_self.selectedCampus == null) {
    return null;
  }

  return $CampusModelCopyWith<$Res>(_self.selectedCampus!, (value) {
    return _then(_self.copyWith(selectedCampus: value));
  });
}/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloorModelCopyWith<$Res>? get selectedFloor {
    if (_self.selectedFloor == null) {
    return null;
  }

  return $FloorModelCopyWith<$Res>(_self.selectedFloor!, (value) {
    return _then(_self.copyWith(selectedFloor: value));
  });
}
}

// dart format on
