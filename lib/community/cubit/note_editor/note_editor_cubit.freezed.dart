// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_editor_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteEditorState {

 String get title; String get content; DateTime? get savedAt; NoteEditorStatus get status; List<String> get editors; int get revision; int get persistedRevision; int get serverRevision; bool get canDelete; bool get isDeleting;
/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorStateCopyWith<NoteEditorState> get copyWith => _$NoteEditorStateCopyWithImpl<NoteEditorState>(this as NoteEditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorState&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.editors, editors)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.persistedRevision, persistedRevision) || other.persistedRevision == persistedRevision)&&(identical(other.serverRevision, serverRevision) || other.serverRevision == serverRevision)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting));
}


@override
int get hashCode => Object.hash(runtimeType,title,content,savedAt,status,const DeepCollectionEquality().hash(editors),revision,persistedRevision,serverRevision,canDelete,isDeleting);

@override
String toString() {
  return 'NoteEditorState(title: $title, content: $content, savedAt: $savedAt, status: $status, editors: $editors, revision: $revision, persistedRevision: $persistedRevision, serverRevision: $serverRevision, canDelete: $canDelete, isDeleting: $isDeleting)';
}


}

/// @nodoc
abstract mixin class $NoteEditorStateCopyWith<$Res>  {
  factory $NoteEditorStateCopyWith(NoteEditorState value, $Res Function(NoteEditorState) _then) = _$NoteEditorStateCopyWithImpl;
@useResult
$Res call({
 String title, String content, DateTime? savedAt, NoteEditorStatus status, List<String> editors, int revision, int persistedRevision, int serverRevision, bool canDelete, bool isDeleting
});




}
/// @nodoc
class _$NoteEditorStateCopyWithImpl<$Res>
    implements $NoteEditorStateCopyWith<$Res> {
  _$NoteEditorStateCopyWithImpl(this._self, this._then);

  final NoteEditorState _self;
  final $Res Function(NoteEditorState) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = null,Object? savedAt = freezed,Object? status = null,Object? editors = null,Object? revision = null,Object? persistedRevision = null,Object? serverRevision = null,Object? canDelete = null,Object? isDeleting = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoteEditorStatus,editors: null == editors ? _self.editors : editors // ignore: cast_nullable_to_non_nullable
as List<String>,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,persistedRevision: null == persistedRevision ? _self.persistedRevision : persistedRevision // ignore: cast_nullable_to_non_nullable
as int,serverRevision: null == serverRevision ? _self.serverRevision : serverRevision // ignore: cast_nullable_to_non_nullable
as int,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteEditorState].
extension NoteEditorStatePatterns on NoteEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteEditorState value)  $default,){
final _that = this;
switch (_that) {
case _NoteEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _NoteEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String content,  DateTime? savedAt,  NoteEditorStatus status,  List<String> editors,  int revision,  int persistedRevision,  int serverRevision,  bool canDelete,  bool isDeleting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteEditorState() when $default != null:
return $default(_that.title,_that.content,_that.savedAt,_that.status,_that.editors,_that.revision,_that.persistedRevision,_that.serverRevision,_that.canDelete,_that.isDeleting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String content,  DateTime? savedAt,  NoteEditorStatus status,  List<String> editors,  int revision,  int persistedRevision,  int serverRevision,  bool canDelete,  bool isDeleting)  $default,) {final _that = this;
switch (_that) {
case _NoteEditorState():
return $default(_that.title,_that.content,_that.savedAt,_that.status,_that.editors,_that.revision,_that.persistedRevision,_that.serverRevision,_that.canDelete,_that.isDeleting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String content,  DateTime? savedAt,  NoteEditorStatus status,  List<String> editors,  int revision,  int persistedRevision,  int serverRevision,  bool canDelete,  bool isDeleting)?  $default,) {final _that = this;
switch (_that) {
case _NoteEditorState() when $default != null:
return $default(_that.title,_that.content,_that.savedAt,_that.status,_that.editors,_that.revision,_that.persistedRevision,_that.serverRevision,_that.canDelete,_that.isDeleting);case _:
  return null;

}
}

}

/// @nodoc


class _NoteEditorState extends NoteEditorState {
  const _NoteEditorState({required this.title, required this.content, this.savedAt, this.status = NoteEditorStatus.clean, final  List<String> editors = const <String>[], this.revision = 0, this.persistedRevision = 0, this.serverRevision = 0, this.canDelete = false, this.isDeleting = false}): _editors = editors,super._();


@override final  String title;
@override final  String content;
@override final  DateTime? savedAt;
@override@JsonKey() final  NoteEditorStatus status;
 final  List<String> _editors;
@override@JsonKey() List<String> get editors {
  if (_editors is EqualUnmodifiableListView) return _editors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_editors);
}

@override@JsonKey() final  int revision;
@override@JsonKey() final  int persistedRevision;
@override@JsonKey() final  int serverRevision;
@override@JsonKey() final  bool canDelete;
@override@JsonKey() final  bool isDeleting;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteEditorStateCopyWith<_NoteEditorState> get copyWith => __$NoteEditorStateCopyWithImpl<_NoteEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteEditorState&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._editors, _editors)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.persistedRevision, persistedRevision) || other.persistedRevision == persistedRevision)&&(identical(other.serverRevision, serverRevision) || other.serverRevision == serverRevision)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting));
}


@override
int get hashCode => Object.hash(runtimeType,title,content,savedAt,status,const DeepCollectionEquality().hash(_editors),revision,persistedRevision,serverRevision,canDelete,isDeleting);

@override
String toString() {
  return 'NoteEditorState(title: $title, content: $content, savedAt: $savedAt, status: $status, editors: $editors, revision: $revision, persistedRevision: $persistedRevision, serverRevision: $serverRevision, canDelete: $canDelete, isDeleting: $isDeleting)';
}


}

/// @nodoc
abstract mixin class _$NoteEditorStateCopyWith<$Res> implements $NoteEditorStateCopyWith<$Res> {
  factory _$NoteEditorStateCopyWith(_NoteEditorState value, $Res Function(_NoteEditorState) _then) = __$NoteEditorStateCopyWithImpl;
@override @useResult
$Res call({
 String title, String content, DateTime? savedAt, NoteEditorStatus status, List<String> editors, int revision, int persistedRevision, int serverRevision, bool canDelete, bool isDeleting
});




}
/// @nodoc
class __$NoteEditorStateCopyWithImpl<$Res>
    implements _$NoteEditorStateCopyWith<$Res> {
  __$NoteEditorStateCopyWithImpl(this._self, this._then);

  final _NoteEditorState _self;
  final $Res Function(_NoteEditorState) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,Object? savedAt = freezed,Object? status = null,Object? editors = null,Object? revision = null,Object? persistedRevision = null,Object? serverRevision = null,Object? canDelete = null,Object? isDeleting = null,}) {
  return _then(_NoteEditorState(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoteEditorStatus,editors: null == editors ? _self._editors : editors // ignore: cast_nullable_to_non_nullable
as List<String>,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,persistedRevision: null == persistedRevision ? _self.persistedRevision : persistedRevision // ignore: cast_nullable_to_non_nullable
as int,serverRevision: null == serverRevision ? _self.serverRevision : serverRevision // ignore: cast_nullable_to_non_nullable
as int,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
