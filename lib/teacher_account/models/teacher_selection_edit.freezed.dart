// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_selection_edit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherSelectionEdit {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSelectionEdit);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherSelectionEdit()';
}


}

/// @nodoc
class $TeacherSelectionEditCopyWith<$Res>  {
$TeacherSelectionEditCopyWith(TeacherSelectionEdit _, $Res Function(TeacherSelectionEdit) __);
}


/// Adds pattern-matching-related methods to [TeacherSelectionEdit].
extension TeacherSelectionEditPatterns on TeacherSelectionEdit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TeacherSelectionKeep value)?  keep,TResult Function( TeacherSelectionSelect value)?  select,TResult Function( TeacherSelectionClear value)?  clear,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TeacherSelectionKeep() when keep != null:
return keep(_that);case TeacherSelectionSelect() when select != null:
return select(_that);case TeacherSelectionClear() when clear != null:
return clear(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TeacherSelectionKeep value)  keep,required TResult Function( TeacherSelectionSelect value)  select,required TResult Function( TeacherSelectionClear value)  clear,}){
final _that = this;
switch (_that) {
case TeacherSelectionKeep():
return keep(_that);case TeacherSelectionSelect():
return select(_that);case TeacherSelectionClear():
return clear(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TeacherSelectionKeep value)?  keep,TResult? Function( TeacherSelectionSelect value)?  select,TResult? Function( TeacherSelectionClear value)?  clear,}){
final _that = this;
switch (_that) {
case TeacherSelectionKeep() when keep != null:
return keep(_that);case TeacherSelectionSelect() when select != null:
return select(_that);case TeacherSelectionClear() when clear != null:
return clear(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  keep,TResult Function( Teacher teacher)?  select,TResult Function()?  clear,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TeacherSelectionKeep() when keep != null:
return keep();case TeacherSelectionSelect() when select != null:
return select(_that.teacher);case TeacherSelectionClear() when clear != null:
return clear();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  keep,required TResult Function( Teacher teacher)  select,required TResult Function()  clear,}) {final _that = this;
switch (_that) {
case TeacherSelectionKeep():
return keep();case TeacherSelectionSelect():
return select(_that.teacher);case TeacherSelectionClear():
return clear();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  keep,TResult? Function( Teacher teacher)?  select,TResult? Function()?  clear,}) {final _that = this;
switch (_that) {
case TeacherSelectionKeep() when keep != null:
return keep();case TeacherSelectionSelect() when select != null:
return select(_that.teacher);case TeacherSelectionClear() when clear != null:
return clear();case _:
  return null;

}
}

}

/// @nodoc


class TeacherSelectionKeep implements TeacherSelectionEdit {
  const TeacherSelectionKeep();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSelectionKeep);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherSelectionEdit.keep()';
}


}




/// @nodoc


class TeacherSelectionSelect implements TeacherSelectionEdit {
  const TeacherSelectionSelect(this.teacher);


 final  Teacher teacher;

/// Create a copy of TeacherSelectionEdit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherSelectionSelectCopyWith<TeacherSelectionSelect> get copyWith => _$TeacherSelectionSelectCopyWithImpl<TeacherSelectionSelect>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSelectionSelect&&(identical(other.teacher, teacher) || other.teacher == teacher));
}


@override
int get hashCode => Object.hash(runtimeType,teacher);

@override
String toString() {
  return 'TeacherSelectionEdit.select(teacher: $teacher)';
}


}

/// @nodoc
abstract mixin class $TeacherSelectionSelectCopyWith<$Res> implements $TeacherSelectionEditCopyWith<$Res> {
  factory $TeacherSelectionSelectCopyWith(TeacherSelectionSelect value, $Res Function(TeacherSelectionSelect) _then) = _$TeacherSelectionSelectCopyWithImpl;
@useResult
$Res call({
 Teacher teacher
});


$TeacherCopyWith<$Res> get teacher;

}
/// @nodoc
class _$TeacherSelectionSelectCopyWithImpl<$Res>
    implements $TeacherSelectionSelectCopyWith<$Res> {
  _$TeacherSelectionSelectCopyWithImpl(this._self, this._then);

  final TeacherSelectionSelect _self;
  final $Res Function(TeacherSelectionSelect) _then;

/// Create a copy of TeacherSelectionEdit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? teacher = null,}) {
  return _then(TeacherSelectionSelect(
null == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as Teacher,
  ));
}

/// Create a copy of TeacherSelectionEdit
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


class TeacherSelectionClear implements TeacherSelectionEdit {
  const TeacherSelectionClear();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherSelectionClear);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherSelectionEdit.clear()';
}


}




// dart format on
