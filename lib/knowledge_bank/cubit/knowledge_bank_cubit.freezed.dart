// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledge_bank_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KnowledgeBankState {

 KnowledgeBankStatus get status; UserGamificationProfile get profile; List<StudyMaterial> get materials; List<MaterialAuthor> get authors; String get type;
/// Create a copy of KnowledgeBankState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnowledgeBankStateCopyWith<KnowledgeBankState> get copyWith => _$KnowledgeBankStateCopyWithImpl<KnowledgeBankState>(this as KnowledgeBankState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnowledgeBankState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.materials, materials)&&const DeepCollectionEquality().equals(other.authors, authors)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,status,profile,const DeepCollectionEquality().hash(materials),const DeepCollectionEquality().hash(authors),type);

@override
String toString() {
  return 'KnowledgeBankState(status: $status, profile: $profile, materials: $materials, authors: $authors, type: $type)';
}


}

/// @nodoc
abstract mixin class $KnowledgeBankStateCopyWith<$Res>  {
  factory $KnowledgeBankStateCopyWith(KnowledgeBankState value, $Res Function(KnowledgeBankState) _then) = _$KnowledgeBankStateCopyWithImpl;
@useResult
$Res call({
 KnowledgeBankStatus status, UserGamificationProfile profile, List<StudyMaterial> materials, List<MaterialAuthor> authors, String type
});


$UserGamificationProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$KnowledgeBankStateCopyWithImpl<$Res>
    implements $KnowledgeBankStateCopyWith<$Res> {
  _$KnowledgeBankStateCopyWithImpl(this._self, this._then);

  final KnowledgeBankState _self;
  final $Res Function(KnowledgeBankState) _then;

/// Create a copy of KnowledgeBankState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? profile = null,Object? materials = null,Object? authors = null,Object? type = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as KnowledgeBankStatus,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserGamificationProfile,materials: null == materials ? _self.materials : materials // ignore: cast_nullable_to_non_nullable
as List<StudyMaterial>,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<MaterialAuthor>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of KnowledgeBankState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserGamificationProfileCopyWith<$Res> get profile {

  return $UserGamificationProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [KnowledgeBankState].
extension KnowledgeBankStatePatterns on KnowledgeBankState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KnowledgeBankState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KnowledgeBankState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KnowledgeBankState value)  $default,){
final _that = this;
switch (_that) {
case _KnowledgeBankState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KnowledgeBankState value)?  $default,){
final _that = this;
switch (_that) {
case _KnowledgeBankState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KnowledgeBankStatus status,  UserGamificationProfile profile,  List<StudyMaterial> materials,  List<MaterialAuthor> authors,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KnowledgeBankState() when $default != null:
return $default(_that.status,_that.profile,_that.materials,_that.authors,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KnowledgeBankStatus status,  UserGamificationProfile profile,  List<StudyMaterial> materials,  List<MaterialAuthor> authors,  String type)  $default,) {final _that = this;
switch (_that) {
case _KnowledgeBankState():
return $default(_that.status,_that.profile,_that.materials,_that.authors,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KnowledgeBankStatus status,  UserGamificationProfile profile,  List<StudyMaterial> materials,  List<MaterialAuthor> authors,  String type)?  $default,) {final _that = this;
switch (_that) {
case _KnowledgeBankState() when $default != null:
return $default(_that.status,_that.profile,_that.materials,_that.authors,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _KnowledgeBankState extends KnowledgeBankState {
  const _KnowledgeBankState({this.status = KnowledgeBankStatus.initial, this.profile = UserGamificationProfile.empty, final  List<StudyMaterial> materials = const <StudyMaterial>[], final  List<MaterialAuthor> authors = const <MaterialAuthor>[], this.type = 'all'}): _materials = materials,_authors = authors,super._();


@override@JsonKey() final  KnowledgeBankStatus status;
@override@JsonKey() final  UserGamificationProfile profile;
 final  List<StudyMaterial> _materials;
@override@JsonKey() List<StudyMaterial> get materials {
  if (_materials is EqualUnmodifiableListView) return _materials;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_materials);
}

 final  List<MaterialAuthor> _authors;
@override@JsonKey() List<MaterialAuthor> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override@JsonKey() final  String type;

/// Create a copy of KnowledgeBankState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnowledgeBankStateCopyWith<_KnowledgeBankState> get copyWith => __$KnowledgeBankStateCopyWithImpl<_KnowledgeBankState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnowledgeBankState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other._materials, _materials)&&const DeepCollectionEquality().equals(other._authors, _authors)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,status,profile,const DeepCollectionEquality().hash(_materials),const DeepCollectionEquality().hash(_authors),type);

@override
String toString() {
  return 'KnowledgeBankState(status: $status, profile: $profile, materials: $materials, authors: $authors, type: $type)';
}


}

/// @nodoc
abstract mixin class _$KnowledgeBankStateCopyWith<$Res> implements $KnowledgeBankStateCopyWith<$Res> {
  factory _$KnowledgeBankStateCopyWith(_KnowledgeBankState value, $Res Function(_KnowledgeBankState) _then) = __$KnowledgeBankStateCopyWithImpl;
@override @useResult
$Res call({
 KnowledgeBankStatus status, UserGamificationProfile profile, List<StudyMaterial> materials, List<MaterialAuthor> authors, String type
});


@override $UserGamificationProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$KnowledgeBankStateCopyWithImpl<$Res>
    implements _$KnowledgeBankStateCopyWith<$Res> {
  __$KnowledgeBankStateCopyWithImpl(this._self, this._then);

  final _KnowledgeBankState _self;
  final $Res Function(_KnowledgeBankState) _then;

/// Create a copy of KnowledgeBankState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? profile = null,Object? materials = null,Object? authors = null,Object? type = null,}) {
  return _then(_KnowledgeBankState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as KnowledgeBankStatus,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserGamificationProfile,materials: null == materials ? _self._materials : materials // ignore: cast_nullable_to_non_nullable
as List<StudyMaterial>,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<MaterialAuthor>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of KnowledgeBankState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserGamificationProfileCopyWith<$Res> get profile {

  return $UserGamificationProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
