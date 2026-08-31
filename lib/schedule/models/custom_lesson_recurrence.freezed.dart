// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_lesson_recurrence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
CustomLessonRecurrence _$CustomLessonRecurrenceFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'weekly':
          return CustomLessonWeeklyRecurrence.fromJson(
            json
          );
                case 'dates':
          return CustomLessonDatesRecurrence.fromJson(
            json
          );

          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'CustomLessonRecurrence',
  'Invalid union type "${json['type']}"!'
);
        }

}

/// @nodoc
mixin _$CustomLessonRecurrence {



  /// Serializes this CustomLessonRecurrence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomLessonRecurrence);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CustomLessonRecurrence()';
}


}

/// @nodoc
class $CustomLessonRecurrenceCopyWith<$Res>  {
$CustomLessonRecurrenceCopyWith(CustomLessonRecurrence _, $Res Function(CustomLessonRecurrence) __);
}


/// Adds pattern-matching-related methods to [CustomLessonRecurrence].
extension CustomLessonRecurrencePatterns on CustomLessonRecurrence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CustomLessonWeeklyRecurrence value)?  weekly,TResult Function( CustomLessonDatesRecurrence value)?  dates,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CustomLessonWeeklyRecurrence() when weekly != null:
return weekly(_that);case CustomLessonDatesRecurrence() when dates != null:
return dates(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CustomLessonWeeklyRecurrence value)  weekly,required TResult Function( CustomLessonDatesRecurrence value)  dates,}){
final _that = this;
switch (_that) {
case CustomLessonWeeklyRecurrence():
return weekly(_that);case CustomLessonDatesRecurrence():
return dates(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CustomLessonWeeklyRecurrence value)?  weekly,TResult? Function( CustomLessonDatesRecurrence value)?  dates,}){
final _that = this;
switch (_that) {
case CustomLessonWeeklyRecurrence() when weekly != null:
return weekly(_that);case CustomLessonDatesRecurrence() when dates != null:
return dates(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int weekday,  CustomLessonWeekPattern pattern)?  weekly,TResult Function( List<DateTime> dates)?  dates,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CustomLessonWeeklyRecurrence() when weekly != null:
return weekly(_that.weekday,_that.pattern);case CustomLessonDatesRecurrence() when dates != null:
return dates(_that.dates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int weekday,  CustomLessonWeekPattern pattern)  weekly,required TResult Function( List<DateTime> dates)  dates,}) {final _that = this;
switch (_that) {
case CustomLessonWeeklyRecurrence():
return weekly(_that.weekday,_that.pattern);case CustomLessonDatesRecurrence():
return dates(_that.dates);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int weekday,  CustomLessonWeekPattern pattern)?  weekly,TResult? Function( List<DateTime> dates)?  dates,}) {final _that = this;
switch (_that) {
case CustomLessonWeeklyRecurrence() when weekly != null:
return weekly(_that.weekday,_that.pattern);case CustomLessonDatesRecurrence() when dates != null:
return dates(_that.dates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class CustomLessonWeeklyRecurrence extends CustomLessonRecurrence {
  const CustomLessonWeeklyRecurrence({required this.weekday, this.pattern = CustomLessonWeekPattern.every, final  String? $type}): $type = $type ?? 'weekly',super._();
  factory CustomLessonWeeklyRecurrence.fromJson(Map<String, dynamic> json) => _$CustomLessonWeeklyRecurrenceFromJson(json);

 final  int weekday;
@JsonKey() final  CustomLessonWeekPattern pattern;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of CustomLessonRecurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomLessonWeeklyRecurrenceCopyWith<CustomLessonWeeklyRecurrence> get copyWith => _$CustomLessonWeeklyRecurrenceCopyWithImpl<CustomLessonWeeklyRecurrence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomLessonWeeklyRecurrenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomLessonWeeklyRecurrence&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.pattern, pattern) || other.pattern == pattern));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekday,pattern);

@override
String toString() {
  return 'CustomLessonRecurrence.weekly(weekday: $weekday, pattern: $pattern)';
}


}

/// @nodoc
abstract mixin class $CustomLessonWeeklyRecurrenceCopyWith<$Res> implements $CustomLessonRecurrenceCopyWith<$Res> {
  factory $CustomLessonWeeklyRecurrenceCopyWith(CustomLessonWeeklyRecurrence value, $Res Function(CustomLessonWeeklyRecurrence) _then) = _$CustomLessonWeeklyRecurrenceCopyWithImpl;
@useResult
$Res call({
 int weekday, CustomLessonWeekPattern pattern
});




}
/// @nodoc
class _$CustomLessonWeeklyRecurrenceCopyWithImpl<$Res>
    implements $CustomLessonWeeklyRecurrenceCopyWith<$Res> {
  _$CustomLessonWeeklyRecurrenceCopyWithImpl(this._self, this._then);

  final CustomLessonWeeklyRecurrence _self;
  final $Res Function(CustomLessonWeeklyRecurrence) _then;

/// Create a copy of CustomLessonRecurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? pattern = null,}) {
  return _then(CustomLessonWeeklyRecurrence(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as CustomLessonWeekPattern,
  ));
}


}

/// @nodoc
@JsonSerializable()

class CustomLessonDatesRecurrence extends CustomLessonRecurrence {
  const CustomLessonDatesRecurrence({required final  List<DateTime> dates, final  String? $type}): _dates = dates,$type = $type ?? 'dates',super._();
  factory CustomLessonDatesRecurrence.fromJson(Map<String, dynamic> json) => _$CustomLessonDatesRecurrenceFromJson(json);

 final  List<DateTime> _dates;
 List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of CustomLessonRecurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomLessonDatesRecurrenceCopyWith<CustomLessonDatesRecurrence> get copyWith => _$CustomLessonDatesRecurrenceCopyWithImpl<CustomLessonDatesRecurrence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomLessonDatesRecurrenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomLessonDatesRecurrence&&const DeepCollectionEquality().equals(other._dates, _dates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dates));

@override
String toString() {
  return 'CustomLessonRecurrence.dates(dates: $dates)';
}


}

/// @nodoc
abstract mixin class $CustomLessonDatesRecurrenceCopyWith<$Res> implements $CustomLessonRecurrenceCopyWith<$Res> {
  factory $CustomLessonDatesRecurrenceCopyWith(CustomLessonDatesRecurrence value, $Res Function(CustomLessonDatesRecurrence) _then) = _$CustomLessonDatesRecurrenceCopyWithImpl;
@useResult
$Res call({
 List<DateTime> dates
});




}
/// @nodoc
class _$CustomLessonDatesRecurrenceCopyWithImpl<$Res>
    implements $CustomLessonDatesRecurrenceCopyWith<$Res> {
  _$CustomLessonDatesRecurrenceCopyWithImpl(this._self, this._then);

  final CustomLessonDatesRecurrence _self;
  final $Res Function(CustomLessonDatesRecurrence) _then;

/// Create a copy of CustomLessonRecurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dates = null,}) {
  return _then(CustomLessonDatesRecurrence(
dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,
  ));
}


}

// dart format on
