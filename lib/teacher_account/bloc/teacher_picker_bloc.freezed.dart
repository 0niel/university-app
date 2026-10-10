// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_picker_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherPickerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherPickerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherPickerEvent()';
}


}

/// @nodoc
class $TeacherPickerEventCopyWith<$Res>  {
$TeacherPickerEventCopyWith(TeacherPickerEvent _, $Res Function(TeacherPickerEvent) __);
}


/// Adds pattern-matching-related methods to [TeacherPickerEvent].
extension TeacherPickerEventPatterns on TeacherPickerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TeacherPickerSearchRequested value)?  searchRequested,TResult Function( TeacherPickerSelectionChanged value)?  selectionChanged,TResult Function( TeacherPickerTeacherSelected value)?  teacherSelected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TeacherPickerSearchRequested() when searchRequested != null:
return searchRequested(_that);case TeacherPickerSelectionChanged() when selectionChanged != null:
return selectionChanged(_that);case TeacherPickerTeacherSelected() when teacherSelected != null:
return teacherSelected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TeacherPickerSearchRequested value)  searchRequested,required TResult Function( TeacherPickerSelectionChanged value)  selectionChanged,required TResult Function( TeacherPickerTeacherSelected value)  teacherSelected,}){
final _that = this;
switch (_that) {
case TeacherPickerSearchRequested():
return searchRequested(_that);case TeacherPickerSelectionChanged():
return selectionChanged(_that);case TeacherPickerTeacherSelected():
return teacherSelected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TeacherPickerSearchRequested value)?  searchRequested,TResult? Function( TeacherPickerSelectionChanged value)?  selectionChanged,TResult? Function( TeacherPickerTeacherSelected value)?  teacherSelected,}){
final _that = this;
switch (_that) {
case TeacherPickerSearchRequested() when searchRequested != null:
return searchRequested(_that);case TeacherPickerSelectionChanged() when selectionChanged != null:
return selectionChanged(_that);case TeacherPickerTeacherSelected() when teacherSelected != null:
return teacherSelected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String query,  bool immediate)?  searchRequested,TResult Function( Teacher? teacher)?  selectionChanged,TResult Function( Teacher teacher)?  teacherSelected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TeacherPickerSearchRequested() when searchRequested != null:
return searchRequested(_that.query,_that.immediate);case TeacherPickerSelectionChanged() when selectionChanged != null:
return selectionChanged(_that.teacher);case TeacherPickerTeacherSelected() when teacherSelected != null:
return teacherSelected(_that.teacher);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String query,  bool immediate)  searchRequested,required TResult Function( Teacher? teacher)  selectionChanged,required TResult Function( Teacher teacher)  teacherSelected,}) {final _that = this;
switch (_that) {
case TeacherPickerSearchRequested():
return searchRequested(_that.query,_that.immediate);case TeacherPickerSelectionChanged():
return selectionChanged(_that.teacher);case TeacherPickerTeacherSelected():
return teacherSelected(_that.teacher);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String query,  bool immediate)?  searchRequested,TResult? Function( Teacher? teacher)?  selectionChanged,TResult? Function( Teacher teacher)?  teacherSelected,}) {final _that = this;
switch (_that) {
case TeacherPickerSearchRequested() when searchRequested != null:
return searchRequested(_that.query,_that.immediate);case TeacherPickerSelectionChanged() when selectionChanged != null:
return selectionChanged(_that.teacher);case TeacherPickerTeacherSelected() when teacherSelected != null:
return teacherSelected(_that.teacher);case _:
  return null;

}
}

}

/// @nodoc


class TeacherPickerSearchRequested implements TeacherPickerEvent {
  const TeacherPickerSearchRequested({required this.query, this.immediate = false});


 final  String query;
@JsonKey() final  bool immediate;

/// Create a copy of TeacherPickerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherPickerSearchRequestedCopyWith<TeacherPickerSearchRequested> get copyWith => _$TeacherPickerSearchRequestedCopyWithImpl<TeacherPickerSearchRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherPickerSearchRequested&&(identical(other.query, query) || other.query == query)&&(identical(other.immediate, immediate) || other.immediate == immediate));
}


@override
int get hashCode => Object.hash(runtimeType,query,immediate);

@override
String toString() {
  return 'TeacherPickerEvent.searchRequested(query: $query, immediate: $immediate)';
}


}

/// @nodoc
abstract mixin class $TeacherPickerSearchRequestedCopyWith<$Res> implements $TeacherPickerEventCopyWith<$Res> {
  factory $TeacherPickerSearchRequestedCopyWith(TeacherPickerSearchRequested value, $Res Function(TeacherPickerSearchRequested) _then) = _$TeacherPickerSearchRequestedCopyWithImpl;
@useResult
$Res call({
 String query, bool immediate
});




}
/// @nodoc
class _$TeacherPickerSearchRequestedCopyWithImpl<$Res>
    implements $TeacherPickerSearchRequestedCopyWith<$Res> {
  _$TeacherPickerSearchRequestedCopyWithImpl(this._self, this._then);

  final TeacherPickerSearchRequested _self;
  final $Res Function(TeacherPickerSearchRequested) _then;

/// Create a copy of TeacherPickerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? immediate = null,}) {
  return _then(TeacherPickerSearchRequested(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,immediate: null == immediate ? _self.immediate : immediate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class TeacherPickerSelectionChanged implements TeacherPickerEvent {
  const TeacherPickerSelectionChanged(this.teacher);


 final  Teacher? teacher;

/// Create a copy of TeacherPickerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherPickerSelectionChangedCopyWith<TeacherPickerSelectionChanged> get copyWith => _$TeacherPickerSelectionChangedCopyWithImpl<TeacherPickerSelectionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherPickerSelectionChanged&&(identical(other.teacher, teacher) || other.teacher == teacher));
}


@override
int get hashCode => Object.hash(runtimeType,teacher);

@override
String toString() {
  return 'TeacherPickerEvent.selectionChanged(teacher: $teacher)';
}


}

/// @nodoc
abstract mixin class $TeacherPickerSelectionChangedCopyWith<$Res> implements $TeacherPickerEventCopyWith<$Res> {
  factory $TeacherPickerSelectionChangedCopyWith(TeacherPickerSelectionChanged value, $Res Function(TeacherPickerSelectionChanged) _then) = _$TeacherPickerSelectionChangedCopyWithImpl;
@useResult
$Res call({
 Teacher? teacher
});


$TeacherCopyWith<$Res>? get teacher;

}
/// @nodoc
class _$TeacherPickerSelectionChangedCopyWithImpl<$Res>
    implements $TeacherPickerSelectionChangedCopyWith<$Res> {
  _$TeacherPickerSelectionChangedCopyWithImpl(this._self, this._then);

  final TeacherPickerSelectionChanged _self;
  final $Res Function(TeacherPickerSelectionChanged) _then;

/// Create a copy of TeacherPickerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? teacher = freezed,}) {
  return _then(TeacherPickerSelectionChanged(
freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as Teacher?,
  ));
}

/// Create a copy of TeacherPickerEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
    return null;
  }

  return $TeacherCopyWith<$Res>(_self.teacher!, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}
}

/// @nodoc


class TeacherPickerTeacherSelected implements TeacherPickerEvent {
  const TeacherPickerTeacherSelected(this.teacher);


 final  Teacher teacher;

/// Create a copy of TeacherPickerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherPickerTeacherSelectedCopyWith<TeacherPickerTeacherSelected> get copyWith => _$TeacherPickerTeacherSelectedCopyWithImpl<TeacherPickerTeacherSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherPickerTeacherSelected&&(identical(other.teacher, teacher) || other.teacher == teacher));
}


@override
int get hashCode => Object.hash(runtimeType,teacher);

@override
String toString() {
  return 'TeacherPickerEvent.teacherSelected(teacher: $teacher)';
}


}

/// @nodoc
abstract mixin class $TeacherPickerTeacherSelectedCopyWith<$Res> implements $TeacherPickerEventCopyWith<$Res> {
  factory $TeacherPickerTeacherSelectedCopyWith(TeacherPickerTeacherSelected value, $Res Function(TeacherPickerTeacherSelected) _then) = _$TeacherPickerTeacherSelectedCopyWithImpl;
@useResult
$Res call({
 Teacher teacher
});


$TeacherCopyWith<$Res> get teacher;

}
/// @nodoc
class _$TeacherPickerTeacherSelectedCopyWithImpl<$Res>
    implements $TeacherPickerTeacherSelectedCopyWith<$Res> {
  _$TeacherPickerTeacherSelectedCopyWithImpl(this._self, this._then);

  final TeacherPickerTeacherSelected _self;
  final $Res Function(TeacherPickerTeacherSelected) _then;

/// Create a copy of TeacherPickerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? teacher = null,}) {
  return _then(TeacherPickerTeacherSelected(
null == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as Teacher,
  ));
}

/// Create a copy of TeacherPickerEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res> get teacher {

  return $TeacherCopyWith<$Res>(_self.teacher, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}
}

/// @nodoc
mixin _$TeacherPickerState {

 String get query; Teacher? get selected; TeacherResource<List<Teacher>> get results; Set<String> get ambiguousNames;
/// Create a copy of TeacherPickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherPickerStateCopyWith<TeacherPickerState> get copyWith => _$TeacherPickerStateCopyWithImpl<TeacherPickerState>(this as TeacherPickerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherPickerState&&(identical(other.query, query) || other.query == query)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.results, results) || other.results == results)&&const DeepCollectionEquality().equals(other.ambiguousNames, ambiguousNames));
}


@override
int get hashCode => Object.hash(runtimeType,query,selected,results,const DeepCollectionEquality().hash(ambiguousNames));

@override
String toString() {
  return 'TeacherPickerState(query: $query, selected: $selected, results: $results, ambiguousNames: $ambiguousNames)';
}


}

/// @nodoc
abstract mixin class $TeacherPickerStateCopyWith<$Res>  {
  factory $TeacherPickerStateCopyWith(TeacherPickerState value, $Res Function(TeacherPickerState) _then) = _$TeacherPickerStateCopyWithImpl;
@useResult
$Res call({
 String query, Teacher? selected, TeacherResource<List<Teacher>> results, Set<String> ambiguousNames
});


$TeacherCopyWith<$Res>? get selected;$TeacherResourceCopyWith<List<Teacher>, $Res> get results;

}
/// @nodoc
class _$TeacherPickerStateCopyWithImpl<$Res>
    implements $TeacherPickerStateCopyWith<$Res> {
  _$TeacherPickerStateCopyWithImpl(this._self, this._then);

  final TeacherPickerState _self;
  final $Res Function(TeacherPickerState) _then;

/// Create a copy of TeacherPickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? selected = freezed,Object? results = null,Object? ambiguousNames = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as Teacher?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as TeacherResource<List<Teacher>>,ambiguousNames: null == ambiguousNames ? _self.ambiguousNames : ambiguousNames // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}
/// Create a copy of TeacherPickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res>? get selected {
    if (_self.selected == null) {
    return null;
  }

  return $TeacherCopyWith<$Res>(_self.selected!, (value) {
    return _then(_self.copyWith(selected: value));
  });
}/// Create a copy of TeacherPickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherResourceCopyWith<List<Teacher>, $Res> get results {

  return $TeacherResourceCopyWith<List<Teacher>, $Res>(_self.results, (value) {
    return _then(_self.copyWith(results: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeacherPickerState].
extension TeacherPickerStatePatterns on TeacherPickerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherPickerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherPickerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherPickerState value)  $default,){
final _that = this;
switch (_that) {
case _TeacherPickerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherPickerState value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherPickerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  Teacher? selected,  TeacherResource<List<Teacher>> results,  Set<String> ambiguousNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherPickerState() when $default != null:
return $default(_that.query,_that.selected,_that.results,_that.ambiguousNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  Teacher? selected,  TeacherResource<List<Teacher>> results,  Set<String> ambiguousNames)  $default,) {final _that = this;
switch (_that) {
case _TeacherPickerState():
return $default(_that.query,_that.selected,_that.results,_that.ambiguousNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  Teacher? selected,  TeacherResource<List<Teacher>> results,  Set<String> ambiguousNames)?  $default,) {final _that = this;
switch (_that) {
case _TeacherPickerState() when $default != null:
return $default(_that.query,_that.selected,_that.results,_that.ambiguousNames);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherPickerState extends TeacherPickerState {
  const _TeacherPickerState({this.query = '', this.selected, this.results = const TeacherResource<List<Teacher>>.idle(), final  Set<String> ambiguousNames = const <String>{}}): _ambiguousNames = ambiguousNames,super._();


@override@JsonKey() final  String query;
@override final  Teacher? selected;
@override@JsonKey() final  TeacherResource<List<Teacher>> results;
 final  Set<String> _ambiguousNames;
@override@JsonKey() Set<String> get ambiguousNames {
  if (_ambiguousNames is EqualUnmodifiableSetView) return _ambiguousNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_ambiguousNames);
}


/// Create a copy of TeacherPickerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherPickerStateCopyWith<_TeacherPickerState> get copyWith => __$TeacherPickerStateCopyWithImpl<_TeacherPickerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherPickerState&&(identical(other.query, query) || other.query == query)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.results, results) || other.results == results)&&const DeepCollectionEquality().equals(other._ambiguousNames, _ambiguousNames));
}


@override
int get hashCode => Object.hash(runtimeType,query,selected,results,const DeepCollectionEquality().hash(_ambiguousNames));

@override
String toString() {
  return 'TeacherPickerState(query: $query, selected: $selected, results: $results, ambiguousNames: $ambiguousNames)';
}


}

/// @nodoc
abstract mixin class _$TeacherPickerStateCopyWith<$Res> implements $TeacherPickerStateCopyWith<$Res> {
  factory _$TeacherPickerStateCopyWith(_TeacherPickerState value, $Res Function(_TeacherPickerState) _then) = __$TeacherPickerStateCopyWithImpl;
@override @useResult
$Res call({
 String query, Teacher? selected, TeacherResource<List<Teacher>> results, Set<String> ambiguousNames
});


@override $TeacherCopyWith<$Res>? get selected;@override $TeacherResourceCopyWith<List<Teacher>, $Res> get results;

}
/// @nodoc
class __$TeacherPickerStateCopyWithImpl<$Res>
    implements _$TeacherPickerStateCopyWith<$Res> {
  __$TeacherPickerStateCopyWithImpl(this._self, this._then);

  final _TeacherPickerState _self;
  final $Res Function(_TeacherPickerState) _then;

/// Create a copy of TeacherPickerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? selected = freezed,Object? results = null,Object? ambiguousNames = null,}) {
  return _then(_TeacherPickerState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as Teacher?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as TeacherResource<List<Teacher>>,ambiguousNames: null == ambiguousNames ? _self._ambiguousNames : ambiguousNames // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

/// Create a copy of TeacherPickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res>? get selected {
    if (_self.selected == null) {
    return null;
  }

  return $TeacherCopyWith<$Res>(_self.selected!, (value) {
    return _then(_self.copyWith(selected: value));
  });
}/// Create a copy of TeacherPickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherResourceCopyWith<List<Teacher>, $Res> get results {

  return $TeacherResourceCopyWith<List<Teacher>, $Res>(_self.results, (value) {
    return _then(_self.copyWith(results: value));
  });
}
}

// dart format on
