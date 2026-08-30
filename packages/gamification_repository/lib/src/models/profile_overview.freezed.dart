// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileOverview {

 AcademicProfile get academic; SemesterStats get semester; int? get groupRank; int? get groupSize;@JsonKey(fromJson: _streakHistoryFromJson) List<bool> get streakHistory; int get earnedBadges; int get totalBadges;
/// Create a copy of ProfileOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileOverviewCopyWith<ProfileOverview> get copyWith => _$ProfileOverviewCopyWithImpl<ProfileOverview>(this as ProfileOverview, _$identity);

  /// Serializes this ProfileOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileOverview&&(identical(other.academic, academic) || other.academic == academic)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.groupRank, groupRank) || other.groupRank == groupRank)&&(identical(other.groupSize, groupSize) || other.groupSize == groupSize)&&const DeepCollectionEquality().equals(other.streakHistory, streakHistory)&&(identical(other.earnedBadges, earnedBadges) || other.earnedBadges == earnedBadges)&&(identical(other.totalBadges, totalBadges) || other.totalBadges == totalBadges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,academic,semester,groupRank,groupSize,const DeepCollectionEquality().hash(streakHistory),earnedBadges,totalBadges);

@override
String toString() {
  return 'ProfileOverview(academic: $academic, semester: $semester, groupRank: $groupRank, groupSize: $groupSize, streakHistory: $streakHistory, earnedBadges: $earnedBadges, totalBadges: $totalBadges)';
}


}

/// @nodoc
abstract mixin class $ProfileOverviewCopyWith<$Res>  {
  factory $ProfileOverviewCopyWith(ProfileOverview value, $Res Function(ProfileOverview) _then) = _$ProfileOverviewCopyWithImpl;
@useResult
$Res call({
 AcademicProfile academic, SemesterStats semester, int? groupRank, int? groupSize,@JsonKey(fromJson: _streakHistoryFromJson) List<bool> streakHistory, int earnedBadges, int totalBadges
});


$AcademicProfileCopyWith<$Res> get academic;$SemesterStatsCopyWith<$Res> get semester;

}
/// @nodoc
class _$ProfileOverviewCopyWithImpl<$Res>
    implements $ProfileOverviewCopyWith<$Res> {
  _$ProfileOverviewCopyWithImpl(this._self, this._then);

  final ProfileOverview _self;
  final $Res Function(ProfileOverview) _then;

/// Create a copy of ProfileOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? academic = null,Object? semester = null,Object? groupRank = freezed,Object? groupSize = freezed,Object? streakHistory = null,Object? earnedBadges = null,Object? totalBadges = null,}) {
  return _then(_self.copyWith(
academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as AcademicProfile,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as SemesterStats,groupRank: freezed == groupRank ? _self.groupRank : groupRank // ignore: cast_nullable_to_non_nullable
as int?,groupSize: freezed == groupSize ? _self.groupSize : groupSize // ignore: cast_nullable_to_non_nullable
as int?,streakHistory: null == streakHistory ? _self.streakHistory : streakHistory // ignore: cast_nullable_to_non_nullable
as List<bool>,earnedBadges: null == earnedBadges ? _self.earnedBadges : earnedBadges // ignore: cast_nullable_to_non_nullable
as int,totalBadges: null == totalBadges ? _self.totalBadges : totalBadges // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ProfileOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicProfileCopyWith<$Res> get academic {

  return $AcademicProfileCopyWith<$Res>(_self.academic, (value) {
    return _then(_self.copyWith(academic: value));
  });
}/// Create a copy of ProfileOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SemesterStatsCopyWith<$Res> get semester {

  return $SemesterStatsCopyWith<$Res>(_self.semester, (value) {
    return _then(_self.copyWith(semester: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileOverview].
extension ProfileOverviewPatterns on ProfileOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileOverview value)  $default,){
final _that = this;
switch (_that) {
case _ProfileOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileOverview value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AcademicProfile academic,  SemesterStats semester,  int? groupRank,  int? groupSize, @JsonKey(fromJson: _streakHistoryFromJson)  List<bool> streakHistory,  int earnedBadges,  int totalBadges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileOverview() when $default != null:
return $default(_that.academic,_that.semester,_that.groupRank,_that.groupSize,_that.streakHistory,_that.earnedBadges,_that.totalBadges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AcademicProfile academic,  SemesterStats semester,  int? groupRank,  int? groupSize, @JsonKey(fromJson: _streakHistoryFromJson)  List<bool> streakHistory,  int earnedBadges,  int totalBadges)  $default,) {final _that = this;
switch (_that) {
case _ProfileOverview():
return $default(_that.academic,_that.semester,_that.groupRank,_that.groupSize,_that.streakHistory,_that.earnedBadges,_that.totalBadges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AcademicProfile academic,  SemesterStats semester,  int? groupRank,  int? groupSize, @JsonKey(fromJson: _streakHistoryFromJson)  List<bool> streakHistory,  int earnedBadges,  int totalBadges)?  $default,) {final _that = this;
switch (_that) {
case _ProfileOverview() when $default != null:
return $default(_that.academic,_that.semester,_that.groupRank,_that.groupSize,_that.streakHistory,_that.earnedBadges,_that.totalBadges);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ProfileOverview implements ProfileOverview {
  const _ProfileOverview({this.academic = AcademicProfile.empty, this.semester = SemesterStats.empty, this.groupRank, this.groupSize, @JsonKey(fromJson: _streakHistoryFromJson) final  List<bool> streakHistory = const <bool>[], this.earnedBadges = 0, this.totalBadges = 0}): _streakHistory = streakHistory;
  factory _ProfileOverview.fromJson(Map<String, dynamic> json) => _$ProfileOverviewFromJson(json);

@override@JsonKey() final  AcademicProfile academic;
@override@JsonKey() final  SemesterStats semester;
@override final  int? groupRank;
@override final  int? groupSize;
 final  List<bool> _streakHistory;
@override@JsonKey(fromJson: _streakHistoryFromJson) List<bool> get streakHistory {
  if (_streakHistory is EqualUnmodifiableListView) return _streakHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_streakHistory);
}

@override@JsonKey() final  int earnedBadges;
@override@JsonKey() final  int totalBadges;

/// Create a copy of ProfileOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileOverviewCopyWith<_ProfileOverview> get copyWith => __$ProfileOverviewCopyWithImpl<_ProfileOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileOverview&&(identical(other.academic, academic) || other.academic == academic)&&(identical(other.semester, semester) || other.semester == semester)&&(identical(other.groupRank, groupRank) || other.groupRank == groupRank)&&(identical(other.groupSize, groupSize) || other.groupSize == groupSize)&&const DeepCollectionEquality().equals(other._streakHistory, _streakHistory)&&(identical(other.earnedBadges, earnedBadges) || other.earnedBadges == earnedBadges)&&(identical(other.totalBadges, totalBadges) || other.totalBadges == totalBadges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,academic,semester,groupRank,groupSize,const DeepCollectionEquality().hash(_streakHistory),earnedBadges,totalBadges);

@override
String toString() {
  return 'ProfileOverview(academic: $academic, semester: $semester, groupRank: $groupRank, groupSize: $groupSize, streakHistory: $streakHistory, earnedBadges: $earnedBadges, totalBadges: $totalBadges)';
}


}

/// @nodoc
abstract mixin class _$ProfileOverviewCopyWith<$Res> implements $ProfileOverviewCopyWith<$Res> {
  factory _$ProfileOverviewCopyWith(_ProfileOverview value, $Res Function(_ProfileOverview) _then) = __$ProfileOverviewCopyWithImpl;
@override @useResult
$Res call({
 AcademicProfile academic, SemesterStats semester, int? groupRank, int? groupSize,@JsonKey(fromJson: _streakHistoryFromJson) List<bool> streakHistory, int earnedBadges, int totalBadges
});


@override $AcademicProfileCopyWith<$Res> get academic;@override $SemesterStatsCopyWith<$Res> get semester;

}
/// @nodoc
class __$ProfileOverviewCopyWithImpl<$Res>
    implements _$ProfileOverviewCopyWith<$Res> {
  __$ProfileOverviewCopyWithImpl(this._self, this._then);

  final _ProfileOverview _self;
  final $Res Function(_ProfileOverview) _then;

/// Create a copy of ProfileOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? academic = null,Object? semester = null,Object? groupRank = freezed,Object? groupSize = freezed,Object? streakHistory = null,Object? earnedBadges = null,Object? totalBadges = null,}) {
  return _then(_ProfileOverview(
academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as AcademicProfile,semester: null == semester ? _self.semester : semester // ignore: cast_nullable_to_non_nullable
as SemesterStats,groupRank: freezed == groupRank ? _self.groupRank : groupRank // ignore: cast_nullable_to_non_nullable
as int?,groupSize: freezed == groupSize ? _self.groupSize : groupSize // ignore: cast_nullable_to_non_nullable
as int?,streakHistory: null == streakHistory ? _self._streakHistory : streakHistory // ignore: cast_nullable_to_non_nullable
as List<bool>,earnedBadges: null == earnedBadges ? _self.earnedBadges : earnedBadges // ignore: cast_nullable_to_non_nullable
as int,totalBadges: null == totalBadges ? _self.totalBadges : totalBadges // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ProfileOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicProfileCopyWith<$Res> get academic {

  return $AcademicProfileCopyWith<$Res>(_self.academic, (value) {
    return _then(_self.copyWith(academic: value));
  });
}/// Create a copy of ProfileOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SemesterStatsCopyWith<$Res> get semester {

  return $SemesterStatsCopyWith<$Res>(_self.semester, (value) {
    return _then(_self.copyWith(semester: value));
  });
}
}


/// @nodoc
mixin _$SemesterStats {

 String? get label; String? get moduleLabel; double? get gpa;
/// Create a copy of SemesterStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SemesterStatsCopyWith<SemesterStats> get copyWith => _$SemesterStatsCopyWithImpl<SemesterStats>(this as SemesterStats, _$identity);

  /// Serializes this SemesterStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SemesterStats&&(identical(other.label, label) || other.label == label)&&(identical(other.moduleLabel, moduleLabel) || other.moduleLabel == moduleLabel)&&(identical(other.gpa, gpa) || other.gpa == gpa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,moduleLabel,gpa);

@override
String toString() {
  return 'SemesterStats(label: $label, moduleLabel: $moduleLabel, gpa: $gpa)';
}


}

/// @nodoc
abstract mixin class $SemesterStatsCopyWith<$Res>  {
  factory $SemesterStatsCopyWith(SemesterStats value, $Res Function(SemesterStats) _then) = _$SemesterStatsCopyWithImpl;
@useResult
$Res call({
 String? label, String? moduleLabel, double? gpa
});




}
/// @nodoc
class _$SemesterStatsCopyWithImpl<$Res>
    implements $SemesterStatsCopyWith<$Res> {
  _$SemesterStatsCopyWithImpl(this._self, this._then);

  final SemesterStats _self;
  final $Res Function(SemesterStats) _then;

/// Create a copy of SemesterStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = freezed,Object? moduleLabel = freezed,Object? gpa = freezed,}) {
  return _then(_self.copyWith(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,moduleLabel: freezed == moduleLabel ? _self.moduleLabel : moduleLabel // ignore: cast_nullable_to_non_nullable
as String?,gpa: freezed == gpa ? _self.gpa : gpa // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [SemesterStats].
extension SemesterStatsPatterns on SemesterStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SemesterStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SemesterStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SemesterStats value)  $default,){
final _that = this;
switch (_that) {
case _SemesterStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SemesterStats value)?  $default,){
final _that = this;
switch (_that) {
case _SemesterStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? label,  String? moduleLabel,  double? gpa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SemesterStats() when $default != null:
return $default(_that.label,_that.moduleLabel,_that.gpa);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? label,  String? moduleLabel,  double? gpa)  $default,) {final _that = this;
switch (_that) {
case _SemesterStats():
return $default(_that.label,_that.moduleLabel,_that.gpa);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? label,  String? moduleLabel,  double? gpa)?  $default,) {final _that = this;
switch (_that) {
case _SemesterStats() when $default != null:
return $default(_that.label,_that.moduleLabel,_that.gpa);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SemesterStats implements SemesterStats {
  const _SemesterStats({this.label, this.moduleLabel, this.gpa});
  factory _SemesterStats.fromJson(Map<String, dynamic> json) => _$SemesterStatsFromJson(json);

@override final  String? label;
@override final  String? moduleLabel;
@override final  double? gpa;

/// Create a copy of SemesterStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SemesterStatsCopyWith<_SemesterStats> get copyWith => __$SemesterStatsCopyWithImpl<_SemesterStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SemesterStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SemesterStats&&(identical(other.label, label) || other.label == label)&&(identical(other.moduleLabel, moduleLabel) || other.moduleLabel == moduleLabel)&&(identical(other.gpa, gpa) || other.gpa == gpa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,moduleLabel,gpa);

@override
String toString() {
  return 'SemesterStats(label: $label, moduleLabel: $moduleLabel, gpa: $gpa)';
}


}

/// @nodoc
abstract mixin class _$SemesterStatsCopyWith<$Res> implements $SemesterStatsCopyWith<$Res> {
  factory _$SemesterStatsCopyWith(_SemesterStats value, $Res Function(_SemesterStats) _then) = __$SemesterStatsCopyWithImpl;
@override @useResult
$Res call({
 String? label, String? moduleLabel, double? gpa
});




}
/// @nodoc
class __$SemesterStatsCopyWithImpl<$Res>
    implements _$SemesterStatsCopyWith<$Res> {
  __$SemesterStatsCopyWithImpl(this._self, this._then);

  final _SemesterStats _self;
  final $Res Function(_SemesterStats) _then;

/// Create a copy of SemesterStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = freezed,Object? moduleLabel = freezed,Object? gpa = freezed,}) {
  return _then(_SemesterStats(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,moduleLabel: freezed == moduleLabel ? _self.moduleLabel : moduleLabel // ignore: cast_nullable_to_non_nullable
as String?,gpa: freezed == gpa ? _self.gpa : gpa // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
