// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_note_document_save_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupNoteDocumentSaveResult {

 int get revision;@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime get updatedAt; bool get conflict; List<Object?> get document; String get content;
/// Create a copy of GroupNoteDocumentSaveResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupNoteDocumentSaveResultCopyWith<GroupNoteDocumentSaveResult> get copyWith => _$GroupNoteDocumentSaveResultCopyWithImpl<GroupNoteDocumentSaveResult>(this as GroupNoteDocumentSaveResult, _$identity);

  /// Serializes this GroupNoteDocumentSaveResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupNoteDocumentSaveResult&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.conflict, conflict) || other.conflict == conflict)&&const DeepCollectionEquality().equals(other.document, document)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revision,updatedAt,conflict,const DeepCollectionEquality().hash(document),content);

@override
String toString() {
  return 'GroupNoteDocumentSaveResult(revision: $revision, updatedAt: $updatedAt, conflict: $conflict, document: $document, content: $content)';
}


}

/// @nodoc
abstract mixin class $GroupNoteDocumentSaveResultCopyWith<$Res>  {
  factory $GroupNoteDocumentSaveResultCopyWith(GroupNoteDocumentSaveResult value, $Res Function(GroupNoteDocumentSaveResult) _then) = _$GroupNoteDocumentSaveResultCopyWithImpl;
@useResult
$Res call({
 int revision,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime updatedAt, bool conflict, List<Object?> document, String content
});




}
/// @nodoc
class _$GroupNoteDocumentSaveResultCopyWithImpl<$Res>
    implements $GroupNoteDocumentSaveResultCopyWith<$Res> {
  _$GroupNoteDocumentSaveResultCopyWithImpl(this._self, this._then);

  final GroupNoteDocumentSaveResult _self;
  final $Res Function(GroupNoteDocumentSaveResult) _then;

/// Create a copy of GroupNoteDocumentSaveResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revision = null,Object? updatedAt = null,Object? conflict = null,Object? document = null,Object? content = null,}) {
  return _then(_self.copyWith(
revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,conflict: null == conflict ? _self.conflict : conflict // ignore: cast_nullable_to_non_nullable
as bool,document: null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as List<Object?>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupNoteDocumentSaveResult].
extension GroupNoteDocumentSaveResultPatterns on GroupNoteDocumentSaveResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupNoteDocumentSaveResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupNoteDocumentSaveResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupNoteDocumentSaveResult value)  $default,){
final _that = this;
switch (_that) {
case _GroupNoteDocumentSaveResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupNoteDocumentSaveResult value)?  $default,){
final _that = this;
switch (_that) {
case _GroupNoteDocumentSaveResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int revision, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime updatedAt,  bool conflict,  List<Object?> document,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupNoteDocumentSaveResult() when $default != null:
return $default(_that.revision,_that.updatedAt,_that.conflict,_that.document,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int revision, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime updatedAt,  bool conflict,  List<Object?> document,  String content)  $default,) {final _that = this;
switch (_that) {
case _GroupNoteDocumentSaveResult():
return $default(_that.revision,_that.updatedAt,_that.conflict,_that.document,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int revision, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime updatedAt,  bool conflict,  List<Object?> document,  String content)?  $default,) {final _that = this;
switch (_that) {
case _GroupNoteDocumentSaveResult() when $default != null:
return $default(_that.revision,_that.updatedAt,_that.conflict,_that.document,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupNoteDocumentSaveResult implements GroupNoteDocumentSaveResult {
  const _GroupNoteDocumentSaveResult({required this.revision, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) required this.updatedAt, this.conflict = false, final  List<Object?> document = const <Object?>[], this.content = ''}): _document = document;
  factory _GroupNoteDocumentSaveResult.fromJson(Map<String, dynamic> json) => _$GroupNoteDocumentSaveResultFromJson(json);

@override final  int revision;
@override@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) final  DateTime updatedAt;
@override@JsonKey() final  bool conflict;
 final  List<Object?> _document;
@override@JsonKey() List<Object?> get document {
  if (_document is EqualUnmodifiableListView) return _document;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_document);
}

@override@JsonKey() final  String content;

/// Create a copy of GroupNoteDocumentSaveResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupNoteDocumentSaveResultCopyWith<_GroupNoteDocumentSaveResult> get copyWith => __$GroupNoteDocumentSaveResultCopyWithImpl<_GroupNoteDocumentSaveResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupNoteDocumentSaveResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupNoteDocumentSaveResult&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.conflict, conflict) || other.conflict == conflict)&&const DeepCollectionEquality().equals(other._document, _document)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revision,updatedAt,conflict,const DeepCollectionEquality().hash(_document),content);

@override
String toString() {
  return 'GroupNoteDocumentSaveResult(revision: $revision, updatedAt: $updatedAt, conflict: $conflict, document: $document, content: $content)';
}


}

/// @nodoc
abstract mixin class _$GroupNoteDocumentSaveResultCopyWith<$Res> implements $GroupNoteDocumentSaveResultCopyWith<$Res> {
  factory _$GroupNoteDocumentSaveResultCopyWith(_GroupNoteDocumentSaveResult value, $Res Function(_GroupNoteDocumentSaveResult) _then) = __$GroupNoteDocumentSaveResultCopyWithImpl;
@override @useResult
$Res call({
 int revision,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime updatedAt, bool conflict, List<Object?> document, String content
});




}
/// @nodoc
class __$GroupNoteDocumentSaveResultCopyWithImpl<$Res>
    implements _$GroupNoteDocumentSaveResultCopyWith<$Res> {
  __$GroupNoteDocumentSaveResultCopyWithImpl(this._self, this._then);

  final _GroupNoteDocumentSaveResult _self;
  final $Res Function(_GroupNoteDocumentSaveResult) _then;

/// Create a copy of GroupNoteDocumentSaveResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revision = null,Object? updatedAt = null,Object? conflict = null,Object? document = null,Object? content = null,}) {
  return _then(_GroupNoteDocumentSaveResult(
revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,conflict: null == conflict ? _self.conflict : conflict // ignore: cast_nullable_to_non_nullable
as bool,document: null == document ? _self._document : document // ignore: cast_nullable_to_non_nullable
as List<Object?>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
